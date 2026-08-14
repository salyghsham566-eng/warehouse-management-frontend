import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

abstract class FinancialPharmaciesState
    extends Equatable {
  const FinancialPharmaciesState();

  @override
  List<Object?> get props => [];
}

class FinancialPharmaciesInitial
    extends FinancialPharmaciesState {
  const FinancialPharmaciesInitial();
}

class FinancialPharmaciesLoading
    extends FinancialPharmaciesState {
  const FinancialPharmaciesLoading();
}

class FinancialPharmaciesSuccess
    extends FinancialPharmaciesState {
  final FinancialPharmaciesResponseModel response;

  const FinancialPharmaciesSuccess({
    required this.response,
  });

  @override
  List<Object?> get props => [response];
}

class FinancialPharmaciesEmpty
    extends FinancialPharmaciesState {
  const FinancialPharmaciesEmpty();
}

class FinancialPharmaciesFailure
    extends FinancialPharmaciesState {
  final String message;

  const FinancialPharmaciesFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}