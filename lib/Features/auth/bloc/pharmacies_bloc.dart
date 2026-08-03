import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/pharmacy_model.dart';
import '../domain/repositories/pharmacies_repository.dart';
import 'pharmacies_event.dart';
import 'pharmacies_state.dart';

class PharmaciesBloc
    extends Bloc<PharmaciesEvent, PharmaciesState> {
  final PharmaciesRepository repository;

  PharmaciesBloc({
    required this.repository,
  }) : super(const PharmaciesState()) {
    on<PharmaciesStarted>(_onStarted);
    on<PharmaciesSearchChanged>(_onSearchChanged);
    on<PharmaciesAreaChanged>(_onAreaChanged);
  }

  Future<void> _onStarted(
    PharmaciesStarted event,
    Emitter<PharmaciesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PharmaciesStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      final pharmacies = await repository.getPharmacies();

      final visiblePharmacies = _applyFilters(
        pharmacies: pharmacies,
        searchText: state.searchText,
        selectedArea: state.selectedArea,
      );

      emit(
        state.copyWith(
          status: PharmaciesStatus.success,
          pharmacies: pharmacies,
          visiblePharmacies: visiblePharmacies,
          errorMessage: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PharmaciesStatus.failure,
          errorMessage: 'حدث خطأ أثناء تحميل الصيدليات',
        ),
      );
    }
  }

  void _onSearchChanged(
    PharmaciesSearchChanged event,
    Emitter<PharmaciesState> emit,
  ) {
    final visiblePharmacies = _applyFilters(
      pharmacies: state.pharmacies,
      searchText: event.searchText,
      selectedArea: state.selectedArea,
    );

    emit(
      state.copyWith(
        searchText: event.searchText,
        visiblePharmacies: visiblePharmacies,
      ),
    );
  }

  void _onAreaChanged(
    PharmaciesAreaChanged event,
    Emitter<PharmaciesState> emit,
  ) {
    final visiblePharmacies = _applyFilters(
      pharmacies: state.pharmacies,
      searchText: state.searchText,
      selectedArea: event.area,
    );

    emit(
      state.copyWith(
        selectedArea: event.area,
        visiblePharmacies: visiblePharmacies,
      ),
    );
  }

  List<PharmacyModel> _applyFilters({
    required List<PharmacyModel> pharmacies,
    required String searchText,
    required String selectedArea,
  }) {
    final normalizedSearchText =
        searchText.trim().toLowerCase();

    final normalizedSelectedArea =
        selectedArea.trim().toLowerCase();

    return pharmacies.where((pharmacy) {
      final name = pharmacy.name.trim().toLowerCase();
      final branch = pharmacy.branch.trim().toLowerCase();
      final address = pharmacy.address.trim().toLowerCase();
      final area = pharmacy.area.trim().toLowerCase();

      final matchesSearch =
          normalizedSearchText.isEmpty ||
          name.contains(normalizedSearchText) ||
          branch.contains(normalizedSearchText) ||
          address.contains(normalizedSearchText) ||
          area.contains(normalizedSearchText);

      final matchesArea =
          selectedArea == 'الكل' ||
          area == normalizedSelectedArea;

      return matchesSearch && matchesArea;
    }).toList();
  }
}