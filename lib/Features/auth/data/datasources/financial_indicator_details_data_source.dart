import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';

abstract class FinancialIndicatorDetailsDataSource {
  Future<FinancialIndicatorDetailsResponseModel>
      getIndicatorDetails({
    required String indicatorId,
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  });
}