class RegionAccountStatementModel {
  final String regionId;
  final String regionName;
  final DateTime fromDate;
  final DateTime toDate;

  final List<RegionStatementPharmacyModel> pharmacies;
  final RegionStatementSummaryModel summary;

  const RegionAccountStatementModel({
    required this.regionId,
    required this.regionName,
    required this.fromDate,
    required this.toDate,
    required this.pharmacies,
    required this.summary,
  });

  factory RegionAccountStatementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _toMap(json['data']) ?? json;
    final scope =
        _toMap(data['scope']) ?? <String, dynamic>{};
    final period =
        _toMap(data['period']) ?? <String, dynamic>{};
    final summaryJson =
        _toMap(data['summary']) ?? <String, dynamic>{};

    final pharmaciesJson = data['pharmacies'];

    return RegionAccountStatementModel(
      regionId: scope['id']?.toString() ?? 'all',
      regionName:
          scope['name']?.toString() ?? 'جميع المناطق',
      fromDate: _parseDate(period['from']),
      toDate: _parseDate(period['to']),
      pharmacies: pharmaciesJson is List
          ? pharmaciesJson
              .whereType<Map>()
              .map(
                (item) => RegionStatementPharmacyModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      summary: RegionStatementSummaryModel.fromJson(
        summaryJson,
      ),
    );
  }

  bool get isAllRegions => regionId == 'all';

  bool get isSpecificRegion => regionId != 'all';

  static Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static DateTime _parseDate(dynamic value) {
    return DateTime.tryParse(
          value?.toString() ?? '',
        ) ??
        DateTime.now();
  }
}

class RegionStatementPharmacyModel {
  final String id;
  final String name;
  final String regionId;
  final String regionName;
  final String address;

  final double totalDebit;
  final double totalCredit;
  final double balance;

  final RegionStatementTransactionModel? lastInvoice;
  final RegionStatementTransactionModel? lastPayment;

  const RegionStatementPharmacyModel({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
    required this.address,
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
    required this.lastInvoice,
    required this.lastPayment,
  });

  factory RegionStatementPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegionStatementPharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      regionId: json['regionId']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalDebit:
          (json['totalDebit'] as num?)?.toDouble() ?? 0,
      totalCredit:
          (json['totalCredit'] as num?)?.toDouble() ?? 0,
      balance:
          (json['balance'] as num?)?.toDouble() ?? 0,
      lastInvoice: _transactionFrom(
        json['lastInvoice'],
      ),
      lastPayment: _transactionFrom(
        json['lastPayment'],
      ),
    );
  }

  String get formattedDebit =>
      formatRegionStatementMoney(totalDebit);

  String get formattedCredit =>
      formatRegionStatementMoney(totalCredit);

  String get formattedBalance =>
      formatRegionStatementMoney(balance);

  bool get isFullyPaid => balance <= 0;

  double get collectionRate {
    if (totalDebit <= 0) {
      return 0;
    }

    return (totalCredit / totalDebit).clamp(0, 1);
  }

  String get formattedCollectionRate {
    return '${(collectionRate * 100).toStringAsFixed(0)}%';
  }

  static RegionStatementTransactionModel?
      _transactionFrom(dynamic value) {
    if (value is Map<String, dynamic>) {
      return RegionStatementTransactionModel.fromJson(
        value,
      );
    }

    if (value is Map) {
      return RegionStatementTransactionModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }

    return null;
  }
}

class RegionStatementTransactionModel {
  final String operationNumber;
  final DateTime date;
  final double amount;

  const RegionStatementTransactionModel({
    required this.operationNumber,
    required this.date,
    required this.amount,
  });

  factory RegionStatementTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegionStatementTransactionModel(
      operationNumber:
          json['operationNumber']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      amount:
          (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }

  String get formattedDate =>
      formatRegionStatementDate(date);

  String get formattedAmount =>
      formatRegionStatementMoney(amount);
}

class RegionStatementSummaryModel {
  final int pharmaciesCount;
  final int debtorPharmaciesCount;
  final int fullyPaidPharmaciesCount;

  final double totalDebit;
  final double totalCredit;
  final double totalBalance;

  const RegionStatementSummaryModel({
    required this.pharmaciesCount,
    required this.debtorPharmaciesCount,
    required this.fullyPaidPharmaciesCount,
    required this.totalDebit,
    required this.totalCredit,
    required this.totalBalance,
  });

  factory RegionStatementSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegionStatementSummaryModel(
      pharmaciesCount:
          (json['pharmaciesCount'] as num?)?.toInt() ?? 0,
      debtorPharmaciesCount:
          (json['debtorPharmaciesCount'] as num?)
                  ?.toInt() ??
              0,
      fullyPaidPharmaciesCount:
          (json['fullyPaidPharmaciesCount'] as num?)
                  ?.toInt() ??
              0,
      totalDebit:
          (json['totalDebit'] as num?)?.toDouble() ?? 0,
      totalCredit:
          (json['totalCredit'] as num?)?.toDouble() ?? 0,
      totalBalance:
          (json['totalBalance'] as num?)?.toDouble() ?? 0,
    );
  }

  String get formattedTotalDebit =>
      formatRegionStatementMoney(totalDebit);

  String get formattedTotalCredit =>
      formatRegionStatementMoney(totalCredit);

  String get formattedTotalBalance =>
      formatRegionStatementMoney(totalBalance);
}

String formatRegionStatementMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');

  final integerPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimalPart =
      parts.length > 1 ? parts[1] : '00';

  return '$integerPart.$decimalPart ر.س';
}

String formatRegionStatementDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '${date.year}/$month/$day';
}