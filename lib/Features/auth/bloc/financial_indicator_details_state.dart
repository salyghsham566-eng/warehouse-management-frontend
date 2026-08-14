import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';

abstract class FinancialIndicatorDetailsState
    extends Equatable {
  const FinancialIndicatorDetailsState();

  @override
  List<Object?> get props => [];
}

class FinancialIndicatorDetailsInitial
    extends FinancialIndicatorDetailsState {
  const FinancialIndicatorDetailsInitial();
}

class FinancialIndicatorDetailsLoading
    extends FinancialIndicatorDetailsState {
  const FinancialIndicatorDetailsLoading();
}

class FinancialIndicatorDetailsSuccess
    extends FinancialIndicatorDetailsState {
  final FinancialIndicatorDetailsResponseModel response;

  const FinancialIndicatorDetailsSuccess({
    required this.response,
  });

  @override
  List<Object?> get props => [response];
}

class FinancialIndicatorDetailsFailure
    extends FinancialIndicatorDetailsState {
  final String message;

  const FinancialIndicatorDetailsFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}