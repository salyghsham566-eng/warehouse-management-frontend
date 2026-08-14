enum FinancialPharmacySort {
  highestSales,
  highestDebtRisk,
  remainingReceivables,
}

extension FinancialPharmacySortExtension
    on FinancialPharmacySort {
  String get apiValue {
    switch (this) {
      case FinancialPharmacySort.highestSales:
        return 'highest_sales';

      case FinancialPharmacySort.highestDebtRisk:
        return 'highest_debt_risk';

      case FinancialPharmacySort.remainingReceivables:
        return 'remaining_receivables';
    }
  }

  String get label {
    switch (this) {
      case FinancialPharmacySort.highestSales:
        return 'الأعلى بيعاً';

      case FinancialPharmacySort.highestDebtRisk:
        return 'الأعلى ديناً';

      case FinancialPharmacySort.remainingReceivables:
        return 'حسب الذمم الباقية';
    }
  }
}

FinancialPharmacySort financialPharmacySortFromValue(
  dynamic value,
) {
  switch (value?.toString()) {
    case 'highest_debt_risk':
      return FinancialPharmacySort.highestDebtRisk;

    case 'remaining_receivables':
      return FinancialPharmacySort.remainingReceivables;

    case 'highest_sales':
    default:
      return FinancialPharmacySort.highestSales;
  }
}

class FinancialPharmaciesResponseModel {
  final String regionId;
  final String regionName;
  final DateTime fromDate;
  final DateTime toDate;
  final FinancialPharmacySort sort;
  final int totalItems;
  final List<FinancialPharmacyModel> pharmacies;

  const FinancialPharmaciesResponseModel({
    required this.regionId,
    required this.regionName,
    required this.fromDate,
    required this.toDate,
    required this.sort,
    required this.totalItems,
    required this.pharmacies,
  });

  factory FinancialPharmaciesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _mapFrom(json['data']) ?? json;
    final scope = _mapFrom(data['scope']) ??
        <String, dynamic>{};
    final period = _mapFrom(data['period']) ??
        <String, dynamic>{};

    final pharmaciesJson = data['pharmacies'];

    return FinancialPharmaciesResponseModel(
      regionId: scope['id']?.toString() ?? 'all',
      regionName:
          scope['name']?.toString() ?? 'جميع المناطق',
      fromDate: _parseDate(period['from']),
      toDate: _parseDate(period['to']),
      sort: financialPharmacySortFromValue(
        data['sortBy'],
      ),
      totalItems: (data['totalItems'] as num?)?.toInt() ??
          (pharmaciesJson is List
              ? pharmaciesJson.length
              : 0),
      pharmacies: pharmaciesJson is List
          ? pharmaciesJson
              .whereType<Map>()
              .map(
                (item) => FinancialPharmacyModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }

  static Map<String, dynamic>? _mapFrom(dynamic value) {
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

class FinancialPharmacyModel {
  final String id;
  final String name;
  final String regionId;
  final String regionName;
  final String address;

  final double totalSales;
  final double totalCollections;
  final double remainingReceivables;

  final int invoicesCount;
  final int collectionsCount;

  final FinancialTransactionSummaryModel? lastInvoice;
  final FinancialTransactionSummaryModel? lastPayment;

  const FinancialPharmacyModel({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
    required this.address,
    required this.totalSales,
    required this.totalCollections,
    required this.remainingReceivables,
    required this.invoicesCount,
    required this.collectionsCount,
    required this.lastInvoice,
    required this.lastPayment,
  });

  factory FinancialPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialPharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      regionId: json['regionId']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalSales:
          (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalCollections:
          (json['totalCollections'] as num?)?.toDouble() ??
              0,
      remainingReceivables:
          (json['remainingReceivables'] as num?)
                  ?.toDouble() ??
              0,
      invoicesCount:
          (json['invoicesCount'] as num?)?.toInt() ?? 0,
      collectionsCount:
          (json['collectionsCount'] as num?)?.toInt() ??
              0,
      lastInvoice: _transactionFrom(
        json['lastInvoice'],
      ),
      lastPayment: _transactionFrom(
        json['lastPayment'],
      ),
    );
  }

  double get collectionRate {
    if (totalSales <= 0) {
      return 0;
    }

    return totalCollections / totalSales;
  }

  double get debtRiskScore {
    final weakCollectionFactor = 1 - collectionRate;

    return remainingReceivables *
        (1 + weakCollectionFactor);
  }

  String get formattedSales => formatFinancialMoney(
        totalSales,
      );

  String get formattedCollections =>
      formatFinancialMoney(
        totalCollections,
      );

  String get formattedReceivables =>
      formatFinancialMoney(
        remainingReceivables,
      );

  String get formattedCollectionRate =>
      '${(collectionRate * 100).clamp(0, 100).toStringAsFixed(0)}%';

  static FinancialTransactionSummaryModel?
      _transactionFrom(dynamic value) {
    if (value is Map<String, dynamic>) {
      return FinancialTransactionSummaryModel.fromJson(
        value,
      );
    }

    if (value is Map) {
      return FinancialTransactionSummaryModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }

    return null;
  }
}

class FinancialTransactionSummaryModel {
  final String referenceNumber;
  final DateTime date;
  final double amount;

  const FinancialTransactionSummaryModel({
    required this.referenceNumber,
    required this.date,
    required this.amount,
  });

  factory FinancialTransactionSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialTransactionSummaryModel(
      referenceNumber:
          json['referenceNumber']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }

  String get formattedAmount => formatFinancialMoney(
        amount,
      );

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '${date.year}/$month/$day';
  }
}

String formatFinancialMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');

  final integerPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimalPart =
      parts.length > 1 ? parts[1] : '00';

  return '$integerPart.$decimalPart ر.س';
}