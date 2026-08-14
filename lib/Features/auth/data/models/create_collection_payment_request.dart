import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

class CreateCollectionPaymentRequest
    extends Equatable {
  const CreateCollectionPaymentRequest({
  required this.pharmacyId,
  required this.pharmacyName,
  required this.officialBalanceBefore,
  required this.amount,
  required this.paymentDate,
  required this.paymentMethod,
  this.notes,
  this.receiptImagePath,
});

  final String pharmacyId;
  final String pharmacyName;
  final double amount;
  final DateTime paymentDate;
  final CollectionPaymentMethod paymentMethod;
  final String? notes;
  final String? receiptImagePath;
  final double officialBalanceBefore;

  Map<String, dynamic> toFields() {
  return {
    'pharmacy_id': pharmacyId,
    'amount': amount,
    'payment_date':
        paymentDate.toIso8601String(),
    'payment_method':
        paymentMethod.apiValue,
    if (notes?.trim().isNotEmpty == true)
      'notes': notes!.trim(),
  };
}
  @override
  List<Object?> get props => [
        pharmacyId,
        pharmacyName,
        amount,
        paymentDate,
        paymentMethod,
        notes,
        receiptImagePath,
      ];
}