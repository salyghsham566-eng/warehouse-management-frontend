import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';

import 'package:project_2/Features/auth/data/datasources/evaluation_data_source.dart';
import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';

import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';

class RemoteEvaluationDataSource
    implements EvaluationDataSource {
  final Dio dio;

  const RemoteEvaluationDataSource({
    required this.dio,
  });

  @override
  Future<EvaluationOverviewModel>
      getCurrentEvaluation({
    required String regionId,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.currentEvaluation,
        queryParameters: {
          'region_id': regionId,
        },
      );

      final dynamic responseData =
          response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة التقييم غير صحيحة',
        );
      }

      return EvaluationOverviewModel
          .fromJson(
        Map<String, dynamic>.from(
          responseData,
        ),
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
        'حدث خطأ أثناء تحميل التقييم',
      );
    }
  }

  String _handleDioError(
    DioException error,
  ) {
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
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType
            .connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم، تحقق من الإنترنت';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل بيانات التقييم';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
  // =========================================================
// UC-206 - Target Details
// =========================================================

@override
Future<EvaluationTargetDetailsModel>
    getTargetDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  try {
    final response =
        await dio.get(
      ApiEndpoints.evaluationTargetDetails,

      queryParameters: {
        'region_id': regionId,
        'month': month,
        'year': year,
      },
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة تفاصيل التارغت غير صحيحة',
      );
    }

    return EvaluationTargetDetailsModel
        .fromJson(
      Map<String, dynamic>.from(
        responseData,
      ),
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}// =========================================================
// UC-207 - Coverage Details
// =========================================================

@override
Future<EvaluationCoverageDetailsModel>
    getCoverageDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  try {
    final response =
        await dio.get(
      ApiEndpoints.evaluationCoverageDetails,

      queryParameters: {
        'region_id':
            regionId,
        'month':
            month,
        'year':
            year,
      },
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة تفاصيل تغطية الصيدليات غير صحيحة',
      );
    }

    return EvaluationCoverageDetailsModel
        .fromJson(
      Map<String, dynamic>.from(
        responseData,
      ),
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}// =========================================================
// UC-208 - Repeated Pharmacies Details
// =========================================================

@override
Future<EvaluationRepeatedPharmaciesDetailsModel>
    getRepeatedPharmaciesDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  try {
    final response =
        await dio.get(
      ApiEndpoints
          .evaluationRepeatedPharmaciesDetails,

      queryParameters: {
        'region_id': regionId,
        'month': month,
        'year': year,
      },
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة تفاصيل الصيدليات المكررة غير صحيحة',
      );
    }

    return EvaluationRepeatedPharmaciesDetailsModel
        .fromJson(
      Map<String, dynamic>.from(
        responseData,
      ),
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}// =========================================================
// UC-209 - One Time Pharmacies
// =========================================================

@override
Future<EvaluationOneTimePharmaciesDetailsModel>
    getOneTimePharmaciesDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  try {
    final response =
        await dio.get(
      ApiEndpoints
          .evaluationOneTimePharmaciesDetails,

      queryParameters: {
        'region_id':
            regionId,
        'month':
            month,
        'year':
            year,
      },
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة الصيدليات المباعة مرة واحدة غير صحيحة',
      );
    }

    return EvaluationOneTimePharmaciesDetailsModel
        .fromJson(
      Map<String, dynamic>.from(
        responseData,
      ),
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}
}