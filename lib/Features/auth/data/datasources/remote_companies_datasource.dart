import 'package:dio/dio.dart';
import 'package:project_2/Features/auth/data/datasources/companies_datasource.dart';
import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/core/network/api_endpoints.dart';

class RemoteCompaniesDataSource implements CompaniesDataSource {
  final Dio dio;

  const RemoteCompaniesDataSource({
    required this.dio,
  });

  @override
  Future<List<CompanyModel>> getCompanies() async {
    final response = await dio.get(
      ApiEndpoints.companies,
    );

    final List<dynamic> companiesJson = _extractCompaniesList(
      response.data,
    );

    return companiesJson.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'بيانات إحدى الشركات غير صحيحة',
        );
      }

      return CompanyModel.fromJson(item);
    }).toList();
  }

  List<dynamic> _extractCompaniesList(dynamic responseData) {
    // يدعم Response عبارة عن List مباشرة:
    // [ {...}, {...} ]
    if (responseData is List<dynamic>) {
      return responseData;
    }

    // يدعم Response مغلف داخل data:
    // { "success": true, "data": [ {...}, {...} ] }
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];

      if (data is List<dynamic>) {
        return data;
      }

      // يدعم:
      // { "data": { "companies": [ ... ] } }
      if (data is Map<String, dynamic>) {
        final dynamic companies = data['companies'];

        if (companies is List<dynamic>) {
          return companies;
        }
      }

      // يدعم:
      // { "companies": [ ... ] }
      final dynamic companies = responseData['companies'];

      if (companies is List<dynamic>) {
        return companies;
      }
    }

    throw const FormatException(
      'صيغة استجابة الشركات غير صحيحة',
    );
  }
}