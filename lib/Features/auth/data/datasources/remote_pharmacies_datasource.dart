import 'package:dio/dio.dart';
import 'package:project_2/Features/auth/data/datasources/pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_model.dart';
import 'package:project_2/core/network/api_endpoints.dart';

class RemotePharmaciesDataSource implements PharmaciesDataSource {
  final Dio dio;

  const RemotePharmaciesDataSource({
    required this.dio,
  });

  @override
  Future<List<PharmacyModel>> getPharmacies() async {
    final response = await dio.get(
      ApiEndpoints.pharmacies,
    );

    final pharmaciesJson = _extractPharmaciesList(
      response.data,
    );

    return pharmaciesJson.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'بيانات إحدى الصيدليات غير صحيحة',
        );
      }

      return PharmacyModel.fromJson(item);
    }).toList();
  }

  List<dynamic> _extractPharmaciesList(dynamic responseData) {
    // Response مباشر:
    // [ {...}, {...} ]
    if (responseData is List<dynamic>) {
      return responseData;
    }

    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];

      // {
      //   "success": true,
      //   "data": [ ... ]
      // }
      if (data is List<dynamic>) {
        return data;
      }

      // {
      //   "data": {
      //     "pharmacies": [ ... ]
      //   }
      // }
      if (data is Map<String, dynamic>) {
        final dynamic pharmacies = data['pharmacies'];

        if (pharmacies is List<dynamic>) {
          return pharmacies;
        }
      }

      // {
      //   "pharmacies": [ ... ]
      // }
      final dynamic pharmacies = responseData['pharmacies'];

      if (pharmacies is List<dynamic>) {
        return pharmacies;
      }
    }

    throw const FormatException(
      'صيغة استجابة الصيدليات غير صحيحة',
    );
  }
}