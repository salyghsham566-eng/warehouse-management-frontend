import 'package:equatable/equatable.dart';

enum CollectionPaymentMethod { cash, bankTransfer, cheque }

extension CollectionPaymentMethodExtension on CollectionPaymentMethod {
  String get label {
    switch (this) {
      case CollectionPaymentMethod.cash:
        return 'نقدي';

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

  static CollectionPaymentMethod fromApi(String value) {
    switch (value) {
      case 'cash':
        return CollectionPaymentMethod.cash;

      case 'bank_transfer':
        return CollectionPaymentMethod.bankTransfer;

      case 'cheque':
        return CollectionPaymentMethod.cheque;

      default:
        throw FormatException('طريقة دفع غير معروفة: $value');
    }
  }
}

enum CollectionApprovalStatus { pendingBillingApproval, approved, rejected }

extension CollectionApprovalStatusExtension on CollectionApprovalStatus {
  String get label {
    switch (this) {
      case CollectionApprovalStatus.pendingBillingApproval:
        return 'بانتظار اعتماد المفوتر';

      case CollectionApprovalStatus.approved:
        return 'معتمدة';

      case CollectionApprovalStatus.rejected:
        return 'مرفوضة';
    }
  }

  String get apiValue {
    switch (this) {
      case CollectionApprovalStatus.pendingBillingApproval:
        return 'pending_billing_approval';

      case CollectionApprovalStatus.approved:
        return 'approved';

      case CollectionApprovalStatus.rejected:
        return 'rejected';
    }
  }

  static CollectionApprovalStatus fromApi(String value) {
    switch (value) {
      case 'pending_billing_approval':
        return CollectionApprovalStatus.pendingBillingApproval;

      case 'approved':
        return CollectionApprovalStatus.approved;

      case 'rejected':
        return CollectionApprovalStatus.rejected;

      default:
        throw FormatException('حالة دفعة غير معروفة: $value');
    }
  }
}

class CollectionPaymentCreateRequest extends Equatable {
  const CollectionPaymentCreateRequest({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.officialBalanceBefore,
    required this.expectedBalanceAfter,
    this.notes,
    this.receiptImagePath,
  });

  final String pharmacyId;
  final String pharmacyName;

  final double amount;
  final DateTime paymentDate;

  final CollectionPaymentMethod paymentMethod;

  final double officialBalanceBefore;
  final double expectedBalanceAfter;

  final String? notes;
  final String? receiptImagePath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pharmacy_id': pharmacyId,
      'pharmacy_name': pharmacyName,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod.apiValue,
      'official_balance_before': officialBalanceBefore,
      'expected_balance_after': expectedBalanceAfter,
      'notes': notes,
      'receipt_image_path': receiptImagePath,
    };
  }

  @override
  List<Object?> get props => [
    pharmacyId,
    pharmacyName,
    amount,
    paymentDate,
    paymentMethod,
    officialBalanceBefore,
    expectedBalanceAfter,
    notes,
    receiptImagePath,
  ];
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
    required this.createdAt,
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

  final double officialBalanceBefore;
  final double expectedBalanceAfter;

  final DateTime createdAt;

  final String? notes;
  final String? receiptImagePath;
  final String? rejectionReason;

  factory CollectionPaymentModel.fromJson(Map<String, dynamic> json) {
    return CollectionPaymentModel(
      id: json['id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      pharmacyName: json['pharmacy_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      paymentMethod: CollectionPaymentMethodExtension.fromApi(
        json['payment_method'] as String,
      ),
      status: CollectionApprovalStatusExtension.fromApi(
        json['status'] as String,
      ),
      officialBalanceBefore: (json['official_balance_before'] as num)
          .toDouble(),
      expectedBalanceAfter: (json['expected_balance_after'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      notes: json['notes'] as String?,
      receiptImagePath: json['receipt_image_path'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );
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
    createdAt,
    notes,
    receiptImagePath,
    rejectionReason,
  ];
}
