import 'package:project_2/Features/auth/data/datasources/region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_mock_response.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';

class MockRegionAccountStatementDataSource
    implements RegionAccountStatementDataSource {
  @override
  Future<RegionAccountStatementModel>
      getRegionAccountStatement({
    required String regionId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    final response =
        buildRegionAccountStatementMockResponse(
      regionId: regionId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return RegionAccountStatementModel.fromJson(
      response,
    );
  }
}