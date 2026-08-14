import 'package:equatable/equatable.dart';

abstract class RegionAccountStatementEvent
    extends Equatable {
  const RegionAccountStatementEvent();

  @override
  List<Object?> get props => [];
}

class LoadRegionAccountStatementEvent
    extends RegionAccountStatementEvent {
  final String regionId;
  final DateTime fromDate;
  final DateTime toDate;

  const LoadRegionAccountStatementEvent({
    required this.regionId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
        regionId,
        fromDate,
        toDate,
      ];
}