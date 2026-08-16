import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/representative_pharmacies_event.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacies_state.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/domain/repositories/representative_pharmacies_repository.dart';

class RepresentativePharmaciesBloc extends Bloc<
    RepresentativePharmaciesEvent,
    RepresentativePharmaciesState> {
  final RepresentativePharmaciesRepository
      repository;

  RepresentativePharmaciesBloc({
    required this.repository,
  }) : super(
          const RepresentativePharmaciesState(),
        ) {
    on<RepresentativePharmaciesStarted>(
      _onStarted,
    );

    on<RepresentativePharmaciesSearchChanged>(
      _onSearchChanged,
    );

    on<RepresentativePharmaciesRegionChanged>(
      _onRegionChanged,
    );

    on<RepresentativePharmaciesDateRangeChanged>(
      _onDateRangeChanged,
    );

    on<RepresentativePharmaciesMonthChanged>(
      _onMonthChanged,
    );
  }

  Future<void> _onStarted(
    RepresentativePharmaciesStarted event,
    Emitter<RepresentativePharmaciesState> emit,
  ) async {
    await _load(
      month: event.month,
      emit: emit,
    );
  }

  Future<void> _onMonthChanged(
    RepresentativePharmaciesMonthChanged event,
    Emitter<RepresentativePharmaciesState> emit,
  ) async {
    await _load(
      month: event.month,
      emit: emit,
    );
  }

  Future<void> _load({
    required String month,
    required Emitter<
            RepresentativePharmaciesState>
        emit,
  }) async {
    emit(
      RepresentativePharmaciesState(
        status:
            RepresentativePharmaciesStatus.loading,
        pharmacies: state.pharmacies,
        visiblePharmacies:
            state.visiblePharmacies,
        regionCounts: state.regionCounts,
        selectedRegion:
            state.selectedRegion,
        searchText: state.searchText,
        fromDate: state.fromDate,
        toDate: state.toDate,
        selectedMonth: month,
        totalTarget: state.totalTarget,
        regionTargets:
            state.regionTargets,
      ),
    );

    try {
      final response =
          await repository
              .getRepresentativePharmacies(
        month: month,
      );

      final computed =
          _computeFilters(
        pharmacies:
            response.pharmacies,
        searchText: state.searchText,
        selectedRegion:
            state.selectedRegion,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );

      emit(
        RepresentativePharmaciesState(
          status:
              RepresentativePharmaciesStatus.success,
          pharmacies:
              response.pharmacies,
          visiblePharmacies:
              computed.visible,
          regionCounts:
              computed.regionCounts,
          selectedRegion:
              state.selectedRegion,
          searchText: state.searchText,
          fromDate: state.fromDate,
          toDate: state.toDate,
          selectedMonth:
              response.targetMonth
                      .trim()
                      .isNotEmpty
                  ? response.targetMonth
                  : month,
          totalTarget:
              response.totalTarget,
          regionTargets:
              response.regionTargets,
        ),
      );
    } catch (error) {
      emit(
        RepresentativePharmaciesState(
          status:
              RepresentativePharmaciesStatus.failure,
          pharmacies: state.pharmacies,
          visiblePharmacies:
              state.visiblePharmacies,
          regionCounts:
              state.regionCounts,
          selectedRegion:
              state.selectedRegion,
          searchText: state.searchText,
          fromDate: state.fromDate,
          toDate: state.toDate,
          selectedMonth: month,
          totalTarget: state.totalTarget,
          regionTargets:
              state.regionTargets,
          errorMessage: _cleanError(error),
        ),
      );
    }
  }

  void _onSearchChanged(
    RepresentativePharmaciesSearchChanged event,
    Emitter<RepresentativePharmaciesState> emit,
  ) {
    _emitFiltered(
      emit: emit,
      searchText: event.searchText,
      selectedRegion:
          state.selectedRegion,
      fromDate: state.fromDate,
      toDate: state.toDate,
    );
  }

  void _onRegionChanged(
    RepresentativePharmaciesRegionChanged event,
    Emitter<RepresentativePharmaciesState> emit,
  ) {
    _emitFiltered(
      emit: emit,
      searchText: state.searchText,
      selectedRegion: event.region,
      fromDate: state.fromDate,
      toDate: state.toDate,
    );
  }

  void _onDateRangeChanged(
    RepresentativePharmaciesDateRangeChanged event,
    Emitter<RepresentativePharmaciesState> emit,
  ) {
    _emitFiltered(
      emit: emit,
      searchText: state.searchText,
      selectedRegion:
          state.selectedRegion,
      fromDate: event.fromDate,
      toDate: event.toDate,
    );
  }

  void _emitFiltered({
    required Emitter<
            RepresentativePharmaciesState>
        emit,
    required String searchText,
    required String selectedRegion,
    required DateTime? fromDate,
    required DateTime? toDate,
  }) {
    final computed =
        _computeFilters(
      pharmacies: state.pharmacies,
      searchText: searchText,
      selectedRegion: selectedRegion,
      fromDate: fromDate,
      toDate: toDate,
    );

    emit(
      RepresentativePharmaciesState(
        status:
            RepresentativePharmaciesStatus.success,
        pharmacies: state.pharmacies,
        visiblePharmacies:
            computed.visible,
        regionCounts:
            computed.regionCounts,
        selectedRegion:
            selectedRegion,
        searchText: searchText,
        fromDate: fromDate,
        toDate: toDate,
        selectedMonth:
            state.selectedMonth,
        totalTarget: state.totalTarget,
        regionTargets:
            state.regionTargets,
      ),
    );
  }

  _FilterResult _computeFilters({
    required List<RepresentativePharmacyModel>
        pharmacies,
    required String searchText,
    required String selectedRegion,
    required DateTime? fromDate,
    required DateTime? toDate,
  }) {
    final query =
        searchText.trim().toLowerCase();

    final normalizedFrom =
        fromDate == null
            ? null
            : DateTime(
                fromDate.year,
                fromDate.month,
                fromDate.day,
              );

    final normalizedTo =
        toDate == null
            ? null
            : DateTime(
                toDate.year,
                toDate.month,
                toDate.day,
                23,
                59,
                59,
                999,
              );

    final baseFiltered =
        pharmacies.where((pharmacy) {
      final matchesSearch =
          query.isEmpty ||
          pharmacy.name
              .trim()
              .toLowerCase()
              .contains(query);

      if (!matchesSearch) {
        return false;
      }

      if (normalizedFrom == null &&
          normalizedTo == null) {
        return true;
      }

      final activity =
          pharmacy.lastActivityAt;

      if (activity == null) {
        return false;
      }

      if (normalizedFrom != null &&
          activity.isBefore(
            normalizedFrom,
          )) {
        return false;
      }

      if (normalizedTo != null &&
          activity.isAfter(
            normalizedTo,
          )) {
        return false;
      }

      return true;
    }).toList();

    final regionCounts =
        <String, int>{};

    final allRegions = pharmacies
        .map(
          (pharmacy) =>
              pharmacy.region.trim(),
        )
        .where(
          (region) => region.isNotEmpty,
        )
        .toSet()
        .toList()
      ..sort();

    for (final region in allRegions) {
      regionCounts[region] = 0;
    }

    for (final pharmacy
        in baseFiltered) {
      final region =
          pharmacy.region.trim();

      if (region.isEmpty) {
        continue;
      }

      regionCounts[region] =
          (regionCounts[region] ?? 0) + 1;
    }

    final visible =
        selectedRegion == 'الكل'
            ? baseFiltered
            : baseFiltered
                .where(
                  (pharmacy) =>
                      pharmacy.region ==
                      selectedRegion,
                )
                .toList();

    return _FilterResult(
      visible: visible,
      regionCounts: regionCounts,
    );
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}

class _FilterResult {
  final List<RepresentativePharmacyModel>
      visible;

  final Map<String, int>
      regionCounts;

  const _FilterResult({
    required this.visible,
    required this.regionCounts,
  });
}
