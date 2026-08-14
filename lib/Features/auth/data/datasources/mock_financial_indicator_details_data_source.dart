import 'package:project_2/Features/auth/data/datasources/financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_mock_response.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';

class MockFinancialIndicatorDetailsDataSource
    implements FinancialIndicatorDetailsDataSource {
  @override
  Future<FinancialIndicatorDetailsResponseModel>
      getIndicatorDetails({
    required String indicatorId,
    required DateTime fromDate,
    required DateTime toDate,
    required String regionId,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    final response =
        buildFinancialIndicatorDetailsMockResponse(
      indicatorId: indicatorId,
      fromDate: fromDate,
      toDate: toDate,
      regionId: regionId,
    );

    return FinancialIndicatorDetailsResponseModel.fromJson(
      response,
    );
  }
}