import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_event.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_state.dart';
import 'package:project_2/Features/auth/data/models/Collection_modle.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_repository.dart';

class CollectionDashboardBloc
    extends Bloc<CollectionDashboardEvent, CollectionDashboardState> {
  CollectionDashboardBloc(this._repository)
    : super(const CollectionDashboardState()) {
    on<CollectionDashboardRequested>(_onDashboardRequested);

    on<CollectionSearchChanged>(_onSearchChanged);

    on<CollectionStatusFilterChanged>(_onStatusFilterChanged);
  }

  final CollectionRepository _repository;

  Future<void> _onDashboardRequested(
    CollectionDashboardRequested event,
    Emitter<CollectionDashboardState> emit,
  ) async {
    emit(state.copyWith(loadStatus: CollectionLoadStatus.loading));

    try {
      final dashboard = await _repository.getDashboard();

      final filteredItems = _filterCollections(
        collections: dashboard.recentCollections,
        searchQuery: state.searchQuery,
        statusFilter: state.statusFilter,
      );

      emit(
        state.copyWith(
          loadStatus: CollectionLoadStatus.success,
          dashboard: dashboard,
          visibleCollections: filteredItems,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loadStatus: CollectionLoadStatus.failure,
          errorMessage: 'تعذر تحميل بيانات التحصيل، حاول مرة أخرى.',
        ),
      );
    }
  }

  void _onSearchChanged(
    CollectionSearchChanged event,
    Emitter<CollectionDashboardState> emit,
  ) {
    final allCollections =
        state.dashboard?.recentCollections ?? const <CollectionItemModel>[];

    final filteredItems = _filterCollections(
      collections: allCollections,
      searchQuery: event.query,
      statusFilter: state.statusFilter,
    );

    emit(
      state.copyWith(
        searchQuery: event.query,
        visibleCollections: filteredItems,
      ),
    );
  }

  void _onStatusFilterChanged(
    CollectionStatusFilterChanged event,
    Emitter<CollectionDashboardState> emit,
  ) {
    final allCollections =
        state.dashboard?.recentCollections ?? const <CollectionItemModel>[];

    final filteredItems = _filterCollections(
      collections: allCollections,
      searchQuery: state.searchQuery,
      statusFilter: event.filter,
    );

    emit(
      state.copyWith(
        statusFilter: event.filter,
        visibleCollections: filteredItems,
      ),
    );
  }

  List<CollectionItemModel> _filterCollections({
    required List<CollectionItemModel> collections,
    required String searchQuery,
    required CollectionStatusFilter statusFilter,
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    final selectedPaymentStatus = statusFilter.paymentStatus;

    return collections
        .where((collection) {
          final matchesSearch =
              normalizedQuery.isEmpty ||
              collection.pharmacyName.toLowerCase().contains(normalizedQuery) ||
              collection.areaName.toLowerCase().contains(normalizedQuery);

          final matchesStatus =
              selectedPaymentStatus == null ||
              collection.status == selectedPaymentStatus;

          return matchesSearch && matchesStatus;
        })
        .toList(growable: false);
  }
}
