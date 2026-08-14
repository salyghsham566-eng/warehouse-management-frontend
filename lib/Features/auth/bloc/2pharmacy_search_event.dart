import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacies_filter.dart';

abstract class CollectionPharmaciesEvent
    extends Equatable {
  const CollectionPharmaciesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollectionPharmaciesEvent
    extends CollectionPharmaciesEvent {
  const LoadCollectionPharmaciesEvent();
}

class RefreshCollectionPharmaciesEvent
    extends CollectionPharmaciesEvent {
  const RefreshCollectionPharmaciesEvent();
}

class SearchCollectionPharmaciesEvent
    extends CollectionPharmaciesEvent {
  const SearchCollectionPharmaciesEvent({
    required this.searchText,
  });

  final String searchText;

  @override
  List<Object?> get props => [searchText];
}

class ChangeCollectionPharmacyFilterEvent
    extends CollectionPharmaciesEvent {
  const ChangeCollectionPharmacyFilterEvent({
    required this.filter,
  });

  final CollectionPharmacyFilter filter;

  @override
  List<Object?> get props => [filter];
}

class ClearCollectionPharmacySearchEvent
    extends CollectionPharmaciesEvent {
  const ClearCollectionPharmacySearchEvent();
}