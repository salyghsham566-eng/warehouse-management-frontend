import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

abstract class FinancialPharmaciesEvent
    extends Equatable {
  const FinancialPharmaciesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialPharmaciesEvent
    extends FinancialPharmaciesEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String regionId;
  final FinancialPharmacySort sort;

  const LoadFinancialPharmaciesEvent({
    required this.fromDate,
    required this.toDate,
    required this.regionId,
    required this.sort,
  });

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        regionId,
        sort,
      ];
}