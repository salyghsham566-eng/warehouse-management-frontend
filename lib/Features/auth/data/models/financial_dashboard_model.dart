class FinancialDashboardModel {
  final String scopeId;
  final String scopeName;
  final DateTime fromDate;
  final DateTime toDate;
  final List<FinancialRegionModel> regions;
  final List<FinancialMetricModel> metrics;

  const FinancialDashboardModel({
    required this.scopeId,
    required this.scopeName,
    required this.fromDate,
    required this.toDate,
    required this.regions,
    required this.metrics,
  });
 bool get isAllRegions => scopeId == 'all';

  bool get isSpecificRegion => scopeId != 'all';
  factory FinancialDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = _toMap(json['data']) ?? json;
    final scope = _toMap(data['scope']) ?? <String, dynamic>{};
    final period = _toMap(data['period']) ?? <String, dynamic>{};

    final regionsJson = data['regions'];
    final metricsJson = data['metrics'];

    return FinancialDashboardModel(
      scopeId: scope['id']?.toString() ?? 'all',
      scopeName: scope['name']?.toString() ?? 'جميع المناطق',
      fromDate: _parseDate(period['from']),
      toDate: _parseDate(period['to']),
      regions: regionsJson is List
          ? regionsJson
              .whereType<Map>()
              .map(
                (item) => FinancialRegionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      metrics: metricsJson is List
          ? metricsJson
              .whereType<Map>()
              .map(
                (item) => FinancialMetricModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }

  FinancialMetricModel? metricById(String id) {
    for (final metric in metrics) {
      if (metric.id == id) {
        return metric;
      }
    }

    return null;
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
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }
}

class FinancialRegionModel {
  final String id;
  final String name;

  const FinancialRegionModel({
    required this.id,
    required this.name,
  });

  factory FinancialRegionModel.fromJson(Map<String, dynamic> json) {
    return FinancialRegionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class FinancialMetricModel {
  final String id;
  final String title;
  final double value;
  final String valueType;
  final String iconKey;
  final String? subtitle;
  final List<FinancialDetailItemModel> details;

  const FinancialMetricModel({
    required this.id,
    required this.title,
    required this.value,
    required this.valueType,
    required this.iconKey,
    required this.details,
    this.subtitle,
  });

  factory FinancialMetricModel.fromJson(Map<String, dynamic> json) {
    final detailsJson = json['details'];

    return FinancialMetricModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      valueType: json['valueType']?.toString() ?? 'count',
      iconKey: json['iconKey']?.toString() ?? 'info',
      subtitle: json['subtitle']?.toString(),
      details: detailsJson is List
          ? detailsJson
              .whereType<Map>()
              .map(
                (item) => FinancialDetailItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }

  bool get isCurrency => valueType == 'currency';

  bool get isCount => valueType == 'count';

  String get formattedValue {
    if (isCount) {
      return _addThousandsSeparator(value.toInt().toString());
    }

    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = _addThousandsSeparator(parts.first);
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    return '$integerPart.$decimalPart ر.س';
  }

  static String _addThousandsSeparator(String value) {
    return value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }
}

class FinancialDetailItemModel {
  final String label;
  final String value;

  const FinancialDetailItemModel({
    required this.label,
    required this.value,
  });

  factory FinancialDetailItemModel.fromJson(Map<String, dynamic> json) {
    return FinancialDetailItemModel(
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}