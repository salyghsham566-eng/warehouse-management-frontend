import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';

abstract class PharmacyAccountStatementDataSource {
  Future<PharmacyAccountStatementModel>
      getPharmacyAccountStatement({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  });
}