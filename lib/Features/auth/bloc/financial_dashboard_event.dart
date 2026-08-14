import 'package:equatable/equatable.dart';

abstract class FinancialDashboardEvent extends Equatable {
  const FinancialDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialDashboardEvent extends FinancialDashboardEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String regionId;

  const LoadFinancialDashboardEvent({
    required this.fromDate,
    required this.toDate,
    required this.regionId,
  });

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        regionId,
      ];
}