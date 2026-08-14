class FinancialPharmacyDetailsModel {
  final String id;
  final String name;
  final String regionId;
  final String regionName;
  final String address;

  final DateTime fromDate;
  final DateTime toDate;

  final double totalSales;
  final double totalCollections;
  final double remainingReceivables;

  final int invoicesCount;
  final int collectionsCount;

  final double averageCollection;

  final FinancialPharmacySaleModel? firstSale;
  final FinancialPharmacySaleModel? lastSale;

  const FinancialPharmacyDetailsModel({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
    required this.address,
    required this.fromDate,
    required this.toDate,
    required this.totalSales,
    required this.totalCollections,
    required this.remainingReceivables,
    required this.invoicesCount,
    required this.collectionsCount,
    required this.averageCollection,
    required this.firstSale,
    required this.lastSale,
  });

  factory FinancialPharmacyDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _toMap(json['data']) ?? json;
    final pharmacy =
        _toMap(data['pharmacy']) ?? <String, dynamic>{};
    final period =
        _toMap(data['period']) ?? <String, dynamic>{};
    final indicators =
        _toMap(data['indicators']) ?? <String, dynamic>{};

    return FinancialPharmacyDetailsModel(
      id: pharmacy['id']?.toString() ?? '',
      name: pharmacy['name']?.toString() ?? '',
      regionId: pharmacy['regionId']?.toString() ?? '',
      regionName:
          pharmacy['regionName']?.toString() ?? '',
      address: pharmacy['address']?.toString() ?? '',
      fromDate: _parseDate(period['from']),
      toDate: _parseDate(period['to']),
      totalSales:
          (indicators['totalSales'] as num?)
                  ?.toDouble() ??
              0,
      totalCollections:
          (indicators['totalCollections'] as num?)
                  ?.toDouble() ??
              0,
      remainingReceivables:
          (indicators['remainingReceivables'] as num?)
                  ?.toDouble() ??
              0,
      invoicesCount:
          (indicators['invoicesCount'] as num?)
                  ?.toInt() ??
              0,
      collectionsCount:
          (indicators['collectionsCount'] as num?)
                  ?.toInt() ??
              0,
      averageCollection:
          (indicators['averageCollection'] as num?)
                  ?.toDouble() ??
              0,
      firstSale: _saleFromJson(
        indicators['firstSale'],
      ),
      lastSale: _saleFromJson(
        indicators['lastSale'],
      ),
    );
  }

  double get collectionRate {
    if (totalSales <= 0) {
      return 0;
    }

    return (totalCollections / totalSales)
        .clamp(0, 1);
  }

  String get formattedSales =>
      formatFinancialPharmacyMoney(totalSales);

  String get formattedCollections =>
      formatFinancialPharmacyMoney(totalCollections);

  String get formattedReceivables =>
      formatFinancialPharmacyMoney(
        remainingReceivables,
      );

  String get formattedAverageCollection =>
      formatFinancialPharmacyMoney(
        averageCollection,
      );

  String get formattedCollectionRate =>
      '${(collectionRate * 100).toStringAsFixed(0)}%';

  bool get isFullyPaid => remainingReceivables <= 0;

  static FinancialPharmacySaleModel? _saleFromJson(
    dynamic value,
  ) {
    final map = _toMap(value);

    if (map == null) {
      return null;
    }

    return FinancialPharmacySaleModel.fromJson(map);
  }

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

class FinancialPharmacySaleModel {
  final String invoiceNumber;
  final DateTime date;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final String status;

  const FinancialPharmacySaleModel({
    required this.invoiceNumber,
    required this.date,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
  });

  factory FinancialPharmacySaleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialPharmacySaleModel(
      invoiceNumber:
          json['invoiceNumber']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      amount:
          (json['amount'] as num?)?.toDouble() ?? 0,
      paidAmount:
          (json['paidAmount'] as num?)?.toDouble() ??
              0,
      remainingAmount:
          (json['remainingAmount'] as num?)
                  ?.toDouble() ??
              0,
      status: json['status']?.toString() ?? '',
    );
  }

  String get formattedDate =>
      formatFinancialPharmacyDate(date);

  String get formattedAmount =>
      formatFinancialPharmacyMoney(amount);

  String get formattedPaidAmount =>
      formatFinancialPharmacyMoney(paidAmount);

  String get formattedRemainingAmount =>
      formatFinancialPharmacyMoney(
        remainingAmount,
      );

  bool get isPaid => remainingAmount <= 0;
}

String formatFinancialPharmacyMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');

  final integerPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimalPart =
      parts.length > 1 ? parts[1] : '00';

  return '$integerPart.$decimalPart ر.س';
}

String formatFinancialPharmacyDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month =
      date.month.toString().padLeft(2, '0');

  return '${date.year}/$month/$day';
}