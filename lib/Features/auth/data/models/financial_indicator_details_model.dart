class FinancialIndicatorDetailsResponseModel {
  final String indicatorId;
  final String indicatorTitle;
  final String detailType;

  final double value;
  final String valueType;

  final String regionId;
  final String regionName;
  final DateTime fromDate;
  final DateTime toDate;

  final List<FinancialIndicatorInvoiceModel> invoices;
  final List<FinancialIndicatorPharmacyModel> pharmacies;

  final FinancialCollectionSummaryModel? collectionSummary;
  final FinancialAverageCalculationModel? averageCalculation;
  final FinancialIndicatorInvoiceModel? invoice;

  final List<FinancialIndicatorSummaryItemModel> summaryItems;
  final String? note;

  const FinancialIndicatorDetailsResponseModel({
    required this.indicatorId,
    required this.indicatorTitle,
    required this.detailType,
    required this.value,
    required this.valueType,
    required this.regionId,
    required this.regionName,
    required this.fromDate,
    required this.toDate,
    required this.invoices,
    required this.pharmacies,
    required this.summaryItems,
    this.collectionSummary,
    this.averageCalculation,
    this.invoice,
    this.note,
  });

  factory FinancialIndicatorDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _toMap(json['data']) ?? json;
    final scope = _toMap(data['scope']) ?? <String, dynamic>{};
    final period = _toMap(data['period']) ?? <String, dynamic>{};

    final invoicesJson = data['invoices'];
    final pharmaciesJson = data['pharmacies'];
    final summaryItemsJson = data['summaryItems'];

    return FinancialIndicatorDetailsResponseModel(
      indicatorId: data['indicatorId']?.toString() ?? '',
      indicatorTitle: data['indicatorTitle']?.toString() ?? '',
      detailType: data['detailType']?.toString() ?? 'summary',
      value: (data['value'] as num?)?.toDouble() ?? 0,
      valueType: data['valueType']?.toString() ?? 'count',
      regionId: scope['id']?.toString() ?? 'all',
      regionName:
          scope['name']?.toString() ?? 'جميع المناطق',
      fromDate: _parseDate(period['from']),
      toDate: _parseDate(period['to']),
      invoices: invoicesJson is List
          ? invoicesJson
              .whereType<Map>()
              .map(
                (item) => FinancialIndicatorInvoiceModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      pharmacies: pharmaciesJson is List
          ? pharmaciesJson
              .whereType<Map>()
              .map(
                (item) =>
                    FinancialIndicatorPharmacyModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      collectionSummary: _toMap(data['collectionSummary']) == null
          ? null
          : FinancialCollectionSummaryModel.fromJson(
              _toMap(data['collectionSummary'])!,
            ),
      averageCalculation:
          _toMap(data['averageCalculation']) == null
              ? null
              : FinancialAverageCalculationModel.fromJson(
                  _toMap(data['averageCalculation'])!,
                ),
      invoice: _toMap(data['invoice']) == null
          ? null
          : FinancialIndicatorInvoiceModel.fromJson(
              _toMap(data['invoice'])!,
            ),
      summaryItems: summaryItemsJson is List
          ? summaryItemsJson
              .whereType<Map>()
              .map(
                (item) =>
                    FinancialIndicatorSummaryItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      note: data['note']?.toString(),
    );
  }

  bool get showsInvoiceList => detailType == 'invoice_list';

  bool get showsPharmacyList => detailType == 'pharmacy_list';

  bool get showsCollectionSummary =>
      detailType == 'collection_summary';

  bool get showsAverageCalculation =>
      detailType == 'average_calculation';

  bool get showsInvoiceData => detailType == 'invoice_data';

  String get formattedValue {
    if (valueType == 'currency') {
      return formatFinancialIndicatorMoney(value);
    }

    return value.toInt().toString();
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
    return DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.now();
  }
}

class FinancialIndicatorInvoiceModel {
  final String invoiceNumber;
  final String pharmacyId;
  final String pharmacyName;
  final String regionName;
  final String address;

  final DateTime date;

  final double amount;
  final double paidAmount;
  final double remainingAmount;

  final String status;

  const FinancialIndicatorInvoiceModel({
    required this.invoiceNumber,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.regionName,
    required this.address,
    required this.date,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
  });

  factory FinancialIndicatorInvoiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialIndicatorInvoiceModel(
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      pharmacyId: json['pharmacyId']?.toString() ?? '',
      pharmacyName: json['pharmacyName']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paidAmount:
          (json['paidAmount'] as num?)?.toDouble() ?? 0,
      remainingAmount:
          (json['remainingAmount'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
    );
  }

  String get formattedAmount =>
      formatFinancialIndicatorMoney(amount);

  String get formattedPaidAmount =>
      formatFinancialIndicatorMoney(paidAmount);

  String get formattedRemainingAmount =>
      formatFinancialIndicatorMoney(remainingAmount);

  String get formattedDate => formatFinancialIndicatorDate(date);

  bool get isPaid => remainingAmount <= 0;
}

class FinancialIndicatorPharmacyModel {
  final String id;
  final String name;
  final String regionName;
  final String address;

  final double totalSales;
  final double totalCollections;
  final double remainingReceivables;

  final int invoicesCount;
  final int collectionsCount;

  final DateTime? lastInvoiceDate;
  final DateTime? lastPaymentDate;

  const FinancialIndicatorPharmacyModel({
    required this.id,
    required this.name,
    required this.regionName,
    required this.address,
    required this.totalSales,
    required this.totalCollections,
    required this.remainingReceivables,
    required this.invoicesCount,
    required this.collectionsCount,
    required this.lastInvoiceDate,
    required this.lastPaymentDate,
  });

  factory FinancialIndicatorPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialIndicatorPharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      totalSales:
          (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalCollections:
          (json['totalCollections'] as num?)?.toDouble() ?? 0,
      remainingReceivables:
          (json['remainingReceivables'] as num?)?.toDouble() ??
              0,
      invoicesCount:
          (json['invoicesCount'] as num?)?.toInt() ?? 0,
      collectionsCount:
          (json['collectionsCount'] as num?)?.toInt() ?? 0,
      lastInvoiceDate: DateTime.tryParse(
        json['lastInvoiceDate']?.toString() ?? '',
      ),
      lastPaymentDate: DateTime.tryParse(
        json['lastPaymentDate']?.toString() ?? '',
      ),
    );
  }

  String get formattedSales =>
      formatFinancialIndicatorMoney(totalSales);

  String get formattedCollections =>
      formatFinancialIndicatorMoney(totalCollections);

  String get formattedReceivables =>
      formatFinancialIndicatorMoney(remainingReceivables);

  bool get isFullyPaid => remainingReceivables <= 0;
}

class FinancialCollectionSummaryModel {
  final double totalCollections;
  final int operationsCount;
  final int approvedOperationsCount;
  final double averageCollection;
  final DateTime? lastCollectionDate;

  const FinancialCollectionSummaryModel({
    required this.totalCollections,
    required this.operationsCount,
    required this.approvedOperationsCount,
    required this.averageCollection,
    required this.lastCollectionDate,
  });

  factory FinancialCollectionSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialCollectionSummaryModel(
      totalCollections:
          (json['totalCollections'] as num?)?.toDouble() ?? 0,
      operationsCount:
          (json['operationsCount'] as num?)?.toInt() ?? 0,
      approvedOperationsCount:
          (json['approvedOperationsCount'] as num?)?.toInt() ??
              0,
      averageCollection:
          (json['averageCollection'] as num?)?.toDouble() ?? 0,
      lastCollectionDate: DateTime.tryParse(
        json['lastCollectionDate']?.toString() ?? '',
      ),
    );
  }

  String get formattedTotalCollections =>
      formatFinancialIndicatorMoney(totalCollections);

  String get formattedAverageCollection =>
      formatFinancialIndicatorMoney(averageCollection);
}

class FinancialAverageCalculationModel {
  final double totalCollections;
  final int operationsCount;
  final double result;

  const FinancialAverageCalculationModel({
    required this.totalCollections,
    required this.operationsCount,
    required this.result,
  });

  factory FinancialAverageCalculationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialAverageCalculationModel(
      totalCollections:
          (json['totalCollections'] as num?)?.toDouble() ?? 0,
      operationsCount:
          (json['operationsCount'] as num?)?.toInt() ?? 0,
      result: (json['result'] as num?)?.toDouble() ?? 0,
    );
  }

  String get formattedTotalCollections =>
      formatFinancialIndicatorMoney(totalCollections);

  String get formattedResult =>
      formatFinancialIndicatorMoney(result);
}

class FinancialIndicatorSummaryItemModel {
  final String label;
  final String value;

  const FinancialIndicatorSummaryItemModel({
    required this.label,
    required this.value,
  });

  factory FinancialIndicatorSummaryItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialIndicatorSummaryItemModel(
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

String formatFinancialIndicatorMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');

  final integerPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimalPart = parts.length > 1 ? parts[1] : '00';

  return '$integerPart.$decimalPart ر.س';
}

String formatFinancialIndicatorDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '${date.year}/$month/$day';
}