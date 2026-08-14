Map<String, dynamic>
    buildPharmacyAccountStatementMockResponse({
  required String pharmacyId,
  required DateTime fromDate,
  required DateTime toDate,
}) {
  final pharmacies = <String, Map<String, dynamic>>{
    'PH-001': {
      'id': 'PH-001',
      'name': 'صيدلية الشفاء',
      'regionId': 'central_riyadh',
      'regionName': 'منطقة الرياض المركزية',
      'address': 'حي العليا، شارع الملك فهد',
      'totalSales': 48000.00,
      'totalCollections': 22000.00,
    },
    'PH-002': {
      'id': 'PH-002',
      'name': 'صيدلية الدواء',
      'regionId': 'central_riyadh',
      'regionName': 'منطقة الرياض المركزية',
      'address': 'حي الملز، طريق صلاح الدين',
      'totalSales': 42500.00,
      'totalCollections': 39000.00,
    },
    'PH-003': {
      'id': 'PH-003',
      'name': 'صيدلية النور',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address': 'حي الصحافة، طريق الملك عبدالعزيز',
      'totalSales': 61500.00,
      'totalCollections': 50000.00,
    },
    'PH-004': {
      'id': 'PH-004',
      'name': 'صيدلية الرحمة',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address': 'حي الياسمين، شارع أنس بن مالك',
      'totalSales': 35000.00,
      'totalCollections': 12000.00,
    },
    'PH-005': {
      'id': 'PH-005',
      'name': 'صيدلية الحياة',
      'regionId': 'south_riyadh',
      'regionName': 'منطقة جنوب الرياض',
      'address': 'حي الشفا، طريق ديراب',
      'totalSales': 72000.00,
      'totalCollections': 68500.00,
    },
    'PH-006': {
      'id': 'PH-006',
      'name': 'صيدلية الأمل',
      'regionId': 'south_riyadh',
      'regionName': 'منطقة جنوب الرياض',
      'address': 'حي بدر، شارع ابن تيمية',
      'totalSales': 29000.00,
      'totalCollections': 9000.00,
    },
  };

  final pharmacy =
      pharmacies[pharmacyId] ?? pharmacies['PH-001']!;

  final totalSales =
      (pharmacy['totalSales'] as num).toDouble();

  final totalCollections =
      (pharmacy['totalCollections'] as num).toDouble();

  // يتطابق الرصيد النهائي مع:
  // الرصيد السابق + المبيعات - التحصيلات.
  const openingBalance = 0.0;

  final invoiceAmounts = _splitAmount(
    totalSales,
    const [
      0.22,
      0.27,
      0.18,
      0.33,
    ],
  );

  final collectionAmounts = _splitAmount(
    totalCollections,
    const [
      0.40,
      0.60,
    ],
  );

  final code = pharmacyId.replaceAll('PH-', '');

  final rawMovements = <Map<String, dynamic>>[
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.05,
      ),
      'movementType': 'invoice',
      'movementTypeLabel': 'فاتورة بيع',
      'operationNumber': 'INV-$code-001',
      'debit': invoiceAmounts[0],
      'credit': 0.0,
      'note': 'فاتورة بيع للصيدلية',
    },
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.22,
      ),
      'movementType': 'invoice',
      'movementTypeLabel': 'فاتورة بيع',
      'operationNumber': 'INV-$code-002',
      'debit': invoiceAmounts[1],
      'credit': 0.0,
      'note': 'فاتورة بيع للصيدلية',
    },
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.38,
      ),
      'movementType': 'collection',
      'movementTypeLabel': 'دفعة تحصيل',
      'operationNumber': 'PAY-$code-001',
      'debit': 0.0,
      'credit': collectionAmounts[0],
      'note': 'دفعة تحصيل معتمدة',
    },
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.55,
      ),
      'movementType': 'invoice',
      'movementTypeLabel': 'فاتورة بيع',
      'operationNumber': 'INV-$code-003',
      'debit': invoiceAmounts[2],
      'credit': 0.0,
      'note': 'فاتورة بيع للصيدلية',
    },
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.73,
      ),
      'movementType': 'collection',
      'movementTypeLabel': 'دفعة تحصيل',
      'operationNumber': 'PAY-$code-002',
      'debit': 0.0,
      'credit': collectionAmounts[1],
      'note': 'دفعة تحصيل معتمدة',
    },
    {
      'date': _dateAt(
        fromDate,
        toDate,
        0.94,
      ),
      'movementType': 'invoice',
      'movementTypeLabel': 'فاتورة بيع',
      'operationNumber': 'INV-$code-004',
      'debit': invoiceAmounts[3],
      'credit': 0.0,
      'note': 'فاتورة بيع للصيدلية',
    },
  ];

  rawMovements.sort(
    (first, second) {
      final firstDate = first['date'] as DateTime;
      final secondDate = second['date'] as DateTime;

      return firstDate.compareTo(secondDate);
    },
  );

  var currentBalance = openingBalance;

  final movements = <Map<String, dynamic>>[];

  for (final movement in rawMovements) {
    final debit =
        (movement['debit'] as num).toDouble();

    final credit =
        (movement['credit'] as num).toDouble();

    currentBalance = _roundMoney(
      currentBalance + debit - credit,
    );

    movements.add({
      'date': _formatDate(
        movement['date'] as DateTime,
      ),
      'movementType': movement['movementType'],
      'movementTypeLabel':
          movement['movementTypeLabel'],
      'operationNumber':
          movement['operationNumber'],
      'debit': debit,
      'credit': credit,
      'balance': currentBalance,
      'note': movement['note'],
    });
  }

  final totalDebit = movements.fold<double>(
    0,
    (sum, movement) {
      return sum +
          ((movement['debit'] as num?)?.toDouble() ?? 0);
    },
  );

  final totalCredit = movements.fold<double>(
    0,
    (sum, movement) {
      return sum +
          ((movement['credit'] as num?)?.toDouble() ?? 0);
    },
  );

  final closingBalance = _roundMoney(
    openingBalance + totalDebit - totalCredit,
  );

  return {
    'success': true,
    'message': 'تم تحميل كشف حساب الصيدلية',
    'data': {
      'pharmacy': {
        'id': pharmacy['id'],
        'name': pharmacy['name'],
        'regionId': pharmacy['regionId'],
        'regionName': pharmacy['regionName'],
        'address': pharmacy['address'],
      },
      'period': {
        'from': _formatDate(fromDate),
        'to': _formatDate(toDate),
      },
      'openingBalance': openingBalance,
      'movements': movements,
      'summary': {
        'totalDebit': _roundMoney(totalDebit),
        'totalCredit': _roundMoney(totalCredit),
        'closingBalance': closingBalance,
        'movementsCount': movements.length,
      },
    },
  };
}

List<double> _splitAmount(
  double total,
  List<double> ratios,
) {
  final values = <double>[];

  var usedAmount = 0.0;

  for (var index = 0; index < ratios.length; index++) {
    if (index == ratios.length - 1) {
      values.add(
        _roundMoney(total - usedAmount),
      );

      break;
    }

    final value = _roundMoney(
      total * ratios[index],
    );

    values.add(value);

    usedAmount = _roundMoney(
      usedAmount + value,
    );
  }

  return values;
}

DateTime _dateAt(
  DateTime fromDate,
  DateTime toDate,
  double percentage,
) {
  final difference = toDate.difference(fromDate).inDays;

  if (difference <= 0) {
    return fromDate;
  }

  final offset = (difference * percentage).round();

  return fromDate.add(
    Duration(days: offset),
  );
}

double _roundMoney(double value) {
  return double.parse(
    value.toStringAsFixed(2),
  );
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}