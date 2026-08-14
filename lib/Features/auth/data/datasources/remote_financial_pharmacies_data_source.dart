import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

class RemoteFinancialPharmaciesDataSource
    implements FinancialPharmaciesDataSource {
  final Dio dio;

  RemoteFinancialPharmaciesDataSource({
    required this.dio,
  });

  @override
  Future<FinancialPharmaciesResponseModel>
      getFinancialPharmacies({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
    required FinancialPharmacySort sort,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.financialPharmacies,
        queryParameters: {
          'from_date': _formatDate(fromDate),
          'to_date': _formatDate(toDate),
          'region_id': regionId,
          'sort_by': sort.apiValue,
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة قائمة الصيدليات المالية غير صحيحة',
        );
      }

      return FinancialPharmaciesResponseModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
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

      default:
        return 'تعذر تحميل الصيدليات المالية';
    }
  }
}