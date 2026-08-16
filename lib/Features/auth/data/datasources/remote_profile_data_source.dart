import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/profile_data_source.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';

class RemoteProfileDataSource
    implements ProfileDataSource {
  final Dio dio;

  const RemoteProfileDataSource({
    required this.dio,
  });

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get(
        ApiEndpoints.representativeAccount,
      );

      return ProfileModel.fromJson(
        _extractProfilePayload(
          response.data,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(
          error,
          fallback:
              'تعذر تحميل بيانات الحساب',
        ),
      );
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String phone,
    required String email,
    Uint8List? imageBytes,
  }) async {
    try {
      dynamic body;

      if (imageBytes != null &&
          imageBytes.isNotEmpty) {
        body = FormData.fromMap({
          'phone': phone,
          'email': email,
          'image': MultipartFile.fromBytes(
            imageBytes,
            filename: 'profile.jpg',
          ),
        });
      } else {
        body = {
          'phone': phone,
          'email': email,
        };
      }

      await dio.patch(
        ApiEndpoints.representativeAccount,
        data: body,
      );

      // نعيد جلب بيانات الحساب كاملة لأن بعض
      // الـAPIs ترجع فقط الحقول التي تم تعديلها.
      return getProfile();
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(
          error,
          fallback:
              'تعذر حفظ بيانات الحساب',
        ),
      );
    }
  }

  Map<String, dynamic> _extractProfilePayload(
    dynamic responseData,
  ) {
    if (responseData is! Map) {
      throw Exception(
        'صيغة بيانات الحساب غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic data =
        root['data'] ??
        root['profile'] ??
        root['account'];

    if (data is Map) {
      final payload =
          Map<String, dynamic>.from(
        data,
      );

      final dynamic nestedProfile =
          payload['profile'];

      if (nestedProfile is Map) {
        return {
          ...payload,
          ...Map<String, dynamic>.from(
            nestedProfile,
          ),
        };
      }

      return payload;
    }

    return root;
  }

  String _handleDioError(
    DioException error, {
    required String fallback,
  }) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'] ??
          data['error'];

      if (message != null &&
          message
              .toString()
              .trim()
              .isNotEmpty) {
        return message
            .toString()
            .trim();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return fallback;
    }
  }@override
Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    await dio.patch(
      ApiEndpoints
          .representativeAccountPassword,
      data: {
        'current_password':
            currentPassword,
        'new_password':
            newPassword,
      },
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(
        error,
        fallback:
            'تعذر تغيير كلمة المرور',
      ),
    );
  }
}
}
