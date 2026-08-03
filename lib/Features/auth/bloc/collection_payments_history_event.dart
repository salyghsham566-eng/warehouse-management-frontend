import 'package:equatable/equatable.dart';

abstract class CollectionPaymentsHistoryEvent
    extends Equatable {
  const CollectionPaymentsHistoryEvent();

  @override
  List<Object?> get props => const [];
}

class CollectionPaymentsHistoryRequested
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsHistoryRequested();
}

class CollectionPaymentsPharmacyFilterChanged
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsPharmacyFilterChanged(
    this.pharmacyId,
  );

  final String? pharmacyId;

  @override
  List<Object?> get props => [pharmacyId];
}