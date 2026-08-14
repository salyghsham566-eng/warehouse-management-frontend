import 'package:equatable/equatable.dart';

abstract class CollectionPharmacyDetailsEvent extends Equatable {
  const CollectionPharmacyDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollectionPharmacyDetailsEvent
    extends CollectionPharmacyDetailsEvent {
  const LoadCollectionPharmacyDetailsEvent({
    required this.pharmacyId,
  });

  final String pharmacyId;

  @override
  List<Object?> get props => [pharmacyId];
}