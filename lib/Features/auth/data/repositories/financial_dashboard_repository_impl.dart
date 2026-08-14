import 'package:project_2/Features/auth/data/datasources/financial_dashboard_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_dashboard_repository.dart';

class FinancialDashboardRepositoryImpl
    implements FinancialDashboardRepository {
  final FinancialDashboardDataSource dataSource;

  FinancialDashboardRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<FinancialDashboardModel> getFinancialDashboard({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) {
    return dataSource.getFinancialDashboard(
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
    );
  }
}