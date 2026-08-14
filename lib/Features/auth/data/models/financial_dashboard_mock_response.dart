Map<String, dynamic> buildFinancialDashboardMockResponse({
  required DateTime fromDate,
  required DateTime toDate,
  required String regionId,
}) {
  const regions = [
    {
      'id': 'all',
      'name': 'جميع المناطق',
    },
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

  const regionNames = {
    'all': 'جميع المناطق',
    'central_riyadh': 'منطقة الرياض المركزية',
    'north_riyadh': 'منطقة شمال الرياض',
    'south_riyadh': 'منطقة جنوب الرياض',
  };

  const regionRatios = {
    'all': 1.0,
    'central_riyadh': 0.46,
    'north_riyadh': 0.31,
    'south_riyadh': 0.23,
  };

  final ratio = regionRatios[regionId] ?? 1.0;
  final regionName = regionNames[regionId] ?? 'جميع المناطق';

  double money(double originalValue) {
    return double.parse(
      (originalValue * ratio).toStringAsFixed(2),
    );
  }

  int count(int originalValue) {
    return (originalValue * ratio).round();
  }

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String moneyText(double value) {
    return '${value.toStringAsFixed(2)} ر.س';
  }

  final totalSales = money(128450);
  final totalCollections = money(95200);
  final totalReceivables = money(33250);
  final averageCollection = money(4760);

  return {
    'success': true,
    'message': 'تم تحميل المؤشرات المالية بنجاح',
    'data': {
      'scope': {
        'id': regionId,
        'name': regionName,
      },
      'period': {
        'from': formatDate(fromDate),
        'to': formatDate(toDate),
      },
      'regions': regions,
      'metrics': [
        {
          'id': 'total_sales',
          'title': 'إجمالي المبيعات',
          'value': totalSales,
          'valueType': 'currency',
          'iconKey': 'sales',
          'subtitle': 'قيمة المبيعات خلال الفترة المحددة',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'من تاريخ',
              'value': formatDate(fromDate),
            },
            {
              'label': 'إلى تاريخ',
              'value': formatDate(toDate),
            },
            {
              'label': 'عدد الفواتير',
              'value': count(142).toString(),
            },
            {
              'label': 'إجمالي المبيعات',
              'value': moneyText(totalSales),
            },
          ],
        },
        {
          'id': 'total_collections',
          'title': 'إجمالي التحصيلات',
          'value': totalCollections,
          'valueType': 'currency',
          'iconKey': 'collections',
          'subtitle': 'إجمالي المبالغ المحصلة والمعتمدة',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'عدد عمليات التحصيل',
              'value': count(20).toString(),
            },
            {
              'label': 'متوسط التحصيل',
              'value': moneyText(averageCollection),
            },
            {
              'label': 'إجمالي التحصيلات',
              'value': moneyText(totalCollections),
            },
          ],
        },
        {
          'id': 'total_receivables',
          'title': 'إجمالي الذمم',
          'value': totalReceivables,
          'valueType': 'currency',
          'iconKey': 'receivables',
          'subtitle': 'إجمالي المبالغ المستحقة غير المحصلة',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'الصيدليات المدينة',
              'value': count(24).toString(),
            },
            {
              'label': 'إجمالي الذمم',
              'value': moneyText(totalReceivables),
            },
          ],
        },
        {
          'id': 'debtor_pharmacies',
          'title': 'الصيدليات المدينة',
          'value': count(24),
          'valueType': 'count',
          'iconKey': 'pharmacy_debt',
          'subtitle': 'صيدليات لديها رصيد مستحق',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'عدد الصيدليات المدينة',
              'value': count(24).toString(),
            },
            {
              'label': 'إجمالي الذمم',
              'value': moneyText(totalReceivables),
            },
          ],
        },
        {
          'id': 'fully_paid_pharmacies',
          'title': 'مسددة بالكامل',
          'value': count(18),
          'valueType': 'count',
          'iconKey': 'fully_paid',
          'subtitle': 'صيدليات لا يوجد عليها رصيد مستحق',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'الصيدليات المسددة بالكامل',
              'value': count(18).toString(),
            },
          ],
        },
        {
          'id': 'invoices_count',
          'title': 'عدد الفواتير',
          'value': count(142),
          'valueType': 'count',
          'iconKey': 'invoice',
          'subtitle': 'فواتير البيع خلال الفترة المحددة',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'عدد الفواتير',
              'value': count(142).toString(),
            },
            {
              'label': 'قيمة الفواتير',
              'value': moneyText(totalSales),
            },
          ],
        },
        {
          'id': 'collection_operations',
          'title': 'عمليات التحصيل',
          'value': count(20),
          'valueType': 'count',
          'iconKey': 'collection_operations',
          'subtitle': 'عدد عمليات التحصيل المعتمدة',
          'details': [
            {
              'label': 'النطاق',
              'value': regionName,
            },
            {
              'label': 'عدد عمليات التحصيل',
              'value': count(20).toString(),
            },
            {
              'label': 'إجمالي التحصيلات',
              'value': moneyText(totalCollections),
            },
          ],
        },
        {
          'id': 'average_collection',
          'title': 'متوسط التحصيل',
          'value': averageCollection,
          'valueType': 'currency',
          'iconKey': 'average',
          'subtitle': 'متوسط قيمة عملية التحصيل الواحدة',
          'details': [
            {
              'label': 'إجمالي التحصيلات',
              'value': moneyText(totalCollections),
            },
            {
              'label': 'عدد عمليات التحصيل',
              'value': count(20).toString(),
            },
            {
              'label': 'متوسط التحصيل',
              'value': moneyText(averageCollection),
            },
          ],
        },
        {
          'id': 'first_sale',
          'title': 'أول عملية بيع',
          'value': money(2850),
          'valueType': 'currency',
          'iconKey': 'first_sale',
          'subtitle': 'صيدلية الشفاء - ${formatDate(fromDate)}',
          'details': [
            {
              'label': 'رقم الفاتورة',
              'value': 'INV-1001',
            },
            {
              'label': 'الصيدلية',
              'value': 'صيدلية الشفاء',
            },
            {
              'label': 'المنطقة',
              'value': regionName,
            },
            {
              'label': 'تاريخ العملية',
              'value': formatDate(fromDate),
            },
            {
              'label': 'قيمة العملية',
              'value': moneyText(money(2850)),
            },
          ],
        },
        {
          'id': 'last_sale',
          'title': 'آخر عملية بيع',
          'value': money(4120),
          'valueType': 'currency',
          'iconKey': 'last_sale',
          'subtitle': 'صيدلية الدواء - ${formatDate(toDate)}',
          'details': [
            {
              'label': 'رقم الفاتورة',
              'value': 'INV-1142',
            },
            {
              'label': 'الصيدلية',
              'value': 'صيدلية الدواء',
            },
            {
              'label': 'المنطقة',
              'value': regionName,
            },
            {
              'label': 'تاريخ العملية',
              'value': formatDate(toDate),
            },
            {
              'label': 'قيمة العملية',
              'value': moneyText(money(4120)),
            },
          ],
        },
      ],
    },
  };
}