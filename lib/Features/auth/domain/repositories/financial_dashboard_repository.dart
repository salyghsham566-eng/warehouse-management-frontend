import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';

abstract class FinancialDashboardRepository {
  Future<FinancialDashboardModel> getFinancialDashboard({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  });
}