import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/repositories/collection_pharmacies_response.dart';


class RemoteCollectionPharmaciesDataSource
    implements CollectionPharmaciesDataSource {
  const RemoteCollectionPharmaciesDataSource({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<CollectionPharmaciesResponse>
      getCollectionPharmacies() async {
    try {
      final response = await dio.get(
        ApiEndpoints.collectionPharmacies,
      );

      final dynamic responseData = response.data;

      if (responseData is Map) {
        return CollectionPharmaciesResponse.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      }

      if (responseData is List) {
        return CollectionPharmaciesResponse.fromJson({
          'success': true,
          'message':
              'تم تحميل الصيدليات بنجاح',
          'data': {
            'pharmacies': responseData,
          },
        });
      }

      throw Exception(
        'صيغة استجابة الصيدليات غير صحيحة',
      );
    } on DioException catch (error) {
      throw Exception(
        _getDioErrorMessage(error),
      );
    } on FormatException catch (error) {
      throw Exception(error.message);
    } catch (error) {
      throw Exception(
        'حدث خطأ أثناء تحميل الصيدليات',
      );
    }
  }

  String _getDioErrorMessage(
    DioException error,
  ) {
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

      case DioExceptionType.badResponse:
        return 'حدث خطأ من الخادم';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
  @override
Future<CollectionPharmacyModel>
    getCollectionPharmacyDetails(
  String pharmacyId,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints.collectionPharmacyDetails(
        pharmacyId,
      ),
    );

    final dynamic responseData = response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة تفاصيل الصيدلية غير صحيحة',
      );
    }

    final responseMap =
        Map<String, dynamic>.from(responseData);

    final dynamic rawData = responseMap['data'];

    if (rawData is Map) {
      final dataMap =
          Map<String, dynamic>.from(rawData);

      final dynamic rawPharmacy =
          dataMap['pharmacy'];

      if (rawPharmacy is Map) {
        return CollectionPharmacyModel.fromJson(
          Map<String, dynamic>.from(rawPharmacy),
        );
      }

      return CollectionPharmacyModel.fromJson(
        dataMap,
      );
    }

    throw Exception(
      responseMap['message']?.toString() ??
          'لم يتم العثور على بيانات الصيدلية',
    );
  } on DioException catch (error) {
    throw Exception(
      _getDioErrorMessage(error),
    );
  } catch (error) {
    throw Exception(
      error
          .toString()
          .replaceFirst('Exception: ', ''),
    );
  }
}
}