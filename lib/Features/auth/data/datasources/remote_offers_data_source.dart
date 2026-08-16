import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';

import 'package:project_2/Features/auth/data/datasources/offers_data_source.dart';
import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';

import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';
import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';
import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

class RemoteOffersDataSource
    implements OffersDataSource {
  final Dio dio;

  const RemoteOffersDataSource({
    required this.dio,
  });

  // =========================================================
  // UC-213
  // =========================================================

  @override
  Future<OffersOverviewModel>
      getRepresentativeOffers() async {
    try {
      final response =
          await dio.get(
        ApiEndpoints.representativeOffers,
      );

      final dynamic responseData =
          response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة العروض غير صحيحة',
        );
      }

      return OffersOverviewModel.fromJson(
        Map<String, dynamic>.from(
          responseData,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(
          error,
        ),
      );
    }
  }

  // =========================================================
  // UC-214 -> UC-218
  // =========================================================

  @override
  Future<PromotionalBasketDetailsModel>
      getPromotionalBasketDetails({
    required String basketId,
  }) async {
    try {
      final response =
          await dio.get(
        ApiEndpoints
            .promotionalBasketDetails(
          basketId,
        ),
      );

      final dynamic responseData =
          response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة تفاصيل السلة غير صحيحة',
        );
      }

      return PromotionalBasketDetailsModel
          .fromJson(
        Map<String, dynamic>.from(
          responseData,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(
          error,
        ),
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
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل بيانات العرض';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
  // =========================================================
// UC-220 -> UC-221
// =========================================================

@override
Future<List<UsedOfferHistoryModel>>
    getUsedOffersHistory() async {
  try {
    final response =
        await dio.get(
      ApiEndpoints.usedOffersHistory,
    );

    final dynamic responseData =
        response.data;

    dynamic rawHistory;

    if (responseData is List) {
      rawHistory =
          responseData;
    } else if (responseData is Map) {
      final dynamic data =
          responseData['data'];

      if (data is List) {
        rawHistory =
            data;
      } else if (data is Map) {
        rawHistory =
            data['history'] ??
                data[
                    'used_offers'] ??
                data['items'];
      } else {
        rawHistory =
            responseData['history'] ??
                responseData[
                    'used_offers'] ??
                responseData['items'];
      }
    }

    if (rawHistory is! List) {
      throw Exception(
        'صيغة استجابة تاريخ العروض غير صحيحة',
      );
    }

    return rawHistory
        .whereType<Map>()
        .map(
          (item) =>
              UsedOfferHistoryModel
                  .fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .toList();
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(
        error,
      ),
    );
  }
}
@override
Future<ActiveOfferDetailsModel>
    getActiveOfferDetails({
  required String offerId,
}) async {
  try {
    final response =
        await dio.get(
      ApiEndpoints.activeOfferDetails(
        offerId,
      ),
    );

    final dynamic data =
        response.data;

    if (data is! Map) {
      throw Exception(
        'صيغة تفاصيل العرض غير صحيحة',
      );
    }

    return ActiveOfferDetailsModel
        .fromJson(
      Map<String, dynamic>.from(
        data,
      ),
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}
}