import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_response.dart';
import 'package:project_2/Features/auth/data/models/collection_payments_response.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';

class RemoteCollectionPaymentDataSource
    implements CollectionPaymentDataSource {
  const RemoteCollectionPaymentDataSource({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<CollectionPaymentsResponse>
      getCollectionPayments() async {
    try {
      final response = await dio.get(
        ApiEndpoints.collectionPayments,
      );

      if (response.data is! Map) {
        throw Exception(
          'صيغة استجابة التحصيلات غير صحيحة',
        );
      }

      return CollectionPaymentsResponse.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _getDioErrorMessage(
          error,
          defaultMessage:
              'تعذر تحميل التحصيلات',
        ),
      );
    } catch (error) {
      throw Exception(
        _cleanError(error),
      );
    }
  }

  @override
  Future<CollectionPaymentResponse>
      createCollectionPayment(
    CreateCollectionPaymentRequest request,
  ) async {
    try {
      final Map<String, dynamic> fields =
          request.toFields();

      final String? imagePath =
          request.receiptImagePath?.trim();

      if (imagePath != null &&
          imagePath.isNotEmpty) {
        final File file = File(imagePath);

        if (!await file.exists()) {
          throw Exception(
            'صورة الوصل المحددة غير موجودة',
          );
        }

        fields['receipt_image'] =
            await MultipartFile.fromFile(
          imagePath,
          filename: file.uri.pathSegments.last,
        );
      }

      final response = await dio.post(
        ApiEndpoints.collectionPayments,
        data: FormData.fromMap(fields),
      );

      if (response.data is! Map) {
        throw Exception(
          'صيغة استجابة تسجيل الدفعة غير صحيحة',
        );
      }

      return CollectionPaymentResponse.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _getDioErrorMessage(
          error,
          defaultMessage:
              'تعذر تسجيل الدفعة',
        ),
      );
    } catch (error) {
      throw Exception(
        _cleanError(error),
      );
    }
  }

  String _getDioErrorMessage(
    DioException error, {
    required String defaultMessage,
  }) {
    final dynamic responseData =
        error.response?.data;

    if (responseData is Map) {
      final dynamic message =
          responseData['message'];

      if (message != null &&
          message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالإنترنت';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return defaultMessage;
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }
 @override
Future<CollectionPaymentModel>
    getCollectionPaymentDetails(
  String paymentId,
) async {
  try {
    final String normalizedPaymentId =
        paymentId.trim();

    if (normalizedPaymentId.isEmpty) {
      throw Exception('رقم الدفعة غير صالح');
    }

    final Response<dynamic> response =
        await dio.get(
      ApiEndpoints.collectionPaymentDetails(
        normalizedPaymentId,
      ),
    );

    if (response.data is! Map) {
      throw Exception(
        'صيغة استجابة تفاصيل الدفعة غير صحيحة',
      );
    }

    final Map<String, dynamic> responseMap =
        Map<String, dynamic>.from(
      response.data as Map,
    );

    final CollectionPaymentResponse
        paymentResponse =
        CollectionPaymentResponse.fromJson(
      responseMap,
    );

    if (!paymentResponse.success ||
        paymentResponse.payment == null) {
      throw Exception(
        paymentResponse.message.trim().isNotEmpty
            ? paymentResponse.message
            : 'لم يتم العثور على بيانات الدفعة',
      );
    }

    return paymentResponse.payment!;
  } on DioException catch (error) {
    throw Exception(
      _getDioErrorMessage(
        error,
        defaultMessage:
            'تعذر تحميل تفاصيل الدفعة',
      ),
    );
  } catch (error) {
    throw Exception(
      _cleanError(error),
    );
  }
}
String getDioErrorMessage(
  DioException error, {
  required String defaultMessage,
}) {
  final dynamic responseData =
      error.response?.data;

  if (responseData is Map) {
    final dynamic message =
        responseData['message'];

    if (message != null &&
        message.toString().trim().isNotEmpty) {
      return message.toString();
    }
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'انتهت مهلة الاتصال بالخادم';

    case DioExceptionType.connectionError:
      return 'تعذر الاتصال بالإنترنت';

    case DioExceptionType.cancel:
      return 'تم إلغاء الطلب';

    case DioExceptionType.badResponse:
      return error.response?.statusCode == 404
          ? 'لم يتم العثور على الدفعة'
          : defaultMessage;

    default:
      return defaultMessage;
  }
}
}