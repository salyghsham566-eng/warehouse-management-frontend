import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/pharmacy_model.dart';
import '../data/repositories/pharmacies_repository.dart';
import 'pharmacies_event.dart';
import 'pharmacies_state.dart';

class PharmaciesBloc extends Bloc<PharmaciesEvent, PharmaciesState> {
  final PharmaciesRepository repository;

  PharmaciesBloc(this.repository) : super(const PharmaciesState()) {
    on<PharmaciesStarted>(_onStarted);
    on<PharmaciesSearchChanged>(_onSearchChanged);
    on<PharmaciesAreaChanged>(_onAreaChanged);
  }

  Future<void> _onStarted(
    PharmaciesStarted event,
    Emitter<PharmaciesState> emit,
  ) async {
    emit(state.copyWith(status: PharmaciesStatus.loading));

    try {
      final pharmacies = await repository.getPharmacies();

      emit(
        state.copyWith(
          status: PharmaciesStatus.success,
          pharmacies: pharmacies,
          visiblePharmacies: _applyFilters(
            pharmacies: pharmacies,
            searchText: state.searchText,
            selectedArea: state.selectedArea,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PharmaciesStatus.failure,
          errorMessage: "حدث خطأ أثناء تحميل الصيدليات",
        ),
      );
    }
  }

  void _onSearchChanged(
    PharmaciesSearchChanged event,
    Emitter<PharmaciesState> emit,
  ) {
    emit(
      state.copyWith(
        searchText: event.searchText,
        visiblePharmacies: _applyFilters(
          pharmacies: state.pharmacies,
          searchText: event.searchText,
          selectedArea: state.selectedArea,
        ),
      ),
    );
  }

  void _onAreaChanged(
    PharmaciesAreaChanged event,
    Emitter<PharmaciesState> emit,
  ) {
    emit(
      state.copyWith(
        selectedArea: event.area,
        visiblePharmacies: _applyFilters(
          pharmacies: state.pharmacies,
          searchText: state.searchText,
          selectedArea: event.area,
        ),
      ),
    );
  }

  List<PharmacyModel> _applyFilters({
    required List<PharmacyModel> pharmacies,
    required String searchText,
    required String selectedArea,
  }) {
    final text = searchText.trim().toLowerCase();

    return pharmacies.where((pharmacy) {
      final name = pharmacy.name.toLowerCase();
      final branch = pharmacy.branch.toLowerCase();
      final address = pharmacy.address.toLowerCase();
      final area = pharmacy.area.toLowerCase();

      final matchesSearch =
          name.contains(text) || branch.contains(text) || address.contains(text);

      final matchesArea = selectedArea == "الكل"
          ? true
          : area == selectedArea.toLowerCase();

      return matchesSearch && matchesArea;
    }).toList();
  }
}