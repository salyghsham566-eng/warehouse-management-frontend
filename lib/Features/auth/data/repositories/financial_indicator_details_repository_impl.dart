import 'package:project_2/Features/auth/data/datasources/financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_indicator_details_repository.dart';

class FinancialIndicatorDetailsRepositoryImpl
    implements FinancialIndicatorDetailsRepository {
  final FinancialIndicatorDetailsDataSource dataSource;

  FinancialIndicatorDetailsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<FinancialIndicatorDetailsResponseModel>
      getIndicatorDetails({
    required String indicatorId,
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) {
    return dataSource.getIndicatorDetails(
      indicatorId: indicatorId,
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
    );
  }
}