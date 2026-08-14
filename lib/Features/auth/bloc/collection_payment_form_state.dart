import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

enum CollectionPaymentSubmitStatus {
  initial,
  submitting,
  success,
  failure,
}

const Object _unset = Object();

class CollectionPaymentFormState
    extends Equatable {
  const CollectionPaymentFormState({
    required this.officialBalance,
    required this.enteredAmount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.notes,
    required this.submitStatus,
    this.receiptImagePath,
    this.savedPayment,
    this.errorMessage,
  });

  final double officialBalance;
  final double enteredAmount;
  final DateTime paymentDate;
  final CollectionPaymentMethod paymentMethod;
  final String notes;
  final String? receiptImagePath;

  final CollectionPaymentSubmitStatus
      submitStatus;

  final CollectionPaymentModel? savedPayment;
  final String? errorMessage;

  double get expectedBalance {
    return officialBalance - enteredAmount;
  }

  bool get isSubmitting {
    return submitStatus ==
        CollectionPaymentSubmitStatus.submitting;
  }

  CollectionPaymentFormState copyWith({
    double? officialBalance,
    double? enteredAmount,
    DateTime? paymentDate,
    CollectionPaymentMethod? paymentMethod,
    String? notes,
    Object? receiptImagePath = _unset,
    CollectionPaymentSubmitStatus? submitStatus,
    Object? savedPayment = _unset,
    Object? errorMessage = _unset,
  }) {
    return CollectionPaymentFormState(
      officialBalance:
          officialBalance ?? this.officialBalance,
      enteredAmount:
          enteredAmount ?? this.enteredAmount,
      paymentDate:
          paymentDate ?? this.paymentDate,
      paymentMethod:
          paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      receiptImagePath:
          identical(receiptImagePath, _unset)
              ? this.receiptImagePath
              : receiptImagePath as String?,
      submitStatus:
          submitStatus ?? this.submitStatus,
      savedPayment:
          identical(savedPayment, _unset)
              ? this.savedPayment
              : savedPayment
                  as CollectionPaymentModel?,
      errorMessage:
          identical(errorMessage, _unset)
              ? this.errorMessage
              : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        officialBalance,
        enteredAmount,
        paymentDate,
        paymentMethod,
        notes,
        receiptImagePath,
        submitStatus,
        savedPayment,
        errorMessage,
      ];
}