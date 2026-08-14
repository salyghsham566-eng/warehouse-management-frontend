import 'package:equatable/equatable.dart';

abstract class PharmacyAccountStatementEvent
    extends Equatable {
  const PharmacyAccountStatementEvent();

  @override
  List<Object?> get props => [];
}

class LoadPharmacyAccountStatementEvent
    extends PharmacyAccountStatementEvent {
  final String pharmacyId;
  final DateTime fromDate;
  final DateTime toDate;

  const LoadPharmacyAccountStatementEvent({
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