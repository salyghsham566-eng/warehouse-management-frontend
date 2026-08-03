import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_event.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_state.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/2pharmacy_repository.dart';

class PharmacySearchBloc
    extends Bloc<PharmacySearchEvent, PharmacySearchState> {
  PharmacySearchBloc(this._repository) : super(const PharmacySearchState()) {
    on<PharmacySearchRequested>(_onSearchRequested);

    on<PharmacySearchQueryChanged>(_onQueryChanged);
  }

  final CollectionPharmacyRepository _repository;

  Future<void> _onSearchRequested(
    PharmacySearchRequested event,
    Emitter<PharmacySearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PharmacySearchStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final List<CollectionPharmacyModel> pharmacies = await _repository
          .getPharmacies();

      final List<CollectionPharmacyModel> visiblePharmacies = _filterPharmacies(
        pharmacies: pharmacies,
        query: state.query,
      );

      emit(
        state.copyWith(
          status: PharmacySearchStatus.success,
          allPharmacies: pharmacies,
          visiblePharmacies: visiblePharmacies,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PharmacySearchStatus.failure,
          errorMessage: 'تعذر تحميل قائمة الصيدليات',
        ),
      );
    }
  }

  void _onQueryChanged(
    PharmacySearchQueryChanged event,
    Emitter<PharmacySearchState> emit,
  ) {
    final List<CollectionPharmacyModel> filteredPharmacies = _filterPharmacies(
      pharmacies: state.allPharmacies,
      query: event.query,
    );

    emit(
      state.copyWith(query: event.query, visiblePharmacies: filteredPharmacies),
    );
  }

  List<CollectionPharmacyModel> _filterPharmacies({
    required List<CollectionPharmacyModel> pharmacies,
    required String query,
  }) {
    final String normalizedQuery = _normalizeText(query);

    if (normalizedQuery.isEmpty) {
      return pharmacies;
    }

    return pharmacies
        .where((CollectionPharmacyModel pharmacy) {
          final String name = _normalizeText(pharmacy.name);

          final String area = _normalizeText(pharmacy.area);

          final String address = _normalizeText(pharmacy.address);

          return name.contains(normalizedQuery) ||
              area.contains(normalizedQuery) ||
              address.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  String _normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('ـ', '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
