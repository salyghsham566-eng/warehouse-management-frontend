Map<String, dynamic> buildFinancialIndicatorDetailsMockResponse({
  required String indicatorId,
  required DateTime fromDate,
  required DateTime toDate,
  required String regionId,
}) {
  final ratio = _regionRatio(regionId);
  final regionName = _regionName(regionId);

  final totalSales = _roundMoney(128450 * ratio);
  final totalCollections = _roundMoney(95200 * ratio);
  final totalReceivables = _roundMoney(33250 * ratio);

  final invoicesCount = _scaledCount(142, ratio);
  final collectionsCount = _scaledCount(20, ratio);
  final debtorPharmaciesCount = _scaledCount(24, ratio);
  final fullyPaidPharmaciesCount = _scaledCount(18, ratio);

  final averageCollection = collectionsCount == 0
      ? 0.0
      : _roundMoney(totalCollections / collectionsCount);

  final invoices = _buildInvoices(
    fromDate: fromDate,
    toDate: toDate,
    regionId: regionId,
    totalSales: totalSales,
    count: invoicesCount,
    firstInvoiceAmount: _roundMoney(2850 * ratio),
    lastInvoiceAmount: _roundMoney(4120 * ratio),
  );

  final debtorPharmacies = _buildPharmacies(
    toDate: toDate,
    regionId: regionId,
    count: debtorPharmaciesCount,
    totalReceivables: totalReceivables,
    fullyPaid: false,
  );

  final fullyPaidPharmacies = _buildPharmacies(
    toDate: toDate,
    regionId: regionId,
    count: fullyPaidPharmaciesCount,
    totalReceivables: 0,
    fullyPaid: true,
  );

  final firstInvoice = _findFirstInvoice(invoices);
  final lastInvoice = _findLastInvoice(invoices);

  String title;
  String detailType;
  double value;
  String valueType;

  List<Map<String, dynamic>> responseInvoices = const [];
  List<Map<String, dynamic>> responsePharmacies = const [];

  Map<String, dynamic>? collectionSummary;
  Map<String, dynamic>? averageCalculation;
  Map<String, dynamic>? invoice;

  String? note;

  switch (indicatorId) {
    case 'total_sales':
      title = 'إجمالي المبيعات';
      detailType = 'invoice_list';
      value = totalSales;
      valueType = 'currency';
      responseInvoices = invoices;
      note = 'قائمة الفواتير التي تكوّن إجمالي المبيعات خلال الفترة.';
      break;

    case 'invoices_count':
      title = 'عدد الفواتير';
      detailType = 'invoice_list';
      value = invoicesCount.toDouble();
      valueType = 'count';
      responseInvoices = invoices;
      note = 'الفواتير المسجلة ضمن الفترة والنطاق المحددين.';
      break;

    case 'total_receivables':
      title = 'إجمالي الذمم';
      detailType = 'pharmacy_list';
      value = totalReceivables;
      valueType = 'currency';
      responsePharmacies = debtorPharmacies;
      note = 'الصيدليات التي يوجد عليها رصيد مالي مستحق.';
      break;

    case 'debtor_pharmacies':
      title = 'الصيدليات المدينة';
      detailType = 'pharmacy_list';
      value = debtorPharmaciesCount.toDouble();
      valueType = 'count';
      responsePharmacies = debtorPharmacies;
      note = 'الصيدليات التي لديها ذمم مالية باقية.';
      break;

    case 'fully_paid_pharmacies':
      title = 'الصيدليات المسددة بالكامل';
      detailType = 'pharmacy_list';
      value = fullyPaidPharmaciesCount.toDouble();
      valueType = 'count';
      responsePharmacies = fullyPaidPharmacies;
      note = 'صيدليات لا يوجد عليها أي رصيد مالي مستحق.';
      break;

    case 'total_collections':
      title = 'إجمالي التحصيلات';
      detailType = 'collection_summary';
      value = totalCollections;
      valueType = 'currency';
      collectionSummary = {
        'totalCollections': totalCollections,
        'operationsCount': collectionsCount,
        'approvedOperationsCount': collectionsCount,
        'averageCollection': averageCollection,
        'lastCollectionDate': _formatDate(toDate),
      };
      note =
          'التفاصيل الكاملة لعمليات التحصيل متاحة ضمن قسم التحصيل فقط.';
      break;

    case 'collection_operations':
      title = 'عدد عمليات التحصيل';
      detailType = 'collection_summary';
      value = collectionsCount.toDouble();
      valueType = 'count';
      collectionSummary = {
        'totalCollections': totalCollections,
        'operationsCount': collectionsCount,
        'approvedOperationsCount': collectionsCount,
        'averageCollection': averageCollection,
        'lastCollectionDate': _formatDate(toDate),
      };
      note =
          'هذه الشاشة تعرض ملخصاً فقط، وتفاصيل العمليات موجودة في قسم التحصيل.';
      break;

    case 'average_collection':
      title = 'متوسط التحصيل';
      detailType = 'average_calculation';
      value = averageCollection;
      valueType = 'currency';
      averageCalculation = {
        'totalCollections': totalCollections,
        'operationsCount': collectionsCount,
        'result': averageCollection,
      };
      note =
          'متوسط التحصيل يساوي إجمالي التحصيلات مقسوماً على عدد عمليات التحصيل.';
      break;

    case 'first_sale':
      title = 'أول عملية بيع';
      detailType = 'invoice_data';
      value = firstInvoice == null
          ? 0
          : (firstInvoice['amount'] as num).toDouble();
      valueType = 'currency';
      invoice = firstInvoice;
      note = 'أقدم فاتورة بيع ضمن الفترة المحددة.';
      break;

    case 'last_sale':
      title = 'آخر عملية بيع';
      detailType = 'invoice_data';
      value = lastInvoice == null
          ? 0
          : (lastInvoice['amount'] as num).toDouble();
      valueType = 'currency';
      invoice = lastInvoice;
      note = 'أحدث فاتورة بيع ضمن الفترة المحددة.';
      break;

    default:
      title = 'تفاصيل المؤشر';
      detailType = 'summary';
      value = 0;
      valueType = 'count';
      note = 'لا توجد تفاصيل إضافية لهذا المؤشر.';
      break;
  }

  return {
    'success': true,
    'message': 'تم تحميل تفاصيل المؤشر المالي',
    'data': {
      'indicatorId': indicatorId,
      'indicatorTitle': title,
      'detailType': detailType,
      'value': value,
      'valueType': valueType,
      'scope': {
        'id': regionId,
        'name': regionName,
      },
      'period': {
        'from': _formatDate(fromDate),
        'to': _formatDate(toDate),
      },
      'invoices': responseInvoices,
      'pharmacies': responsePharmacies,
      'collectionSummary': collectionSummary,
      'averageCalculation': averageCalculation,
      'invoice': invoice,
      'summaryItems': const [],
      'note': note,
    },
  };
}

List<Map<String, dynamic>> _buildInvoices({
  required DateTime fromDate,
  required DateTime toDate,
  required String regionId,
  required double totalSales,
  required int count,
  required double firstInvoiceAmount,
  required double lastInvoiceAmount,
}) {
  if (count <= 0) {
    return [];
  }

  final safeCount = count < 2 ? 2 : count;

  final remainingTotal = _roundMoney(
    totalSales - firstInvoiceAmount - lastInvoiceAmount,
  );

  final middleAmounts = _distributeTotal(
    remainingTotal < 0 ? 0 : remainingTotal,
    safeCount - 2,
  );

  final amounts = <double>[
    firstInvoiceAmount,
    ...middleAmounts,
    lastInvoiceAmount,
  ];

  final pharmacies = [
    'صيدلية الشفاء',
    'صيدلية الدواء',
    'صيدلية النور',
    'صيدلية الرحمة',
    'صيدلية الحياة',
    'صيدلية الأمل',
    'صيدلية الصحة',
    'صيدلية الندى',
  ];

  final addresses = [
    'حي العليا، شارع الملك فهد',
    'حي الملز، طريق صلاح الدين',
    'حي الصحافة، طريق الملك عبدالعزيز',
    'حي الياسمين، شارع أنس بن مالك',
    'حي الشفا، طريق ديراب',
    'حي بدر، شارع ابن تيمية',
  ];

  final span = toDate.difference(fromDate).inDays;
  final safeSpan = span < 0 ? 0 : span;

  final result = <Map<String, dynamic>>[];

  for (var index = 0; index < safeCount; index++) {
    final region = _regionForIndex(
      requestedRegionId: regionId,
      index: index,
    );

    final dayOffset = safeCount <= 1
        ? 0
        : ((safeSpan * index) / (safeCount - 1)).round();

    final date = fromDate.add(
      Duration(days: dayOffset),
    );

    final amount = amounts[index];

    final partiallyPaid = index % 5 == 0;
    final paidAmount = partiallyPaid
        ? _roundMoney(amount * 0.65)
        : amount;

    final remainingAmount = _roundMoney(
      amount - paidAmount,
    );

    result.add({
      'invoiceNumber':
          'INV-${(1001 + index).toString().padLeft(4, '0')}',
      'pharmacyId':
          'PH-${((index % 30) + 1).toString().padLeft(3, '0')}',
      'pharmacyName':
          pharmacies[index % pharmacies.length],
      'regionName': region['name'],
      'address': addresses[index % addresses.length],
      'date': _formatDate(date),
      'amount': amount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'status': remainingAmount <= 0
          ? 'مسددة'
          : 'مسددة جزئياً',
    });
  }

  result.sort(
    (first, second) {
      final firstDate = DateTime.parse(
        first['date'].toString(),
      );

      final secondDate = DateTime.parse(
        second['date'].toString(),
      );

      return secondDate.compareTo(firstDate);
    },
  );

  return result;
}

List<Map<String, dynamic>> _buildPharmacies({
  required DateTime toDate,
  required String regionId,
  required int count,
  required double totalReceivables,
  required bool fullyPaid,
}) {
  if (count <= 0) {
    return [];
  }

  final receivables = fullyPaid
      ? List<double>.filled(count, 0)
      : _distributeTotal(totalReceivables, count);

  final names = [
    'صيدلية الشفاء',
    'صيدلية الدواء',
    'صيدلية النور',
    'صيدلية الرحمة',
    'صيدلية الحياة',
    'صيدلية الأمل',
    'صيدلية الصحة',
    'صيدلية الندى',
  ];

  final addresses = [
    'حي العليا، شارع الملك فهد',
    'حي الملز، طريق صلاح الدين',
    'حي الصحافة، طريق الملك عبدالعزيز',
    'حي الياسمين، شارع أنس بن مالك',
    'حي الشفا، طريق ديراب',
    'حي بدر، شارع ابن تيمية',
  ];

  final result = <Map<String, dynamic>>[];

  for (var index = 0; index < count; index++) {
    final region = _regionForIndex(
      requestedRegionId: regionId,
      index: index,
    );

    final receivable = receivables[index];

    final sales = fullyPaid
        ? _roundMoney(5000 + (index * 425))
        : _roundMoney(
            receivable * (1.8 + ((index % 4) * 0.22)),
          );

    final collections = fullyPaid
        ? sales
        : _roundMoney(sales - receivable);

    result.add({
      'id':
          'PH-${((index + 1)).toString().padLeft(3, '0')}',
      'name':
          '${names[index % names.length]} ${index + 1}',
      'regionName': region['name'],
      'address': addresses[index % addresses.length],
      'totalSales': sales,
      'totalCollections': collections,
      'remainingReceivables': receivable,
      'invoicesCount': 2 + (index % 12),
      'collectionsCount': 1 + (index % 7),
      'lastInvoiceDate': _formatDate(
        toDate.subtract(
          Duration(days: index % 10),
        ),
      ),
      'lastPaymentDate': _formatDate(
        toDate.subtract(
          Duration(days: index % 14),
        ),
      ),
    });
  }

  result.sort(
    (first, second) {
      return ((second['remainingReceivables'] as num?) ?? 0)
          .compareTo(
        (first['remainingReceivables'] as num?) ?? 0,
      );
    },
  );

  return result;
}

List<double> _distributeTotal(
  double total,
  int count,
) {
  if (count <= 0) {
    return [];
  }

  final weights = List<double>.generate(
    count,
    (index) {
      return 1 + (((index % 7) - 3) * 0.04);
    },
  );

  final weightsTotal = weights.fold<double>(
    0,
    (sum, weight) => sum + weight,
  );

  final values = <double>[];
  var usedTotal = 0.0;

  for (var index = 0; index < count; index++) {
    if (index == count - 1) {
      values.add(
        _roundMoney(total - usedTotal),
      );

      break;
    }

    final value = _roundMoney(
      total * (weights[index] / weightsTotal),
    );

    values.add(value);
    usedTotal = _roundMoney(usedTotal + value);
  }

  return values;
}

Map<String, dynamic>? _findFirstInvoice(
  List<Map<String, dynamic>> invoices,
) {
  if (invoices.isEmpty) {
    return null;
  }

  Map<String, dynamic> first = invoices.first;

  for (final invoice in invoices.skip(1)) {
    final currentDate = DateTime.parse(
      invoice['date'].toString(),
    );

    final firstDate = DateTime.parse(
      first['date'].toString(),
    );

    if (currentDate.isBefore(firstDate)) {
      first = invoice;
    }
  }

  return first;
}

Map<String, dynamic>? _findLastInvoice(
  List<Map<String, dynamic>> invoices,
) {
  if (invoices.isEmpty) {
    return null;
  }

  Map<String, dynamic> last = invoices.first;

  for (final invoice in invoices.skip(1)) {
    final currentDate = DateTime.parse(
      invoice['date'].toString(),
    );

    final lastDate = DateTime.parse(
      last['date'].toString(),
    );

    if (currentDate.isAfter(lastDate)) {
      last = invoice;
    }
  }

  return last;
}

Map<String, String> _regionForIndex({
  required String requestedRegionId,
  required int index,
}) {
  if (requestedRegionId != 'all') {
    return {
      'id': requestedRegionId,
      'name': _regionName(requestedRegionId),
    };
  }

  const regions = [
    {
      'id': 'central_riyadh',
      'name': 'منطقة الرياض المركزية',
    },
    {
      'id': 'north_riyadh',
      'name': 'منطقة شمال الرياض',
    },
    {
      'id': 'south_riyadh',
      'name': 'منطقة جنوب الرياض',
    },
  ];

  return regions[index % regions.length];
}

double _regionRatio(String regionId) {
  switch (regionId) {
    case 'central_riyadh':
      return 0.46;

    case 'north_riyadh':
      return 0.31;

    case 'south_riyadh':
      return 0.23;

    default:
      return 1;
  }
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

int _scaledCount(
  int originalValue,
  double ratio,
) {
  final result = (originalValue * ratio).round();

  return result <= 0 ? 1 : result;
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