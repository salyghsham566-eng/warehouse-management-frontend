import 'package:equatable/equatable.dart';

enum CollectionPaymentMethod {
  cash,
  bankTransfer,
  cheque,
}

extension CollectionPaymentMethodExtension
    on CollectionPaymentMethod {
  String get label {
    switch (this) {
      case CollectionPaymentMethod.cash:
        return 'نقداً';

      case CollectionPaymentMethod.bankTransfer:
        return 'تحويل بنكي';

      case CollectionPaymentMethod.cheque:
        return 'شيك';
    }
  }

  String get apiValue {
    switch (this) {
      case CollectionPaymentMethod.cash:
        return 'cash';

      case CollectionPaymentMethod.bankTransfer:
        return 'bank_transfer';

      case CollectionPaymentMethod.cheque:
        return 'cheque';
    }
  }

  static CollectionPaymentMethod fromApi(
    String value,
  ) {
    switch (value.trim().toLowerCase()) {
      case 'cash':
        return CollectionPaymentMethod.cash;

      case 'bank_transfer':
        return CollectionPaymentMethod.bankTransfer;

      case 'cheque':
      case 'check':
        return CollectionPaymentMethod.cheque;

      default:
        return CollectionPaymentMethod.cash;
    }
  }
}

enum CollectionApprovalStatus {
  pendingBillingApproval,
  approved,
  rejected,
}

extension CollectionApprovalStatusExtension
    on CollectionApprovalStatus {
  String get label {
    switch (this) {
      case CollectionApprovalStatus
            .pendingBillingApproval:
        return 'بانتظار اعتماد المفوتر';

      case CollectionApprovalStatus.approved:
        return 'معتمدة';

      case CollectionApprovalStatus.rejected:
        return 'مرفوضة';
    }
  }

  String get apiValue {
    switch (this) {
      case CollectionApprovalStatus
            .pendingBillingApproval:
        return 'pending_billing_approval';

      case CollectionApprovalStatus.approved:
        return 'approved';

      case CollectionApprovalStatus.rejected:
        return 'rejected';
    }
  }

  static CollectionApprovalStatus fromApi(
    String value,
  ) {
    switch (value.trim().toLowerCase()) {
      case 'approved':
        return CollectionApprovalStatus.approved;

      case 'rejected':
        return CollectionApprovalStatus.rejected;

      case 'pending_billing_approval':
      case 'pending':
      default:
        return CollectionApprovalStatus
            .pendingBillingApproval;
    }
  }
}

class CollectionPaymentModel extends Equatable {
 const CollectionPaymentModel({
  required this.id,
  required this.pharmacyId,
  required this.pharmacyName,
  required this.amount,
  required this.paymentDate,
  required this.paymentMethod,
  required this.status,
  required this.officialBalanceBefore,
  required this.expectedBalanceAfter,
  this.officialBalanceAfter,
  this.approvedAt,
  this.rejectedAt,
  this.notes,
  this.receiptImagePath,
  this.rejectionReason,
});

  final String id;
  final String pharmacyId;
  final String pharmacyName;
  final double amount;
  final DateTime paymentDate;
  final CollectionPaymentMethod paymentMethod;
  final CollectionApprovalStatus status;

  final String? notes;
  final String? receiptImagePath;
  final String? rejectionReason;
  final double officialBalanceBefore;
final double expectedBalanceAfter;
final double? officialBalanceAfter;

final DateTime? approvedAt;
final DateTime? rejectedAt;

  factory CollectionPaymentModel.fromJson(
  Map<String, dynamic> json,
) {
  final double amount =
      _parseDouble(json['amount']);

  final double officialBalanceBefore =
      _parseDouble(
    json['official_balance_before'],
  );

  final double expectedBalanceAfter =
      json['expected_balance_after'] == null
          ? officialBalanceBefore - amount
          : _parseDouble(
              json['expected_balance_after'],
            );

  return CollectionPaymentModel(
    id: json['id']?.toString() ?? '',
    pharmacyId:
        json['pharmacy_id']?.toString() ?? '',
    pharmacyName:
        json['pharmacy_name']?.toString() ?? '',
    amount: amount,
    paymentDate: DateTime.tryParse(
          json['payment_date']?.toString() ?? '',
        ) ??
        DateTime.now(),
    paymentMethod:
        CollectionPaymentMethodExtension.fromApi(
      json['payment_method']?.toString() ??
          'cash',
    ),
    status:
        CollectionApprovalStatusExtension.fromApi(
      json['status']?.toString() ??
          'pending_billing_approval',
    ),
    officialBalanceBefore:
        officialBalanceBefore,
    expectedBalanceAfter:
        expectedBalanceAfter,
    officialBalanceAfter:
        _parseNullableDouble(
      json['official_balance_after'],
    ),
    approvedAt: _parseNullableDateTime(
      json['approved_at'],
    ),
    rejectedAt: _parseNullableDateTime(
      json['rejected_at'],
    ),
    notes: json['notes']?.toString(),
    receiptImagePath:
        json['receipt_image_url']?.toString() ??
            json['receipt_image_path']?.toString(),
    rejectionReason:
        json['rejection_reason']?.toString(),
  );
}

 static double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

static double? _parseNullableDouble(
  dynamic value,
) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

static DateTime? _parseNullableDateTime(
  dynamic value,
) {
  if (value == null ||
      value.toString().trim().isEmpty) {
    return null;
  }

  return DateTime.tryParse(value.toString());
}

  @override
List<Object?> get props => [
  id,
  pharmacyId,
  pharmacyName,
  amount,
  paymentDate,
  paymentMethod,
  status,
  officialBalanceBefore,
  expectedBalanceAfter,
  officialBalanceAfter,
  approvedAt,
  rejectedAt,
  notes,
  receiptImagePath,
  rejectionReason,
];
}