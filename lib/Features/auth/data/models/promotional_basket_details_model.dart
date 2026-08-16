class PromotionalBasketDetailsModel {
  final String id;
  final String title;
  final String description;

  final String discountText;
  final double discountPercent;

  final String sentBy;

  final String validFrom;
  final String validTo;

  final List<PromotionalBasketItemModel> items;

  const PromotionalBasketDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.discountPercent,
    required this.sentBy,
    required this.validFrom,
    required this.validTo,
    required this.items,
  });

  // =========================================================
  // Totals
  // =========================================================

  double get subtotal {
    return items.fold<double>(
      0,
      (sum, item) =>
          sum + (item.price * item.quantity),
    );
  }

  double get totalDiscount {
    return items.fold<double>(
      0,
      (sum, item) {
        final double itemSubtotal =
            item.price * item.quantity;

        return sum +
            (itemSubtotal *
                (item.discountPercent / 100));
      },
    );
  }

  double get finalTotal {
    return subtotal - totalDiscount;
  }

  int get totalQuantity {
    return items.fold<int>(
      0,
      (sum, item) =>
          sum + item.quantity,
    );
  }

  // =========================================================
  // From Json
  // =========================================================

  factory PromotionalBasketDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> basket =
        _toMap(data['basket']) ?? data;

    final double discountPercent =
        _toDouble(
      basket['discount_percent'] ??
          basket['discountPercent'] ??
          0,
    );

    final dynamic rawItems =
        basket['items'] ??
            basket['products'] ??
            data['items'] ??
            const [];

    return PromotionalBasketDetailsModel(
      id:
          basket['id']?.toString() ??
              basket['basket_id']
                  ?.toString() ??
              '',

      title:
          basket['title']?.toString() ??
              basket['name']?.toString() ??
              'سلة ترويجية',

      description:
          basket['description']
                  ?.toString() ??
              '',

      discountText:
          basket['discount_text']
                  ?.toString() ??
              basket['discount']
                  ?.toString() ??
              '',

      discountPercent:
          discountPercent,

      sentBy:
          basket['sent_by']
                  ?.toString() ??
              basket['supervisor_name']
                  ?.toString() ??
              'المشرف',

      validFrom:
          basket['valid_from']
                  ?.toString() ??
              basket['start_date']
                  ?.toString() ??
              '',

      validTo:
          basket['valid_to']
                  ?.toString() ??
              basket['end_date']
                  ?.toString() ??
              '',

      items:
          rawItems is List
              ? rawItems
                  .whereType<Map>()
                  .map(
                    (item) =>
                        PromotionalBasketItemModel
                            .fromJson(
                      Map<String, dynamic>.from(
                        item,
                      ),

                      defaultDiscountPercent:
                          discountPercent,
                    ),
                  )
                  .toList()
              : const [],
    );
  }

  static Map<String, dynamic>? _toMap(
    dynamic value,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return null;
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

// =========================================================
// Promotional Basket Item
// =========================================================

class PromotionalBasketItemModel {
  final int productId;

  final String productName;

  final String scientificName;

  final int companyId;

  final String companyName;

  final double price;

  final int quantity;

  final double discountPercent;

  final String image;

  const PromotionalBasketItemModel({
    required this.productId,
    required this.productName,
    required this.scientificName,
    required this.companyId,
    required this.companyName,
    required this.price,
    required this.quantity,
    required this.discountPercent,
    required this.image,
  });

  factory PromotionalBasketItemModel.fromJson(
    Map<String, dynamic> json, {
    required double defaultDiscountPercent,
  }) {
    return PromotionalBasketItemModel(
      productId:
          _toInt(
        json['product_id'] ??
            json['productId'] ??
            json['id'],
      ),

      productName:
          json['product_name']
                  ?.toString() ??
              json['name']?.toString() ??
              'صنف',

      scientificName:
          json['scientific_name']
                  ?.toString() ??
              json['scientificName']
                  ?.toString() ??
              '',

      companyId:
          _toInt(
        json['company_id'] ??
            json['companyId'],
      ),

      companyName:
          json['company_name']
                  ?.toString() ??
              json['company']
                  ?.toString() ??
              '',

      price:
          _toDouble(
        json['price'],
      ),

      quantity:
          _toInt(
        json['quantity'] ??
            json['required_quantity'] ??
            1,
      ),

      discountPercent:
          _toDouble(
        json['discount_percent'] ??
            json['discountPercent'] ??
            defaultDiscountPercent,
      ),

      image:
          json['image']?.toString() ??
              '',
    );
  }

  static int _toInt(
    dynamic value,
  ) {
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

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}