import 'package:project_2/Features/auth/data/datasources/pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacy_account_statement_repository.dart';

class PharmacyAccountStatementRepositoryImpl
    implements PharmacyAccountStatementRepository {
  final PharmacyAccountStatementDataSource dataSource;

  PharmacyAccountStatementRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<PharmacyAccountStatementModel>
      getPharmacyAccountStatement({
    required String pharmacyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    return dataSource.getPharmacyAccountStatement(
      pharmacyId: pharmacyId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}