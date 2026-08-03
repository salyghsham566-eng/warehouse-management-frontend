import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_state.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentFormBloc
    extends Bloc<CollectionPaymentFormEvent, CollectionPaymentFormState> {
  CollectionPaymentFormBloc({
    required CollectionPharmacyModel pharmacy,
    required CollectionPaymentRepository repository,
  }) : _pharmacy = pharmacy,
       _repository = repository,
       super(
         CollectionPaymentFormState(officialBalance: pharmacy.officialBalance),
       ) {
    on<CollectionPaymentAmountChanged>(_onAmountChanged);

    on<CollectionPaymentDateChanged>(_onDateChanged);

    on<CollectionPaymentMethodChanged>(_onMethodChanged);

    on<CollectionPaymentNotesChanged>(_onNotesChanged);

    on<CollectionPaymentReceiptChanged>(_onReceiptChanged);

    on<CollectionPaymentReceiptRemoved>(_onReceiptRemoved);

    on<CollectionPaymentSubmitted>(_onSubmitted);
  }

  final CollectionPharmacyModel _pharmacy;
  final CollectionPaymentRepository _repository;

  void _onAmountChanged(
    CollectionPaymentAmountChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        amountText: event.amount,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onDateChanged(
    CollectionPaymentDateChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        paymentDate: event.date,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onMethodChanged(
    CollectionPaymentMethodChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        paymentMethod: event.method,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onNotesChanged(
    CollectionPaymentNotesChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        notes: event.notes,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onReceiptChanged(
    CollectionPaymentReceiptChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        receiptImagePath: event.imagePath,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onReceiptRemoved(
    CollectionPaymentReceiptRemoved event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        removeReceiptImage: true,
        submitStatus: CollectionPaymentSubmitStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    CollectionPaymentSubmitted event,
    Emitter<CollectionPaymentFormState> emit,
  ) async {
    final double amount = state.enteredAmount;

    if (amount <= 0) {
      emit(
        state.copyWith(
          submitStatus: CollectionPaymentSubmitStatus.failure,
          errorMessage: 'يرجى إدخال مبلغ صحيح أكبر من صفر',
        ),
      );

      return;
    }

    if (amount > state.officialBalance) {
      emit(
        state.copyWith(
          submitStatus: CollectionPaymentSubmitStatus.failure,
          errorMessage: 'المبلغ المدخل أكبر من الرصيد الرسمي',
        ),
      );

      return;
    }

    final DateTime now = DateTime.now();

    final DateTime selectedDay = DateTime(
      state.paymentDate.year,
      state.paymentDate.month,
      state.paymentDate.day,
    );

    final DateTime today = DateTime(now.year, now.month, now.day);

    if (selectedDay.isAfter(today)) {
      emit(
        state.copyWith(
          submitStatus: CollectionPaymentSubmitStatus.failure,
          errorMessage: 'لا يمكن اختيار تاريخ مستقبلي',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        submitStatus: CollectionPaymentSubmitStatus.submitting,
        clearErrorMessage: true,
      ),
    );

    try {
      final CollectionPaymentCreateRequest request =
          CollectionPaymentCreateRequest(
            pharmacyId: _pharmacy.id,
            pharmacyName: _pharmacy.name,
            amount: amount,
            paymentDate: state.paymentDate,
            paymentMethod: state.paymentMethod,
            officialBalanceBefore: state.officialBalance,
            expectedBalanceAfter: state.expectedBalance,
            notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
            receiptImagePath: state.receiptImagePath,
          );

      final CollectionPaymentModel payment = await _repository.createPayment(
        request,
      );

      emit(
        state.copyWith(
          submitStatus: CollectionPaymentSubmitStatus.success,
          savedPayment: payment,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          submitStatus: CollectionPaymentSubmitStatus.failure,
          errorMessage: 'تعذر حفظ الدفعة، حاول مرة أخرى',
        ),
      );
    }
  }
}
