import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';

abstract class RegionAccountStatementRepository {
  Future<RegionAccountStatementModel>
      getRegionAccountStatement({
    required String regionId,
    required DateTime fromDate,
    required DateTime toDate,
  });
}