import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';

class RemotePharmacyAccountStatementDataSource
    implements PharmacyAccountStatementDataSource {
  final Dio dio;

  RemotePharmacyAccountStatementDataSource({
    required this.dio,
  });

  @override
  Future<PharmacyAccountStatementModel>
      getPharmacyAccountStatement({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.financialPharmacyStatement(
          pharmacyId,
        ),
        queryParameters: {
          'from_date': _formatDate(fromDate),
          'to_date': _formatDate(toDate),
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة كشف الحساب غير صحيحة',
        );
      }

      return PharmacyAccountStatementModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception(
        'حدث خطأ أثناء تحميل كشف الحساب',
      );
    }
  }

  String _formatDate(DateTime date) {
    final month =
        date.month.toString().padLeft(2, '0');

    final day =
        date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _handleDioError(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message =
          responseData['message'] ??
          responseData['error'];

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
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل كشف الحساب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}