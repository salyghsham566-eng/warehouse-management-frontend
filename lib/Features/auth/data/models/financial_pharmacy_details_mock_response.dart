Map<String, dynamic>
    buildFinancialPharmacyDetailsMockResponse({
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
      'remainingReceivables': 26000.00,
      'invoicesCount': 18,
      'collectionsCount': 5,
    },
    'PH-002': {
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
    },
    'PH-003': {
      'id': 'PH-003',
      'name': 'صيدلية النور',
      'regionId': 'north_riyadh',
      'regionName': 'منطقة شمال الرياض',
      'address':
          'حي الصحافة، طريق الملك عبدالعزيز',
      'totalSales': 61500.00,
      'totalCollections': 50000.00,
      'remainingReceivables': 11500.00,
      'invoicesCount': 22,
      'collectionsCount': 11,
    },
    'PH-004': {
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
    },
    'PH-005': {
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
    },
    'PH-006': {
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
    },
  };

  final pharmacy =
      pharmacies[pharmacyId] ?? pharmacies['PH-001']!;

  final totalSales =
      (pharmacy['totalSales'] as num).toDouble();

  final totalCollections =
      (pharmacy['totalCollections'] as num)
          .toDouble();

  final remainingReceivables =
      (pharmacy['remainingReceivables'] as num)
          .toDouble();

  final invoicesCount =
      (pharmacy['invoicesCount'] as num).toInt();

  final collectionsCount =
      (pharmacy['collectionsCount'] as num).toInt();

  final averageCollection = collectionsCount <= 0
      ? 0.0
      : _roundMoney(
          totalCollections / collectionsCount,
        );

  final firstSaleDate = fromDate;

  final lastSaleDate = toDate;

  final firstSaleAmount = _roundMoney(
    totalSales * 0.08,
  );

  final lastSaleAmount = _roundMoney(
    totalSales * 0.11,
  );

  return {
    'success': true,
    'message': 'تم تحميل بطاقة الصيدلية المالية',
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
      'indicators': {
        'totalSales': totalSales,
        'totalCollections': totalCollections,
        'remainingReceivables':
            remainingReceivables,
        'invoicesCount': invoicesCount,
        'collectionsCount': collectionsCount,
        'averageCollection': averageCollection,
        'firstSale': {
          'invoiceNumber':
              'INV-${pharmacyId.replaceAll('PH-', '')}-001',
          'date': _formatDate(firstSaleDate),
          'amount': firstSaleAmount,
          'paidAmount': firstSaleAmount,
          'remainingAmount': 0.0,
          'status': 'مسددة',
        },
        'lastSale': {
          'invoiceNumber':
              'INV-${pharmacyId.replaceAll('PH-', '')}-${invoicesCount.toString().padLeft(3, '0')}',
          'date': _formatDate(lastSaleDate),
          'amount': lastSaleAmount,
          'paidAmount': remainingReceivables > 0
              ? _roundMoney(lastSaleAmount * 0.55)
              : lastSaleAmount,
          'remainingAmount': remainingReceivables > 0
              ? _roundMoney(lastSaleAmount * 0.45)
              : 0.0,
          'status': remainingReceivables > 0
              ? 'مسددة جزئياً'
              : 'مسددة',
        },
      },
    },
  };
}

double _roundMoney(double value) {
  return double.parse(
    value.toStringAsFixed(2),
  );
}

String _formatDate(DateTime date) {
  final month =
      date.month.toString().padLeft(2, '0');

  final day =
      date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}