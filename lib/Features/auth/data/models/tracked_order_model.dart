class TrackedOrderModel {
  final int? id;
  final String orderNumber;
  final String pharmacyName;
  final String status;
  final DateTime createdAt;
  final int itemsCount;
  final double total;

  const TrackedOrderModel({
    this.id,
    required this.orderNumber,
    required this.pharmacyName,
    required this.status,
    required this.createdAt,
    required this.itemsCount,
    required this.total,
  });

  factory TrackedOrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic pharmacyData = json['pharmacy'];

    String pharmacyName = '';

    if (pharmacyData is Map) {
      pharmacyName =
          pharmacyData['name']?.toString() ?? '';
    }

    return TrackedOrderModel(
      id: _parseNullableInt(json['id']),
      orderNumber:
          (json['order_number'] ??
                  json['orderNumber'] ??
                  json['id'])
              ?.toString() ??
          '',
      pharmacyName:
          (json['pharmacy_name'] ??
                  json['pharmacyName'])
              ?.toString() ??
          pharmacyName,
      status:
          json['status']?.toString() ??
          'pending_review',
      createdAt: _parseDate(
        json['created_at'] ?? json['createdAt'],
      ),
      itemsCount: _parseInt(
        json['items_count'] ??
            json['itemsCount'] ??
            _getItemsLength(json['items']),
      ),
      total: _parseDouble(
        json['total'] ?? json['total_amount'],
      ),
    );
  }

  /// الشكل الذي تفهمه الواجهة الحالية.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'pharmacyName': pharmacyName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'itemsCount': itemsCount,
      'total': total,
    };
  }
}

int _getItemsLength(dynamic items) {
  return items is List ? items.length : 0;
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  return _parseInt(value);
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.now();
}