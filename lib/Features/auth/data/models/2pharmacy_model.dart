import 'package:equatable/equatable.dart';

enum PharmacyAccountStatus { hasDebt, settled, pendingCollection }

extension PharmacyAccountStatusExtension on PharmacyAccountStatus {
  String get label {
    switch (this) {
      case PharmacyAccountStatus.hasDebt:
        return 'عليها ذمة';

      case PharmacyAccountStatus.settled:
        return 'مسددة';

      case PharmacyAccountStatus.pendingCollection:
        return 'دفعة معلقة';
    }
  }

  static PharmacyAccountStatus fromApi(String value) {
    switch (value) {
      case 'has_debt':
        return PharmacyAccountStatus.hasDebt;

      case 'settled':
        return PharmacyAccountStatus.settled;

      case 'pending_collection':
        return PharmacyAccountStatus.pendingCollection;

      default:
        throw FormatException('حالة الصيدلية غير معروفة: $value');
    }
  }
}

class CollectionPharmacyModel extends Equatable {
  const CollectionPharmacyModel({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.officialBalance,
    required this.accountStatus,
    required this.hasPendingCollection,
    this.phoneNumber,
    this.lastPaymentAmount,
    this.lastPaymentDate,
  });

  final String id;
  final String name;
  final String area;
  final String address;
  final String? phoneNumber;

  final double officialBalance;

  final PharmacyAccountStatus accountStatus;
  final bool hasPendingCollection;

  final double? lastPaymentAmount;
  final DateTime? lastPaymentDate;

  factory CollectionPharmacyModel.fromJson(Map<String, dynamic> json) {
    return CollectionPharmacyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String?,
      officialBalance: (json['official_balance'] as num).toDouble(),
      accountStatus: PharmacyAccountStatusExtension.fromApi(
        json['account_status'] as String,
      ),
      hasPendingCollection: json['has_pending_collection'] as bool,
      lastPaymentAmount: (json['last_payment_amount'] as num?)?.toDouble(),
      lastPaymentDate: json['last_payment_date'] == null
          ? null
          : DateTime.parse(json['last_payment_date'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    area,
    address,
    phoneNumber,
    officialBalance,
    accountStatus,
    hasPendingCollection,
    lastPaymentAmount,
    lastPaymentDate,
  ];
}
