import 'package:equatable/equatable.dart';

abstract class FinancialIndicatorDetailsEvent
    extends Equatable {
  const FinancialIndicatorDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialIndicatorDetailsEvent
    extends FinancialIndicatorDetailsEvent {
  final String indicatorId;
  final DateTime fromDate;
  final DateTime toDate;
  final String regionId;

  const LoadFinancialIndicatorDetailsEvent({
    required this.indicatorId,
    required this.fromDate,
    required this.toDate,
    required this.regionId,
  });

  @override
  List<Object?> get props => [
        indicatorId,
        fromDate,
        toDate,
        regionId,
      ];
}