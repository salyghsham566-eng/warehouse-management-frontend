import 'package:equatable/equatable.dart';

abstract class FinancialPharmacyDetailsEvent
    extends Equatable {
  const FinancialPharmacyDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialPharmacyDetailsEvent
    extends FinancialPharmacyDetailsEvent {
  final String pharmacyId;
  final DateTime fromDate;
  final DateTime toDate;

  const LoadFinancialPharmacyDetailsEvent({
    required this.pharmacyId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
        pharmacyId,
        fromDate,
        toDate,
      ];
}