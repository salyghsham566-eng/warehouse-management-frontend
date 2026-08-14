import 'package:project_2/Features/auth/data/datasources/financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacies_repository.dart';

class FinancialPharmaciesRepositoryImpl
    implements FinancialPharmaciesRepository {
  final FinancialPharmaciesDataSource dataSource;

  FinancialPharmaciesRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<FinancialPharmaciesResponseModel>
      getFinancialPharmacies({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
    required FinancialPharmacySort sort,
  }) {
    return dataSource.getFinancialPharmacies(
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
      sort: sort,
    );
  }
}