class OrderDetailsModel {
  final int? id;
  final String orderNumber;
  final String pharmacyName;
  final String status;
  final DateTime createdAt;

  final int itemsCount;
  final double subtotal;
  final double discount;
  final double total;

  final String delegateNote;
  final String billerNote;
  final String rejectionReason;

  final List<OrderDetailsItemModel> items;
  final List<OrderDetailsItemModel> modifiedItems;

  const OrderDetailsModel({
    this.id,
    required this.orderNumber,
    required this.pharmacyName,
    required this.status,
    required this.createdAt,
    required this.itemsCount,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.delegateNote,
    required this.billerNote,
    required this.rejectionReason,
    required this.items,
    required this.modifiedItems,
  });

  factory OrderDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<OrderDetailsItemModel> parsedItems =
        _parseItems(json['items']);

    final List<OrderDetailsItemModel> parsedModifiedItems =
        _parseItems(
      json['modified_items'] ?? json['modifiedItems'],
    );

    final dynamic pharmacyData = json['pharmacy'];

    String pharmacyName =
        (json['pharmacy_name'] ?? json['pharmacyName'])
                ?.toString() ??
            '';

    if (pharmacyName.isEmpty && pharmacyData is Map) {
      pharmacyName =
          pharmacyData['name']?.toString() ?? '';
    }

    final List<OrderDetailsItemModel> finalModifiedItems =
        parsedModifiedItems.isNotEmpty
            ? parsedModifiedItems
            : parsedItems.where((item) {
                return item.originalQuantity != null ||
                    item.modifiedQuantity != null;
              }).toList();

    final double total = _parseDouble(
      json['total'] ?? json['total_amount'],
    );

    return OrderDetailsModel(
      id: _parseNullableInt(json['id']),
      orderNumber:
          (json['order_number'] ??
                  json['orderNumber'] ??
                  json['order_no'] ??
                  json['orderNo'] ??
                  json['id'])
              ?.toString() ??
          '',
      pharmacyName: pharmacyName.isEmpty
          ? 'صيدلية غير محددة'
          : pharmacyName,
      status:
          json['status']?.toString() ??
          'pending_review',
      createdAt: _parseDate(
        json['created_at'] ?? json['createdAt'],
      ),
      itemsCount: _parseInt(
        json['items_count'] ??
            json['itemsCount'] ??
            parsedItems.length,
      ),
      subtotal: _parseDouble(
        json['subtotal'] ?? total,
      ),
      discount: _parseDouble(
        json['discount'] ??
            json['discount_amount'] ??
            json['discountAmount'],
      ),
      total: total,
      delegateNote:
          (json['note'] ??
                  json['delegate_note'] ??
                  json['delegateNote'] ??
                  json['sales_rep_note'] ??
                  json['salesRepNote'])
              ?.toString() ??
          '',
      billerNote:
          (json['biller_note'] ??
                  json['billerNote'] ??
                  json['invoice_note'] ??
                  json['invoiceNote'] ??
                  json['accountant_note'] ??
                  json['accountantNote'] ??
                  json['reviewer_note'] ??
                  json['reviewerNote'])
              ?.toString() ??
          '',
      rejectionReason:
          (json['rejection_reason'] ??
                  json['rejectionReason'] ??
                  json['reject_reason'] ??
                  json['reason'])
              ?.toString() ??
          '',
      items: parsedItems,
      modifiedItems: finalModifiedItems,
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
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'note': delegateNote,
      'billerNote': billerNote,
      'rejectionReason': rejectionReason,
      'items': items
          .map((item) => item.toMap())
          .toList(),
      'modifiedItems': modifiedItems
          .map((item) => item.toMap())
          .toList(),
    };
  }
}

class OrderDetailsItemModel {
  final int? productId;
  final String medicineName;
  final String companyName;

  final int quantity;
  final int freeQuantity;

  final double price;
  final double discountPercent;
  final double itemTotal;

  final String offerSource;

  final int? originalQuantity;
  final int? modifiedQuantity;

  const OrderDetailsItemModel({
    this.productId,
    required this.medicineName,
    required this.companyName,
    required this.quantity,
    required this.freeQuantity,
    required this.price,
    required this.discountPercent,
    required this.itemTotal,
    required this.offerSource,
    this.originalQuantity,
    this.modifiedQuantity,
  });

  factory OrderDetailsItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic productData = json['product'];
    final dynamic companyData =
        json['company'];

    String medicineName =
        (json['medicine_name'] ??
                json['medicineName'] ??
                json['product_name'] ??
                json['productName'] ??
                json['name'])
            ?.toString() ??
        '';

    if (medicineName.isEmpty &&
        productData is Map) {
      medicineName =
          productData['name']?.toString() ?? '';
    }

    String companyName =
        (json['company_name'] ??
                json['companyName'])
            ?.toString() ??
        '';

    if (companyName.isEmpty) {
      if (companyData is Map) {
        companyName =
            companyData['name']?.toString() ?? '';
      } else if (companyData != null) {
        companyName = companyData.toString();
      }
    }

    if (companyName.isEmpty &&
        productData is Map) {
      final dynamic productCompany =
          productData['company'];

      if (productCompany is Map) {
        companyName =
            productCompany['name']?.toString() ??
                '';
      }
    }

    final int quantity = _parseInt(
      json['quantity'],
    );

    final double price = _parseDouble(
      json['price'],
    );

    return OrderDetailsItemModel(
      productId: _parseNullableInt(
        json['product_id'] ??
            json['productId'] ??
            json['id'],
      ),
      medicineName: medicineName.isEmpty
          ? 'دواء'
          : medicineName,
      companyName: companyName.isEmpty
          ? 'شركة غير محددة'
          : companyName,
      quantity: quantity,
      freeQuantity: _parseInt(
        json['free_quantity'] ??
            json['freeQuantity'],
      ),
      price: price,
      discountPercent: _parseDouble(
        json['discount_percent'] ??
            json['discountPercent'],
      ),
      itemTotal: _parseDouble(
        json['item_total'] ??
            json['itemTotal'] ??
            json['total'] ??
            (price * quantity),
      ),
      offerSource:
          (json['offer_source'] ??
                  json['offerSource'])
              ?.toString() ??
          'لا يوجد عرض',
      originalQuantity: _parseNullableInt(
        json['original_quantity'] ??
            json['originalQuantity'],
      ),
      modifiedQuantity: _parseNullableInt(
        json['modified_quantity'] ??
            json['modifiedQuantity'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'medicineName': medicineName,
      'companyName': companyName,
      'quantity': quantity,
      'freeQuantity': freeQuantity,
      'price': price,
      'discountPercent': discountPercent,
      'itemTotal': itemTotal,
      'offerSource': offerSource,
      'originalQuantity': originalQuantity,
      'modifiedQuantity': modifiedQuantity,
    };
  }
}

List<OrderDetailsItemModel> _parseItems(
  dynamic data,
) {
  if (data is! List) {
    return [];
  }

  return data
      .whereType<Map>()
      .map(
        (item) =>
            OrderDetailsItemModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
      .toList();
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  final int? result = int.tryParse(
    value.toString(),
  );

  return result;
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(
        value?.toString() ?? '',
      ) ??
      DateTime.now();
}