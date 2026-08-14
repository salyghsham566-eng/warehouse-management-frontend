import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';

Map<String, dynamic> buildFinancialPharmaciesMockResponse({
  required DateTime fromDate,
  required DateTime toDate,
  required String regionId,
  required FinancialPharmacySort sort,
}) {
  final pharmacies = <Map<String, dynamic>>[
    {
      'id': 'PH-001',
      'name': 'صيدلية الشفاء',
      'regionId': 'central_riyadh',
      'regionName': 'منطقة الرياض المركزية',
      'address': 'حي العليا، شارع الملك فهد',
      'totalSales': 48000.00,
      'totalCollections': 22000.00,
      'remainingReceivables': 26000.00,
      'invoicesCount': 18,
      'collectionsCount': 5,
      'lastInvoice': {
        'referenceNumber': 'INV-1142',
        'date': _formatDate(toDate),
        'amount': 4250.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-3021',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 2),
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
      'totalSales': 42500.00,
      'totalCollections': 39000.00,
      'remainingReceivables': 3500.00,
      'invoicesCount': 15,
      'collectionsCount': 9,
      'lastInvoice': {
        'referenceNumber': 'INV-1138',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 1),
          ),
        ),
        'amount': 2900.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-3018',
        'date': _formatDate(toDate),
        'amount': 5000.00,
      },
    },
    {
      'id': 'PH-003',
      'name': 'صيدلية النور',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address': 'حي الصحافة، طريق الملك عبدالعزيز',
      'totalSales': 61500.00,
      'totalCollections': 50000.00,
      'remainingReceivables': 11500.00,
      'invoicesCount': 22,
      'collectionsCount': 11,
      'lastInvoice': {
        'referenceNumber': 'INV-1140',
        'date': _formatDate(toDate),
        'amount': 5600.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-3019',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 1),
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
      'totalSales': 35000.00,
      'totalCollections': 12000.00,
      'remainingReceivables': 23000.00,
      'invoicesCount': 13,
      'collectionsCount': 3,
      'lastInvoice': {
        'referenceNumber': 'INV-1129',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 2),
          ),
        ),
        'amount': 3750.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-3004',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 8),
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
      'totalSales': 72000.00,
      'totalCollections': 68500.00,
      'remainingReceivables': 3500.00,
      'invoicesCount': 27,
      'collectionsCount': 14,
      'lastInvoice': {
        'referenceNumber': 'INV-1141',
        'date': _formatDate(toDate),
        'amount': 6800.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-3020',
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
      'totalSales': 29000.00,
      'totalCollections': 9000.00,
      'remainingReceivables': 20000.00,
      'invoicesCount': 11,
      'collectionsCount': 2,
      'lastInvoice': {
        'referenceNumber': 'INV-1125',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 3),
          ),
        ),
        'amount': 3100.00,
      },
      'lastPayment': {
        'referenceNumber': 'PAY-2998',
        'date': _formatDate(
          toDate.subtract(
            const Duration(days: 12),
          ),
        ),
        'amount': 1200.00,
      },
    },
  ];

  final filteredPharmacies = pharmacies
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

  filteredPharmacies.sort(
    (first, second) {
      switch (sort) {
        case FinancialPharmacySort.highestSales:
          return _number(second['totalSales']).compareTo(
            _number(first['totalSales']),
          );

        case FinancialPharmacySort.remainingReceivables:
          return _number(
            second['remainingReceivables'],
          ).compareTo(
            _number(first['remainingReceivables']),
          );

        case FinancialPharmacySort.highestDebtRisk:
          return _debtRiskScore(second).compareTo(
            _debtRiskScore(first),
          );
      }
    },
  );

  return {
    'success': true,
    'message': 'تم تحميل قائمة الصيدليات المالية',
    'data': {
      'scope': {
        'id': regionId,
        'name': _regionName(regionId),
      },
      'period': {
        'from': _formatDate(fromDate),
        'to': _formatDate(toDate),
      },
      'sortBy': sort.apiValue,
      'totalItems': filteredPharmacies.length,
      'pharmacies': filteredPharmacies,
    },
  };
}

double _debtRiskScore(
  Map<String, dynamic> pharmacy,
) {
  final sales = _number(pharmacy['totalSales']);
  final collections =
      _number(pharmacy['totalCollections']);
  final receivables =
      _number(pharmacy['remainingReceivables']);

  final collectionRate = sales <= 0
      ? 0.0
      : collections / sales;

  return receivables * (2 - collectionRate);
}

double _number(dynamic value) {
  return (value as num?)?.toDouble() ?? 0;
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

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}