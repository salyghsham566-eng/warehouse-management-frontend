import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_model.dart';

abstract class FinancialPharmacyDetailsState
    extends Equatable {
  const FinancialPharmacyDetailsState();

  @override
  List<Object?> get props => [];
}

class FinancialPharmacyDetailsInitial
    extends FinancialPharmacyDetailsState {
  const FinancialPharmacyDetailsInitial();
}

class FinancialPharmacyDetailsLoading
    extends FinancialPharmacyDetailsState {
  const FinancialPharmacyDetailsLoading();
}

class FinancialPharmacyDetailsSuccess
    extends FinancialPharmacyDetailsState {
  final FinancialPharmacyDetailsModel details;

  const FinancialPharmacyDetailsSuccess({
    required this.details,
  });

  @override
  List<Object?> get props => [details];
}

class FinancialPharmacyDetailsFailure
    extends FinancialPharmacyDetailsState {
  final String message;

  const FinancialPharmacyDetailsFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}