import 'package:project_2/Features/auth/data/datasources/financial_pharmacy_details_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_model.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacy_details_repository.dart';

class FinancialPharmacyDetailsRepositoryImpl
    implements FinancialPharmacyDetailsRepository {
  final FinancialPharmacyDetailsDataSource dataSource;

  FinancialPharmacyDetailsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<FinancialPharmacyDetailsModel>
      getFinancialPharmacyDetails({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    return dataSource.getFinancialPharmacyDetails(
      pharmacyId: pharmacyId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}