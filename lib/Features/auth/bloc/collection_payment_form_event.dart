import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

abstract class CollectionPaymentFormEvent extends Equatable {
  const CollectionPaymentFormEvent();

  @override
  List<Object?> get props => const [];
}

class CollectionPaymentAmountChanged extends CollectionPaymentFormEvent {
  const CollectionPaymentAmountChanged(this.amount);

  final String amount;

  @override
  List<Object?> get props => [amount];
}

class CollectionPaymentDateChanged extends CollectionPaymentFormEvent {
  const CollectionPaymentDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class CollectionPaymentMethodChanged extends CollectionPaymentFormEvent {
  const CollectionPaymentMethodChanged(this.method);

  final CollectionPaymentMethod method;

  @override
  List<Object?> get props => [method];
}

class CollectionPaymentNotesChanged extends CollectionPaymentFormEvent {
  const CollectionPaymentNotesChanged(this.notes);

  final String notes;

  @override
  List<Object?> get props => [notes];
}

class CollectionPaymentReceiptChanged extends CollectionPaymentFormEvent {
  const CollectionPaymentReceiptChanged(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class CollectionPaymentReceiptRemoved extends CollectionPaymentFormEvent {
  const CollectionPaymentReceiptRemoved();
}

class CollectionPaymentSubmitted extends CollectionPaymentFormEvent {
  const CollectionPaymentSubmitted();
}
