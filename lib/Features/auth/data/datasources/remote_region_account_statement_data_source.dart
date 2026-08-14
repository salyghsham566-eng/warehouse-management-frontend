import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';

class RemoteRegionAccountStatementDataSource
    implements RegionAccountStatementDataSource {
  final Dio dio;

  RemoteRegionAccountStatementDataSource({
    required this.dio,
  });

  @override
  Future<RegionAccountStatementModel>
      getRegionAccountStatement({
    required String regionId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.financialRegionStatement,
        queryParameters: {
          'region_id': regionId,
          'from_date': _formatDate(fromDate),
          'to_date': _formatDate(toDate),
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة كشف حساب المنطقة غير صحيحة',
        );
      }

      return RegionAccountStatementModel.fromJson(
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
        'حدث خطأ أثناء تحميل كشف حساب المنطقة',
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
        return 'تعذر تحميل كشف حساب المنطقة';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}