Map<String, dynamic>
    buildRegionAccountStatementMockResponse({
  required String regionId,
  required DateTime fromDate,
  required DateTime toDate,
}) {
  final pharmacies = <Map<String, dynamic>>[
    {
      'id': 'PH-001',
      'name': 'صيدلية الشفاء',
      'regionId': 'central_riyadh',
      'regionName': 'منطقة الرياض المركزية',
      'address': 'حي العليا، شارع الملك فهد',
      'totalDebit': 48000.00,
      'totalCredit': 22000.00,
      'lastInvoice': {
        'operationNumber': 'INV-1142',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 0,
          ),
        ),
        'amount': 4250.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-3021',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 2,
          ),
        ),
        'amount': 3500.00,
      },
    },
    {
      'id': 'PH-002',
      'name': 'صيدلية الدواء',
      'regionId': 'central_riyadh',
      'regionName': 'منطقة الرياض المركزية',
      'address': 'حي الملز، طريق صلاح الدين',
      'totalDebit': 42500.00,
      'totalCredit': 39000.00,
      'lastInvoice': {
        'operationNumber': 'INV-1138',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 1,
          ),
        ),
        'amount': 2900.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-3018',
        'date': _formatDate(toDate),
        'amount': 5000.00,
      },
    },
    {
      'id': 'PH-003',
      'name': 'صيدلية النور',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address':
          'حي الصحافة، طريق الملك عبدالعزيز',
      'totalDebit': 61500.00,
      'totalCredit': 50000.00,
      'lastInvoice': {
        'operationNumber': 'INV-1140',
        'date': _formatDate(toDate),
        'amount': 5600.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-3019',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 1,
          ),
        ),
        'amount': 6200.00,
      },
    },
    {
      'id': 'PH-004',
      'name': 'صيدلية الرحمة',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address': 'حي الياسمين، شارع أنس بن مالك',
      'totalDebit': 35000.00,
      'totalCredit': 12000.00,
      'lastInvoice': {
        'operationNumber': 'INV-1129',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 2,
          ),
        ),
        'amount': 3750.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-3004',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 6,
          ),
        ),
        'amount': 1800.00,
      },
    },
    {
      'id': 'PH-005',
      'name': 'صيدلية الحياة',
      'regionId': 'south_riyadh',
      'regionName': 'منطقة جنوب الرياض',
      'address': 'حي الشفا، طريق ديراب',
      'totalDebit': 72000.00,
      'totalCredit': 68500.00,
      'lastInvoice': {
        'operationNumber': 'INV-1141',
        'date': _formatDate(toDate),
        'amount': 6800.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-3020',
        'date': _formatDate(toDate),
        'amount': 7500.00,
      },
    },
    {
      'id': 'PH-006',
      'name': 'صيدلية الأمل',
      'regionId': 'south_riyadh',
      'regionName': 'منطقة جنوب الرياض',
      'address': 'حي بدر، شارع ابن تيمية',
      'totalDebit': 29000.00,
      'totalCredit': 9000.00,
      'lastInvoice': {
        'operationNumber': 'INV-1125',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 3,
          ),
        ),
        'amount': 3100.00,
      },
      'lastPayment': {
        'operationNumber': 'PAY-2998',
        'date': _formatDate(
          _dateInsidePeriod(
            fromDate: fromDate,
            toDate: toDate,
            daysBeforeEnd: 7,
          ),
        ),
        'amount': 1200.00,
      },
    },
  ];

  final filtered = pharmacies
      .where(
        (pharmacy) =>
            regionId == 'all' ||
            pharmacy['regionId'] == regionId,
      )
      .map(
        (pharmacy) => Map<String, dynamic>.from(
          pharmacy,
        ),
      )
      .toList();

  for (final pharmacy in filtered) {
    final debit =
        (pharmacy['totalDebit'] as num).toDouble();

    final credit =
        (pharmacy['totalCredit'] as num).toDouble();

    pharmacy['balance'] = _roundMoney(
      debit - credit,
    );
  }

  filtered.sort(
    (first, second) {
      final regionComparison =
          first['regionName'].toString().compareTo(
                second['regionName'].toString(),
              );

      if (regionComparison != 0) {
        return regionComparison;
      }

      return first['name'].toString().compareTo(
            second['name'].toString(),
          );
    },
  );

  final totalDebit = filtered.fold<double>(
    0,
    (sum, pharmacy) =>
        sum +
        ((pharmacy['totalDebit'] as num?)
                ?.toDouble() ??
            0),
  );

  final totalCredit = filtered.fold<double>(
    0,
    (sum, pharmacy) =>
        sum +
        ((pharmacy['totalCredit'] as num?)
                ?.toDouble() ??
            0),
  );

  final totalBalance = filtered.fold<double>(
    0,
    (sum, pharmacy) =>
        sum +
        ((pharmacy['balance'] as num?)
                ?.toDouble() ??
            0),
  );

  final debtorCount = filtered.where(
    (pharmacy) =>
        ((pharmacy['balance'] as num?)
                ?.toDouble() ??
            0) >
        0,
  ).length;

  final fullyPaidCount = filtered.length - debtorCount;

  return {
    'success': true,
    'message': 'تم تحميل كشف حساب المنطقة',
    'data': {
      'scope': {
        'id': regionId,
        'name': _regionName(regionId),
      },
      'period': {
        'from': _formatDate(fromDate),
        'to': _formatDate(toDate),
      },
      'pharmacies': filtered,
      'summary': {
        'pharmaciesCount': filtered.length,
        'debtorPharmaciesCount': debtorCount,
        'fullyPaidPharmaciesCount':
            fullyPaidCount,
        'totalDebit': _roundMoney(totalDebit),
        'totalCredit': _roundMoney(totalCredit),
        'totalBalance': _roundMoney(totalBalance),
      },
    },
  };
}

DateTime _dateInsidePeriod({
  required DateTime fromDate,
  required DateTime toDate,
  required int daysBeforeEnd,
}) {
  final result = toDate.subtract(
    Duration(days: daysBeforeEnd),
  );

  if (result.isBefore(fromDate)) {
    return fromDate;
  }

  if (result.isAfter(toDate)) {
    return toDate;
  }

  return result;
}

String _regionName(String regionId) {
  switch (regionId) {
    case 'central_riyadh':
      return 'منطقة الرياض المركزية';

    case 'north_riyadh':
      return 'منطقة شمال الرياض';

    case 'south_riyadh':
      return 'منطقة جنوب الرياض';

    default:
      return 'جميع المناطق';
  }
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