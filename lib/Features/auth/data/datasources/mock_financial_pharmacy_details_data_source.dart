import 'package:project_2/Features/auth/data/datasources/financial_pharmacy_details_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_mock_response.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_model.dart';

class MockFinancialPharmacyDetailsDataSource
    implements FinancialPharmacyDetailsDataSource {
  @override
  Future<FinancialPharmacyDetailsModel>
      getFinancialPharmacyDetails({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    final response =
        buildFinancialPharmacyDetailsMockResponse(
      pharmacyId: pharmacyId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return FinancialPharmacyDetailsModel.fromJson(
      response,
    );
  }
}