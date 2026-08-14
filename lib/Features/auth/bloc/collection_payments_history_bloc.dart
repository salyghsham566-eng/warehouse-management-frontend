import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_filter.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_state.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentsHistoryBloc extends Bloc<
    CollectionPaymentsHistoryEvent,
    CollectionPaymentsHistoryState> {
  CollectionPaymentsHistoryBloc({
    required this.repository,
     this.pharmacyId,
  }) : super(
          const CollectionPaymentsHistoryState(),
        ) {
    on<CollectionPaymentsHistoryRequested>(
      _onRequested,
    );

    on<CollectionPaymentsHistoryRefreshed>(
      _onRefreshed,
    );

    on<CollectionPaymentsHistorySearchChanged>(
      _onSearchChanged,
    );

    on<CollectionPaymentsHistoryFilterChanged>(
      _onFilterChanged,
    );
  }

  final CollectionPaymentRepository repository;
 final String? pharmacyId;
  Future<void> _onRequested(
    CollectionPaymentsHistoryRequested event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status:
            CollectionPaymentsHistoryStatus.loading,
        errorMessage: null,
      ),
    );

    await _loadPayments(emit);
  }

  Future<void> _onRefreshed(
    CollectionPaymentsHistoryRefreshed event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) async {
    await _loadPayments(emit);
  }

  Future<void> _loadPayments(
    Emitter<CollectionPaymentsHistoryState> emit,
  ) async {
    try {
      final payments =
          await repository.getCollectionPayments();

      final visiblePayments = _applyFilters(
        payments: payments,
        filter: state.selectedFilter,
        searchText: state.searchText,
      );

      emit(
        state.copyWith(
          status:
              CollectionPaymentsHistoryStatus
                  .success,
          allPayments: payments,
          visiblePayments: visiblePayments,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status:
              CollectionPaymentsHistoryStatus
                  .failure,
          errorMessage: _cleanError(error),
        ),
      );
    }
  }

  void _onSearchChanged(
    CollectionPaymentsHistorySearchChanged event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) {
    final searchText = event.searchText.trim();

    emit(
      state.copyWith(
        searchText: searchText,
        visiblePayments: _applyFilters(
          payments: state.allPayments,
          filter: state.selectedFilter,
          searchText: searchText,
        ),
      ),
    );
  }

  void _onFilterChanged(
    CollectionPaymentsHistoryFilterChanged event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) {
    emit(
      state.copyWith(
        selectedFilter: event.filter,
        visiblePayments: _applyFilters(
          payments: state.allPayments,
          filter: event.filter,
          searchText: state.searchText,
        ),
      ),
    );
  }

  List<CollectionPaymentModel> _applyFilters({
    required List<CollectionPaymentModel>
        payments,
    required CollectionPaymentsHistoryFilter
        filter,
    required String searchText,
  }) {
    Iterable<CollectionPaymentModel> result =
        payments;
final String selectedPharmacyId =
    pharmacyId?.trim() ?? '';

if (selectedPharmacyId.isNotEmpty) {
  result = result.where(
    (payment) =>
        payment.pharmacyId.trim() ==
        selectedPharmacyId,
  );
}
    final normalizedSearch =
        searchText.trim().toLowerCase();

    if (normalizedSearch.isNotEmpty) {
      result = result.where((payment) {
        final searchableText = [
          payment.id,
          payment.pharmacyId,
          payment.pharmacyName,
          payment.amount.toString(),
          payment.paymentMethod.label,
          payment.status.label,
        ].join(' ').toLowerCase();

        return searchableText.contains(
          normalizedSearch,
        );
      });
    }

    switch (filter) {
      case CollectionPaymentsHistoryFilter.pending:
        result = result.where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus
                  .pendingBillingApproval,
        );
        break;

      case CollectionPaymentsHistoryFilter.approved:
        result = result.where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus.approved,
        );
        break;

      case CollectionPaymentsHistoryFilter.rejected:
        result = result.where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus.rejected,
        );
        break;

      case CollectionPaymentsHistoryFilter.all:
        break;
    }

    final List<CollectionPaymentModel> list =
        result.toList();

    list.sort(
      (first, second) => second.paymentDate
          .compareTo(first.paymentDate),
    );

    return list;
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }
}