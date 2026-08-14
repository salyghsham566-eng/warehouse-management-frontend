import 'package:project_2/Features/auth/data/datasources/financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacies_mock_response.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

class MockFinancialPharmaciesDataSource
    implements FinancialPharmaciesDataSource {
  @override
  Future<FinancialPharmaciesResponseModel>
      getFinancialPharmacies({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
    required FinancialPharmacySort sort,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    final response =
        buildFinancialPharmaciesMockResponse(
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
      sort: sort,
    );

    return FinancialPharmaciesResponseModel.fromJson(
      response,
    );
  }
}