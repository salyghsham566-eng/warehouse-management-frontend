import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacies_filter.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

abstract class CollectionPharmaciesState
    extends Equatable {
  const CollectionPharmaciesState();

  @override
  List<Object?> get props => [];
}

class CollectionPharmaciesInitial
    extends CollectionPharmaciesState {
  const CollectionPharmaciesInitial();
}

class CollectionPharmaciesLoading
    extends CollectionPharmaciesState {
  const CollectionPharmaciesLoading();
}

class CollectionPharmaciesLoaded
    extends CollectionPharmaciesState {
  const CollectionPharmaciesLoaded({
    required this.allPharmacies,
    required this.visiblePharmacies,
    required this.selectedFilter,
    required this.searchText,
  });

  final List<CollectionPharmacyModel>
      allPharmacies;

  final List<CollectionPharmacyModel>
      visiblePharmacies;

  final CollectionPharmacyFilter selectedFilter;

  final String searchText;

  CollectionPharmaciesLoaded copyWith({
    List<CollectionPharmacyModel>? allPharmacies,
    List<CollectionPharmacyModel>?
        visiblePharmacies,
    CollectionPharmacyFilter? selectedFilter,
    String? searchText,
  }) {
    return CollectionPharmaciesLoaded(
      allPharmacies:
          allPharmacies ?? this.allPharmacies,
      visiblePharmacies:
          visiblePharmacies ??
          this.visiblePharmacies,
      selectedFilter:
          selectedFilter ?? this.selectedFilter,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        allPharmacies,
        visiblePharmacies,
        selectedFilter,
        searchText,
      ];
}

class CollectionPharmaciesFailure
    extends CollectionPharmaciesState {
  const CollectionPharmaciesFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}