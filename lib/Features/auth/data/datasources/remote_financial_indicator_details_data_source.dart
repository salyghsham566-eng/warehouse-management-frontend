import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';

class RemoteFinancialIndicatorDetailsDataSource
    implements FinancialIndicatorDetailsDataSource {
  final Dio dio;

  RemoteFinancialIndicatorDetailsDataSource({
    required this.dio,
  });

  @override
  Future<FinancialIndicatorDetailsResponseModel>
      getIndicatorDetails({
    required String indicatorId,
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.financialIndicatorDetails(
          indicatorId,
        ),
        queryParameters: {
          'from_date': _formatDate(fromDate),
          'to_date': _formatDate(toDate),
          'region_id': regionId,
        },
      );

      if (response.data is! Map) {
        throw Exception(
          'صيغة استجابة تفاصيل المؤشر غير صحيحة',
        );
      }

      return FinancialIndicatorDetailsResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _handleDioError(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message =
          responseData['message'] ?? responseData['error'];

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
        return 'تعذر تحميل تفاصيل المؤشر المالي';
    }
  }
}