import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_state.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentFormBloc extends Bloc<
    CollectionPaymentFormEvent,
    CollectionPaymentFormState> {
  CollectionPaymentFormBloc({
    required this.repository,
    required this.pharmacy,
  }) : super(
          CollectionPaymentFormState(
            officialBalance:
                pharmacy.officialBalance,
            enteredAmount: 0,
            paymentDate: DateTime.now(),
            paymentMethod:
                CollectionPaymentMethod.cash,
            notes: '',
            submitStatus:
                CollectionPaymentSubmitStatus
                    .initial,
          ),
        ) {
    on<CollectionPaymentAmountChanged>(
      _onAmountChanged,
    );

    on<CollectionPaymentDateChanged>(
      _onDateChanged,
    );

    on<CollectionPaymentMethodChanged>(
      _onMethodChanged,
    );

    on<CollectionPaymentNotesChanged>(
      _onNotesChanged,
    );

    on<CollectionPaymentReceiptChanged>(
      _onReceiptChanged,
    );

    on<CollectionPaymentReceiptRemoved>(
      _onReceiptRemoved,
    );

    on<CollectionPaymentSubmitted>(
      _onSubmitted,
    );
  }

  final CollectionPaymentRepository repository;
  final CollectionPharmacyModel pharmacy;

  void _onAmountChanged(
    CollectionPaymentAmountChanged event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        enteredAmount:
            _parseAmount(event.value),
        submitStatus:
            CollectionPaymentSubmitStatus.initial,
        savedPayment: null,
        errorMessage: null,
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
        submitStatus:
            CollectionPaymentSubmitStatus.initial,
        errorMessage: null,
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
        submitStatus:
            CollectionPaymentSubmitStatus.initial,
        errorMessage: null,
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
      ),
    );
  }

  void _onReceiptRemoved(
    CollectionPaymentReceiptRemoved event,
    Emitter<CollectionPaymentFormState> emit,
  ) {
    emit(
      state.copyWith(
        receiptImagePath: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    CollectionPaymentSubmitted event,
    Emitter<CollectionPaymentFormState> emit,
  ) async {
    if (state.enteredAmount <= 0) {
      emit(
        state.copyWith(
          submitStatus:
              CollectionPaymentSubmitStatus
                  .failure,
          errorMessage:
              'أدخل مبلغاً صحيحاً',
        ),
      );

      return;
    }

    if (state.enteredAmount >
        state.officialBalance) {
      emit(
        state.copyWith(
          submitStatus:
              CollectionPaymentSubmitStatus
                  .failure,
          errorMessage:
              'المبلغ أكبر من الرصيد الرسمي',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        submitStatus:
            CollectionPaymentSubmitStatus
                .submitting,
        savedPayment: null,
        errorMessage: null,
      ),
    );

    try {
      final payment =
          await repository.createCollectionPayment(
       CreateCollectionPaymentRequest(
  pharmacyId: pharmacy.id,
  pharmacyName: pharmacy.name,
  officialBalanceBefore:
      pharmacy.officialBalance,
  amount: state.enteredAmount,
  paymentDate: state.paymentDate,
  paymentMethod: state.paymentMethod,
  notes: state.notes,
  receiptImagePath:
      state.receiptImagePath,
),
      );

     final savedPayment = CollectionPaymentModel(
  id: payment.id,
  pharmacyId: payment.pharmacyId,
  pharmacyName:
      payment.pharmacyName.trim().isEmpty
          ? pharmacy.name
          : payment.pharmacyName,
  amount: payment.amount,
  paymentDate: payment.paymentDate,
  paymentMethod: payment.paymentMethod,
  status: payment.status,

  officialBalanceBefore:
      payment.officialBalanceBefore,

  expectedBalanceAfter:
      payment.expectedBalanceAfter,

  officialBalanceAfter:
      payment.officialBalanceAfter,

  approvedAt: payment.approvedAt,
  rejectedAt: payment.rejectedAt,

  notes: payment.notes,
  receiptImagePath:
      payment.receiptImagePath,
  rejectionReason:
      payment.rejectionReason,
);
      emit(
        state.copyWith(
          submitStatus:
              CollectionPaymentSubmitStatus
                  .success,
          savedPayment: savedPayment,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submitStatus:
              CollectionPaymentSubmitStatus
                  .failure,
          savedPayment: null,
          errorMessage: error
              .toString()
              .replaceFirst('Exception: ', '')
              .trim(),
        ),
      );
    }
  }

  double _parseAmount(String value) {
    String normalized = value.trim();

    const arabicNumbers = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    arabicNumbers.forEach((arabic, english) {
      normalized =
          normalized.replaceAll(
        arabic,
        english,
      );
    });

    normalized = normalized
        .replaceAll('٫', '.')
        .replaceAll(',', '.');

    return double.tryParse(normalized) ?? 0;
  }
}