import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_model.dart';

abstract class FinancialPharmacyDetailsDataSource {
  Future<FinancialPharmacyDetailsModel>
      getFinancialPharmacyDetails({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  });
}