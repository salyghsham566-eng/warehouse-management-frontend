import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

class RemoteRepresentativePharmaciesDataSource
    implements RepresentativePharmaciesDataSource {
  final Dio dio;

  const RemoteRepresentativePharmaciesDataSource({
    required this.dio,
  });

  @override
  Future<RepresentativePharmaciesResponseModel>
      getRepresentativePharmacies({
    required String month,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.representativePharmacies,
        queryParameters: {
          'month': month,
        },
      );

      final dynamic responseData =
          response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة الصيدليات غير صحيحة',
        );
      }

      final root =
          Map<String, dynamic>.from(
        responseData,
      );

      final dynamic rawData =
          root['data'];

      final payload =
          rawData is Map
              ? Map<String, dynamic>.from(
                  rawData,
                )
              : root;

      final rawPharmacies =
          _extractPharmacies(payload);

      final pharmacies = rawPharmacies
          .whereType<Map>()
          .map(
            (item) =>
                RepresentativePharmacyModel
                    .fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .where(
            (pharmacy) =>
                pharmacy.name
                    .trim()
                    .isNotEmpty,
          )
          .toList();

      final targetPayload =
          _extractTargetPayload(
        payload,
      );

      return RepresentativePharmaciesResponseModel(
        pharmacies: pharmacies,
        targetMonth:
            _readString(
                  targetPayload,
                  const [
                    'month',
                    'target_month',
                    'targetMonth',
                  ],
                )
                .trim()
                .isNotEmpty
            ? _readString(
                targetPayload,
                const [
                  'month',
                  'target_month',
                  'targetMonth',
                ],
              )
            : month,
        totalTarget:
            _readNullableDouble(
          targetPayload,
          const [
            'total_target',
            'totalTarget',
            'total',
            'target',
          ],
        ),
        regionTargets:
            _readRegionTargets(
          targetPayload,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }
@override
Future<RepresentativePharmacyDetailsModel>
    getRepresentativePharmacyDetails(
  String pharmacyId,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints
          .representativePharmacyDetails(
        pharmacyId,
      ),
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة بيانات الصيدلية غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic rawData =
        root['data'];

    Map<String, dynamic> payload =
        rawData is Map
            ? Map<String, dynamic>.from(
                rawData,
              )
            : root;

    // دعم Response مثل:
    // data: {
    //   pharmacy: {...},
    //   financial_summary: {...},
    //   recent_interactions: {...}
    // }
    final dynamic nestedPharmacy =
        payload['pharmacy'];

    if (nestedPharmacy is Map) {
      payload = {
        ...payload,
        ...Map<String, dynamic>.from(
          nestedPharmacy,
        ),
      };
    }

    return RepresentativePharmacyDetailsModel
        .fromJson(
      payload,
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}
  List<dynamic> _extractPharmacies(
    Map<String, dynamic> payload,
  ) {
    for (final key in const [
      'pharmacies',
      'items',
      'results',
    ]) {
      final value = payload[key];

      if (value is List) {
        return value;
      }
    }

    return const [];
  }

  Map<String, dynamic> _extractTargetPayload(
    Map<String, dynamic> payload,
  ) {
    final dynamic target =
        payload['target'] ??
        payload['targets'] ??
        payload['target_summary'] ??
        payload['targetSummary'];

    if (target is Map) {
      return Map<String, dynamic>.from(
        target,
      );
    }

    return payload;
  }

  Map<String, double> _readRegionTargets(
    Map<String, dynamic> json,
  ) {
    final dynamic value =
        json['region_targets'] ??
        json['regionTargets'] ??
        json['regions'];

    final result = <String, double>{};

    if (value is Map) {
      value.forEach((key, rawValue) {
        final parsed =
            _parseDouble(rawValue);

        if (parsed != null) {
          result[key.toString()] =
              parsed;
        }
      });

      return result;
    }

    if (value is List) {
      for (final item in value) {
        if (item is! Map) {
          continue;
        }

        final map =
            Map<String, dynamic>.from(
          item,
        );

        final region =
            _readString(
          map,
          const [
            'region',
            'region_name',
            'regionName',
            'name',
          ],
        );

        final target =
            _readNullableDouble(
          map,
          const [
            'target',
            'value',
            'amount',
          ],
        );

        if (region.isNotEmpty &&
            target != null) {
          result[region] = target;
        }
      }
    }

    return result;
  }

  String _readString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  double? _readNullableDouble(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final parsed =
          _parseDouble(json[key]);

      if (parsed != null) {
        return parsed;
      }
    }

    return null;
  }

  double? _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(
        value.trim(),
      );
    }

    return null;
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
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل الصيدليات';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}
