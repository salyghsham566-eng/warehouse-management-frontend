import 'package:project_2/Features/auth/data/datasources/financial_dashboard_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_mock_response.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';

class FinancialDashboardMockDataSource
    implements FinancialDashboardDataSource {
  @override
  Future<FinancialDashboardModel> getFinancialDashboard({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    final response = buildFinancialDashboardMockResponse(
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
    );

    return FinancialDashboardModel.fromJson(response);
  }
}