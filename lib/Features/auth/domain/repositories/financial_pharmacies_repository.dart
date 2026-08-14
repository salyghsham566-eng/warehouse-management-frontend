import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

abstract class FinancialPharmaciesRepository {
  Future<FinancialPharmaciesResponseModel>
      getFinancialPharmacies({
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
    required FinancialPharmacySort sort,
  });
}