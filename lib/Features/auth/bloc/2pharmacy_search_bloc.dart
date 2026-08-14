import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_event.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_state.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacies_filter.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_phermacy_repository.dart';


class CollectionPharmaciesBloc extends Bloc<
    CollectionPharmaciesEvent,
    CollectionPharmaciesState> {
  CollectionPharmaciesBloc({
    required this.repository,
  }) : super(
          const CollectionPharmaciesInitial(),
        ) {
    on<LoadCollectionPharmaciesEvent>(
      _onLoadCollectionPharmacies,
    );

    on<RefreshCollectionPharmaciesEvent>(
      _onRefreshCollectionPharmacies,
    );

    on<SearchCollectionPharmaciesEvent>(
      _onSearchCollectionPharmacies,
    );

    on<ChangeCollectionPharmacyFilterEvent>(
      _onChangeFilter,
    );

    on<ClearCollectionPharmacySearchEvent>(
      _onClearSearch,
    );
  }

  final CollectionRepository repository;

  Future<void> _onLoadCollectionPharmacies(
    LoadCollectionPharmaciesEvent event,
    Emitter<CollectionPharmaciesState> emit,
  ) async {
    emit(const CollectionPharmaciesLoading());

    try {
      final pharmacies =
    await repository.getCollectionPharmacies();

final visiblePharmacies = _applyFilters(
  pharmacies: pharmacies,
  filter: CollectionPharmacyFilter.hasDebt,
  searchText: '',
);

emit(
  CollectionPharmaciesLoaded(
    allPharmacies: pharmacies,
    visiblePharmacies: visiblePharmacies,
    selectedFilter:
        CollectionPharmacyFilter.hasDebt,
    searchText: '',
  ),
);
    } catch (error) {
      emit(
        CollectionPharmaciesFailure(
          message: _cleanErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _onRefreshCollectionPharmacies(
    RefreshCollectionPharmaciesEvent event,
    Emitter<CollectionPharmaciesState> emit,
  ) async {
    final currentState = state;

    CollectionPharmacyFilter currentFilter =
        CollectionPharmacyFilter.hasDebt;

    String currentSearchText = '';

    if (currentState
        is CollectionPharmaciesLoaded) {
      currentFilter =
          currentState.selectedFilter;
      currentSearchText =
          currentState.searchText;
    }

    try {
      final pharmacies =
          await repository.getCollectionPharmacies();

      final visiblePharmacies = _applyFilters(
        pharmacies: pharmacies,
        filter: currentFilter,
        searchText: currentSearchText,
      );

      emit(
        CollectionPharmaciesLoaded(
          allPharmacies: pharmacies,
          visiblePharmacies:
              visiblePharmacies,
          selectedFilter: currentFilter,
          searchText: currentSearchText,
        ),
      );
    } catch (error) {
      emit(
        CollectionPharmaciesFailure(
          message: _cleanErrorMessage(error),
        ),
      );
    }
  }

  void _onSearchCollectionPharmacies(
    SearchCollectionPharmaciesEvent event,
    Emitter<CollectionPharmaciesState> emit,
  ) {
    final currentState = state;

    if (currentState
        is! CollectionPharmaciesLoaded) {
      return;
    }

    final searchText = event.searchText.trim();

    final visiblePharmacies = _applyFilters(
      pharmacies: currentState.allPharmacies,
      filter: currentState.selectedFilter,
      searchText: searchText,
    );

    emit(
      currentState.copyWith(
        searchText: searchText,
        visiblePharmacies:
            visiblePharmacies,
      ),
    );
  }

  void _onChangeFilter(
    ChangeCollectionPharmacyFilterEvent event,
    Emitter<CollectionPharmaciesState> emit,
  ) {
    final currentState = state;

    if (currentState
        is! CollectionPharmaciesLoaded) {
      return;
    }

    final visiblePharmacies = _applyFilters(
      pharmacies: currentState.allPharmacies,
      filter: event.filter,
      searchText: currentState.searchText,
    );

    emit(
      currentState.copyWith(
        selectedFilter: event.filter,
        visiblePharmacies:
            visiblePharmacies,
      ),
    );
  }

  void _onClearSearch(
    ClearCollectionPharmacySearchEvent event,
    Emitter<CollectionPharmaciesState> emit,
  ) {
    final currentState = state;

    if (currentState
        is! CollectionPharmaciesLoaded) {
      return;
    }

    final visiblePharmacies = _applyFilters(
      pharmacies: currentState.allPharmacies,
      filter: currentState.selectedFilter,
      searchText: '',
    );

    emit(
      currentState.copyWith(
        searchText: '',
        visiblePharmacies:
            visiblePharmacies,
      ),
    );
  }

  List<CollectionPharmacyModel> _applyFilters({
    required List<CollectionPharmacyModel>
        pharmacies,
    required CollectionPharmacyFilter filter,
    required String searchText,
  }) {
    final normalizedSearchText =
        searchText.trim().toLowerCase();

    Iterable<CollectionPharmacyModel> result =
        pharmacies;

    if (normalizedSearchText.isNotEmpty) {
      result = result.where((pharmacy) {
        final searchableText = [
          pharmacy.name,
          pharmacy.area,
          pharmacy.address,
          pharmacy.phoneNumber ?? '',
        ].join(' ').toLowerCase();

        return searchableText.contains(
          normalizedSearchText,
        );
      });
    }

    switch (filter) {
      case CollectionPharmacyFilter.hasDebt:
        result = result.where(
          (pharmacy) =>
              pharmacy.accountStatus ==
              PharmacyAccountStatus.hasDebt,
        );
        break;

      case CollectionPharmacyFilter.settled:
        result = result.where(
          (pharmacy) => pharmacy.isSettled,
        );
        break;

      case CollectionPharmacyFilter
            .pendingCollection:
        result = result.where(
          (pharmacy) =>
              pharmacy.isPendingCollection,
        );
        break;

      case CollectionPharmacyFilter.all:
        break;
    }

    return result.toList();
  }

  String _cleanErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }
}