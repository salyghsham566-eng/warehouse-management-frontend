import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/financial_dashboard_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';

class FinancialDashboardRemoteDataSource
    implements FinancialDashboardDataSource {
  final Dio dio;

  FinancialDashboardRemoteDataSource({
    required this.dio,
  });

  @override
  Future<FinancialDashboardModel> getFinancialDashboard({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.financialDashboard,
        queryParameters: {
          'from_date': _formatDate(fromDate),
          'to_date': _formatDate(toDate),
          'region_id': regionId,
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة البيانات المالية غير صحيحة',
        );
      }

      return FinancialDashboardModel.fromJson(
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
        'حدث خطأ أثناء تحميل البيانات المالية',
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
        return 'تعذر الاتصال بالخادم، تحقق من الإنترنت';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل البيانات المالية';

      case DioExceptionType.cancel:
        return 'تم إلغاء طلب البيانات';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}