import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/login_data_source.dart';
import 'package:project_2/Features/auth/data/login_response.dart';

class RemoteLoginDataSource implements LoginDataSource {
  final Dio dio;

  const RemoteLoginDataSource({
    required this.dio,
  });

  @override
  Future<LoginResponse> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {
          'username_or_phone': usernameOrPhone,
          'password': password,
        },
      );

      final dynamic responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException(
          'صيغة استجابة تسجيل الدخول غير صحيحة',
        );
      }

      // يدعم:
      // {
      //   "token": "...",
      //   "user": {...}
      // }
      //
      // أو:
      // {
      //   "data": {
      //     "token": "...",
      //     "user": {...}
      //   }
      // }

      final dynamic data =
          responseData['data'] is Map<String, dynamic>
              ? responseData['data']
              : responseData;

      if (data is! Map<String, dynamic>) {
        throw const FormatException(
          'بيانات تسجيل الدخول غير صحيحة',
        );
      }

      return LoginResponse.fromJson(data);
    } on DioException catch (e) {
      String message = 'فشل تسجيل الدخول';

      final dynamic errorData = e.response?.data;

      if (errorData is Map<String, dynamic>) {
        final dynamic serverMessage = errorData['message'];

        if (serverMessage is String &&
            serverMessage.trim().isNotEmpty) {
          message = serverMessage;
        }
      }

      throw Exception(message);
    }
  }
}