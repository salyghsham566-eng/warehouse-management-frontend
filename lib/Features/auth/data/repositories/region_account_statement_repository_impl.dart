import 'package:project_2/Features/auth/data/datasources/region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';
import 'package:project_2/Features/auth/domain/repositories/region_account_statement_repository.dart';

class RegionAccountStatementRepositoryImpl
    implements RegionAccountStatementRepository {
  final RegionAccountStatementDataSource dataSource;

  RegionAccountStatementRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<RegionAccountStatementModel>
      getRegionAccountStatement({
    required String regionId,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    return dataSource.getRegionAccountStatement(
      regionId: regionId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}