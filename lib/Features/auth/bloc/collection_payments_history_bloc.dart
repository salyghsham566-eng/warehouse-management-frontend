import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_state.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentsHistoryBloc extends Bloc<
    CollectionPaymentsHistoryEvent,
    CollectionPaymentsHistoryState> {
  CollectionPaymentsHistoryBloc({
    required CollectionPaymentRepository repository,
    String? initialPharmacyId,
  })  : _repository = repository,
        super(
          CollectionPaymentsHistoryState(
            selectedPharmacyId: initialPharmacyId,
          ),
        ) {
    on<CollectionPaymentsHistoryRequested>(
      _onRequested,
    );

    on<CollectionPaymentsPharmacyFilterChanged>(
      _onPharmacyFilterChanged,
    );
  }

  final CollectionPaymentRepository _repository;

  Future<void> _onRequested(
    CollectionPaymentsHistoryRequested event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CollectionPaymentsHistoryStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final List<CollectionPaymentModel> payments =
          await _repository.getPayments();

      final List<CollectionPaymentModel>
          visiblePayments = _filterPayments(
        payments: payments,
        pharmacyId: state.selectedPharmacyId,
      );

      emit(
        state.copyWith(
          status: CollectionPaymentsHistoryStatus.success,
          allPayments: payments,
          visiblePayments: visiblePayments,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CollectionPaymentsHistoryStatus.failure,
          errorMessage:
              'تعذر تحميل سجل التحصيلات',
        ),
      );
    }
  }

  void _onPharmacyFilterChanged(
    CollectionPaymentsPharmacyFilterChanged event,
    Emitter<CollectionPaymentsHistoryState> emit,
  ) {
    final List<CollectionPaymentModel> filtered =
        _filterPayments(
      payments: state.allPayments,
      pharmacyId: event.pharmacyId,
    );

    emit(
      state.copyWith(
        visiblePayments: filtered,
        selectedPharmacyId: event.pharmacyId,
        clearPharmacyFilter:
            event.pharmacyId == null,
      ),
    );
  }

  List<CollectionPaymentModel> _filterPayments({
    required List<CollectionPaymentModel> payments,
    required String? pharmacyId,
  }) {
    if (pharmacyId == null) {
      return payments;
    }

    return payments
        .where(
          (payment) =>
              payment.pharmacyId == pharmacyId,
        )
        .toList(growable: false);
  }
}