import 'package:project_2/Features/auth/data/datasources/pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_mock_response.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';

class MockPharmacyAccountStatementDataSource
    implements PharmacyAccountStatementDataSource {
  @override
  Future<PharmacyAccountStatementModel>
      getPharmacyAccountStatement({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    final response =
        buildPharmacyAccountStatementMockResponse(
      pharmacyId: pharmacyId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return PharmacyAccountStatementModel.fromJson(
      response,
    );
  }
}