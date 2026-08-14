import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

abstract class CollectionPharmacyDetailsState extends Equatable {
  const CollectionPharmacyDetailsState();

  @override
  List<Object?> get props => [];
}

class CollectionPharmacyDetailsInitial
    extends CollectionPharmacyDetailsState {
  const CollectionPharmacyDetailsInitial();
}

class CollectionPharmacyDetailsLoading
    extends CollectionPharmacyDetailsState {
  const CollectionPharmacyDetailsLoading();
}

class CollectionPharmacyDetailsLoaded
    extends CollectionPharmacyDetailsState {
  const CollectionPharmacyDetailsLoaded({
    required this.pharmacy,
  });

  final CollectionPharmacyModel pharmacy;

  @override
  List<Object?> get props => [pharmacy];
}

class CollectionPharmacyDetailsFailure
    extends CollectionPharmacyDetailsState {
  const CollectionPharmacyDetailsFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}