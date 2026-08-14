import 'package:equatable/equatable.dart';

enum PharmacyAccountStatus {
  hasDebt,
  settled,
  pendingCollection,
}

extension PharmacyAccountStatusExtension
    on PharmacyAccountStatus {
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

  String get apiValue {
    switch (this) {
      case PharmacyAccountStatus.hasDebt:
        return 'has_debt';

      case PharmacyAccountStatus.settled:
        return 'settled';

      case PharmacyAccountStatus.pendingCollection:
        return 'pending_collection';
    }
  }

  static PharmacyAccountStatus fromApi(String value) {
    switch (value.trim().toLowerCase()) {
      case 'has_debt':
        return PharmacyAccountStatus.hasDebt;

      case 'settled':
        return PharmacyAccountStatus.settled;

      case 'pending_collection':
        return PharmacyAccountStatus.pendingCollection;

      default:
        throw FormatException(
          'حالة الصيدلية غير معروفة: $value',
        );
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

  bool get hasDebt {
    return accountStatus == PharmacyAccountStatus.hasDebt;
  }

  bool get isSettled {
    return accountStatus == PharmacyAccountStatus.settled &&
        !hasPendingCollection;
  }

  bool get isPendingCollection {
    return hasPendingCollection ||
        accountStatus ==
            PharmacyAccountStatus.pendingCollection;
  }

  factory CollectionPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CollectionPharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString(),
      officialBalance: _parseDouble(
        json['official_balance'],
      ),
      accountStatus:
          PharmacyAccountStatusExtension.fromApi(
        json['account_status']?.toString() ?? '',
      ),
      hasPendingCollection: _parseBool(
        json['has_pending_collection'],
      ),
      lastPaymentAmount:
          json['last_payment_amount'] == null
              ? null
              : _parseDouble(
                  json['last_payment_amount'],
                ),
      lastPaymentDate: _parseNullableDateTime(
        json['last_payment_date'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'address': address,
      'phone_number': phoneNumber,
      'official_balance': officialBalance,
      'account_status': accountStatus.apiValue,
      'has_pending_collection':
          hasPendingCollection,
      'last_payment_amount': lastPaymentAmount,
      'last_payment_date':
          lastPaymentDate?.toIso8601String(),
    };
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

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value == 1;
    }

    final normalizedValue =
        value?.toString().trim().toLowerCase();

    return normalizedValue == 'true' ||
        normalizedValue == '1';
  }

  static DateTime? _parseNullableDateTime(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return DateTime.tryParse(text);
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