class PromotionalBasketDetailsModel {
  final String id;
  final String title;
  final String description;

  /// حسم السلة نفسها.
  final String discountText;
  final double discountPercent;

  /// حسم إضافي على إجمالي الفاتورة إن كان محدداً من المشرف.
  final double invoiceDiscountPercent;

  final String sentBy;
  final String supervisorNotes;

  final String validFrom;
  final String validTo;

  /// إذا كانت السلة تسمح بدمج عرض الصنف الأساسي معها صراحةً.
  final bool combineWithBasicOffer;

  final List<PromotionalBasketItemModel> items;

  const PromotionalBasketDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.discountPercent,
    this.invoiceDiscountPercent = 0,
    required this.sentBy,
    this.supervisorNotes = '',
    required this.validFrom,
    required this.validTo,
    this.combineWithBasicOffer = false,
    required this.items,
  });

  List<PromotionalBasketItemModel> get paidItems =>
      items.where((item) => !item.isFree).toList();

  List<PromotionalBasketItemModel> get freeItems =>
      items.where((item) => item.isFree).toList();

  double get subtotal {
    return paidItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get totalDiscount {
    return paidItems.fold<double>(
      0,
      (sum, item) {
        final double itemSubtotal = item.price * item.quantity;
        return sum + (itemSubtotal * (item.discountPercent / 100));
      },
    );
  }

  double get finalTotal => subtotal - totalDiscount;

  int get totalPaidQuantity {
    return paidItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  int get totalFreeQuantity {
    return items.fold<int>(
      0,
      (sum, item) => sum + item.freeQuantity,
    );
  }

  int get totalQuantity => totalPaidQuantity + totalFreeQuantity;

  factory PromotionalBasketDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data = _toMap(json['data']) ?? json;
    final Map<String, dynamic> basket = _toMap(data['basket']) ?? data;

    final double basketDiscountPercent = _toDouble(
      basket['basket_discount_percent'] ??
          basket['discount_percent'] ??
          basket['discountPercent'] ??
          basket['basket_discount'] ??
          0,
    );

    final double invoiceDiscountPercent = _toDouble(
      basket['invoice_discount_percent'] ??
          basket['invoiceDiscountPercent'] ??
          basket['invoice_discount'] ??
          0,
    );

    final List<PromotionalBasketItemModel> parsedItems = [];

    final dynamic rawPaidItems = basket['paid_items'] ??
        basket['paidItems'] ??
        basket['items'] ??
        basket['products'] ??
        data['items'] ??
        const [];

    if (rawPaidItems is List) {
      parsedItems.addAll(
        rawPaidItems.whereType<Map>().map(
              (item) => PromotionalBasketItemModel.fromJson(
                Map<String, dynamic>.from(item),
                defaultDiscountPercent: basketDiscountPercent,
              ),
            ),
      );
    }

    final dynamic rawFreeItems = basket['free_items'] ??
        basket['freeItems'] ??
        data['free_items'] ??
        data['freeItems'] ??
        const [];

    if (rawFreeItems is List) {
      parsedItems.addAll(
        rawFreeItems.whereType<Map>().map(
              (item) => PromotionalBasketItemModel.fromJson(
                Map<String, dynamic>.from(item),
                defaultDiscountPercent: 0,
                forceFree: true,
              ),
            ),
      );
    }

    return PromotionalBasketDetailsModel(
      id: basket['id']?.toString() ??
          basket['basket_id']?.toString() ??
          '',
      title: basket['title']?.toString() ??
          basket['name']?.toString() ??
          'سلة ترويجية',
      description: basket['description']?.toString() ?? '',
      discountText: basket['discount_text']?.toString() ??
          basket['discountText']?.toString() ??
          basket['discount']?.toString() ??
          '',
      discountPercent: basketDiscountPercent,
      invoiceDiscountPercent: invoiceDiscountPercent,
      sentBy: basket['sent_by']?.toString() ??
          basket['supervisor_name']?.toString() ??
          basket['supervisorName']?.toString() ??
          'المشرف',
      supervisorNotes: basket['supervisor_notes']?.toString() ??
          basket['supervisorNotes']?.toString() ??
          basket['notes']?.toString() ??
          '',
      validFrom: basket['valid_from']?.toString() ??
          basket['start_date']?.toString() ??
          '',
      validTo: basket['valid_to']?.toString() ??
          basket['end_date']?.toString() ??
          '',
      combineWithBasicOffer: _toBool(
        basket['combine_with_basic_offer'] ??
            basket['combineWithBasicOffer'] ??
            basket['allow_basic_offer'] ??
            false,
      ),
      items: parsedItems,
    );
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

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String normalized = value?.toString().toLowerCase().trim() ?? '';
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
}

class PromotionalBasketItemModel {
  final int productId;
  final String productName;
  final String scientificName;

  final int companyId;
  final String companyName;

  /// سعر الوحدة المدفوعة. الصنف المجاني دائماً سعره 0.
  final double price;

  /// الكمية المدفوعة فقط.
  final int quantity;

  /// الكمية المجانية لهذا البند.
  final int freeQuantity;

  final double discountPercent;

  /// true عندما يكون هذا السطر صنفاً مجانياً مستقلاً داخل السلة.
  final bool isFree;

  final String image;

  const PromotionalBasketItemModel({
    required this.productId,
    required this.productName,
    required this.scientificName,
    required this.companyId,
    required this.companyName,
    required this.price,
    required this.quantity,
    this.freeQuantity = 0,
    required this.discountPercent,
    this.isFree = false,
    required this.image,
  });

  factory PromotionalBasketItemModel.fromJson(
    Map<String, dynamic> json, {
    required double defaultDiscountPercent,
    bool forceFree = false,
  }) {
    final bool explicitFree = forceFree ||
        _toBool(json['is_free'] ?? json['isFree'] ?? false);

    final int rawQuantity = _toInt(
      json['quantity'] ?? json['required_quantity'] ?? 0,
    );

    final int rawFreeQuantity = _toInt(
      json['free_quantity'] ??
          json['freeQuantity'] ??
          json['bonus_quantity'] ??
          json['bonusQuantity'] ??
          0,
    );

    final bool isFree = explicitFree ||
        (rawQuantity <= 0 && rawFreeQuantity > 0 && _toDouble(json['price']) == 0);

    final int freeQuantity = isFree
        ? (rawFreeQuantity > 0 ? rawFreeQuantity : (rawQuantity > 0 ? rawQuantity : 1))
        : rawFreeQuantity;

    return PromotionalBasketItemModel(
      productId: _toInt(
        json['product_id'] ?? json['productId'] ?? json['id'],
      ),
      productName: json['product_name']?.toString() ??
          json['productName']?.toString() ??
          json['name']?.toString() ??
          'صنف',
      scientificName: json['scientific_name']?.toString() ??
          json['scientificName']?.toString() ??
          '',
      companyId: _toInt(
        json['company_id'] ?? json['companyId'],
      ),
      companyName: json['company_name']?.toString() ??
          json['companyName']?.toString() ??
          json['company']?.toString() ??
          '',
      price: isFree ? 0 : _toDouble(json['price']),
      quantity: isFree
          ? 0
          : (rawQuantity > 0 ? rawQuantity : 1),
      freeQuantity: freeQuantity,
      discountPercent: isFree
          ? 0
          : _toDouble(
              json['discount_percent'] ??
                  json['discountPercent'] ??
                  defaultDiscountPercent,
            ),
      isFree: isFree,
      image: json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['imageUrl']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toCartItem({
    required String promotionalBasketId,
    required String promotionalBasketName,
  }) {
    return {
      'id': productId,
      'product_id': productId,
      'name': productName,
      'scientificName': scientificName,
      'companyId': companyId,
      'company': companyName,
      'price': isFree ? 0.0 : price,
      'quantity': isFree ? 0 : quantity,
      'freeQuantity': freeQuantity,
      'discountPercent': isFree ? 0.0 : discountPercent,
      'isFree': isFree,
      'image': image,
      'promotionBasketId': promotionalBasketId,
      'promotionBasketName': promotionalBasketName,
      'offerSource': 'سلة ترويجية: $promotionalBasketName',
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String normalized = value?.toString().toLowerCase().trim() ?? '';
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
}
