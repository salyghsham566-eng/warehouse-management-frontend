import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

enum CollectionPaymentSubmitStatus { initial, submitting, success, failure }

class CollectionPaymentFormState extends Equatable {
  CollectionPaymentFormState({
    required this.officialBalance,
    DateTime? paymentDate,
    this.amountText = '',
    this.paymentMethod = CollectionPaymentMethod.cash,
    this.notes = '',
    this.receiptImagePath,
    this.submitStatus = CollectionPaymentSubmitStatus.initial,
    this.errorMessage,
    this.savedPayment,
  }) : paymentDate = paymentDate ?? DateTime.now();

  final double officialBalance;

  final String amountText;
  final DateTime paymentDate;

  final CollectionPaymentMethod paymentMethod;

  final String notes;
  final String? receiptImagePath;

  final CollectionPaymentSubmitStatus submitStatus;

  final String? errorMessage;
  final CollectionPaymentModel? savedPayment;

  double get enteredAmount {
    final String normalized = _normalizeAmount(amountText);

    return double.tryParse(normalized) ?? 0;
  }

  double get expectedBalance {
    return officialBalance - enteredAmount;
  }

  bool get isSubmitting {
    return submitStatus == CollectionPaymentSubmitStatus.submitting;
  }

  CollectionPaymentFormState copyWith({
    double? officialBalance,
    String? amountText,
    DateTime? paymentDate,
    CollectionPaymentMethod? paymentMethod,
    String? notes,
    String? receiptImagePath,
    bool removeReceiptImage = false,
    CollectionPaymentSubmitStatus? submitStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
    CollectionPaymentModel? savedPayment,
  }) {
    return CollectionPaymentFormState(
      officialBalance: officialBalance ?? this.officialBalance,
      amountText: amountText ?? this.amountText,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      receiptImagePath: removeReceiptImage
          ? null
          : receiptImagePath ?? this.receiptImagePath,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      savedPayment: savedPayment ?? this.savedPayment,
    );
  }

  @override
  List<Object?> get props => [
    officialBalance,
    amountText,
    paymentDate,
    paymentMethod,
    notes,
    receiptImagePath,
    submitStatus,
    errorMessage,
    savedPayment,
  ];
}

String _normalizeAmount(String value) {
  return value
      .trim()
      .replaceAll(',', '')
      .replaceAll('٫', '.')
      .replaceAll('٠', '0')
      .replaceAll('١', '1')
      .replaceAll('٢', '2')
      .replaceAll('٣', '3')
      .replaceAll('٤', '4')
      .replaceAll('٥', '5')
      .replaceAll('٦', '6')
      .replaceAll('٧', '7')
      .replaceAll('٨', '8')
      .replaceAll('٩', '9');
}
