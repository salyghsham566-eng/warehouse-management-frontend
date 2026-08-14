
class PharmacyAccountStatementModel {
  final PharmacyStatementPharmacyModel pharmacy;

  final DateTime fromDate;
  final DateTime toDate;

  final double openingBalance;

  final List<PharmacyStatementMovementModel> movements;

  final PharmacyStatementSummaryModel summary;

  const PharmacyAccountStatementModel({
    required this.pharmacy,
    required this.fromDate,
    required this.toDate,
    required this.openingBalance,
    required this.movements,
    required this.summary,
  });

  factory PharmacyAccountStatementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _toMap(json['data']) ?? json;

    final pharmacyJson =
        _toMap(data['pharmacy']) ?? <String, dynamic>{};

    final periodJson =
        _toMap(data['period']) ?? <String, dynamic>{};

    final summaryJson =
        _toMap(data['summary']) ?? <String, dynamic>{};

    final movementsJson = data['movements'];

    final movements = movementsJson is List
        ? movementsJson
            .whereType<Map>()
            .map(
              (item) => PharmacyStatementMovementModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList()
        : <PharmacyStatementMovementModel>[];

    movements.sort(
      (first, second) => first.date.compareTo(second.date),
    );

    return PharmacyAccountStatementModel(
      pharmacy: PharmacyStatementPharmacyModel.fromJson(
        pharmacyJson,
      ),
      fromDate: _parseDate(periodJson['from']),
      toDate: _parseDate(periodJson['to']),
      openingBalance:
          (data['openingBalance'] as num?)?.toDouble() ?? 0,
      movements: movements,
      summary: PharmacyStatementSummaryModel.fromJson(
        summaryJson,
      ),
    );
  }

  bool get hasMovements => movements.isNotEmpty;

  String get formattedOpeningBalance =>
      formatStatementMoney(openingBalance);

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

class PharmacyStatementPharmacyModel {
  final String id;
  final String name;
  final String regionId;
  final String regionName;
  final String address;

  const PharmacyStatementPharmacyModel({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
    required this.address,
  });

  factory PharmacyStatementPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PharmacyStatementPharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      regionId: json['regionId']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}

class PharmacyStatementMovementModel {
  final DateTime date;

  /// invoice | collection | adjustment | return
  final String movementType;

  final String movementTypeLabel;
  final String operationNumber;

  final double debit;
  final double credit;
  final double balance;

  final String? note;

  const PharmacyStatementMovementModel({
    required this.date,
    required this.movementType,
    required this.movementTypeLabel,
    required this.operationNumber,
    required this.debit,
    required this.credit,
    required this.balance,
    this.note,
  });

  factory PharmacyStatementMovementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PharmacyStatementMovementModel(
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      movementType:
          json['movementType']?.toString() ?? '',
      movementTypeLabel:
          json['movementTypeLabel']?.toString() ?? '',
      operationNumber:
          json['operationNumber']?.toString() ?? '',
      debit: (json['debit'] as num?)?.toDouble() ?? 0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      note: json['note']?.toString(),
    );
  }

  bool get isInvoice => movementType == 'invoice';

  bool get isCollection => movementType == 'collection';

  String get formattedDate => formatStatementDate(date);

  String get formattedDebit {
    if (debit <= 0) {
      return '-';
    }

    return formatStatementMoney(debit);
  }

  String get formattedCredit {
    if (credit <= 0) {
      return '-';
    }

    return formatStatementMoney(credit);
  }

  String get formattedBalance =>
      formatStatementMoney(balance);
}

class PharmacyStatementSummaryModel {
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;
  final int movementsCount;

  const PharmacyStatementSummaryModel({
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
    required this.movementsCount,
  });

  factory PharmacyStatementSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PharmacyStatementSummaryModel(
      totalDebit:
          (json['totalDebit'] as num?)?.toDouble() ?? 0,
      totalCredit:
          (json['totalCredit'] as num?)?.toDouble() ?? 0,
      closingBalance:
          (json['closingBalance'] as num?)?.toDouble() ?? 0,
      movementsCount:
          (json['movementsCount'] as num?)?.toInt() ?? 0,
    );
  }

  String get formattedTotalDebit =>
      formatStatementMoney(totalDebit);

  String get formattedTotalCredit =>
      formatStatementMoney(totalCredit);

  String get formattedClosingBalance =>
      formatStatementMoney(closingBalance);
}

String formatStatementMoney(double value) {
  final parts = value.toStringAsFixed(2).split('.');

  final integerPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimalPart =
      parts.length > 1 ? parts[1] : '00';

  return '$integerPart.$decimalPart ر.س';
}

String formatStatementDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '${date.year}/$month/$day';
}