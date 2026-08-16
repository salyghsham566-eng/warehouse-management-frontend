class ActiveOfferDetailsModel {
  final String id;
  final String title;
  final String description;

  /// buy_x_get_y / percentage_discount
  final String offerType;

  final String discountText;
  final double discountPercent;

  final int buyQuantity;
  final int freeQuantity;

  final String validFrom;
  final String validTo;

  final List<ActiveOfferProductModel> products;

  const ActiveOfferDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.offerType,
    required this.discountText,
    required this.discountPercent,
    required this.buyQuantity,
    required this.freeQuantity,
    required this.validFrom,
    required this.validTo,
    required this.products,
  });

  bool get isBuyGetFree =>
      offerType == 'buy_x_get_y';

  bool get isPercentageDiscount =>
      offerType == 'percentage_discount';

  factory ActiveOfferDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic rawData = json['data'];

    final Map<String, dynamic> data =
        rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : json;

    final dynamic rawProducts =
        data['products'] ??
            data['items'] ??
            const [];

    return ActiveOfferDetailsModel(
      id:
          data['id']?.toString() ??
          data['offer_id']?.toString() ??
          '',

      title:
          data['title']?.toString() ??
          data['name']?.toString() ??
          'عرض',

      description:
          data['description']?.toString() ??
          '',

      offerType:
          data['offer_type']?.toString() ??
          data['type']?.toString() ??
          'percentage_discount',

      discountText:
          data['discount_text']?.toString() ??
          data['discount']?.toString() ??
          '',

      discountPercent:
          _toDouble(
        data['discount_percent'] ?? 0,
      ),

      buyQuantity:
          _toInt(
        data['buy_quantity'] ?? 0,
      ),

      freeQuantity:
          _toInt(
        data['free_quantity'] ?? 0,
      ),

      validFrom:
          data['valid_from']?.toString() ??
          data['start_date']?.toString() ??
          '',

      validTo:
          data['valid_to']?.toString() ??
          data['end_date']?.toString() ??
          '',

      products:
          rawProducts is List
              ? rawProducts
                  .whereType<Map>()
                  .map(
                    (item) =>
                        ActiveOfferProductModel
                            .fromJson(
                      Map<String, dynamic>.from(
                        item,
                      ),
                    ),
                  )
                  .toList()
              : const [],
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

class ActiveOfferProductModel {
  final int productId;
  final String productName;

  final int companyId;
  final String companyName;

  final double price;

  final int minimumQuantity;

  const ActiveOfferProductModel({
    required this.productId,
    required this.productName,
    required this.companyId,
    required this.companyName,
    required this.price,
    required this.minimumQuantity,
  });

  factory ActiveOfferProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActiveOfferProductModel(
      productId:
          _toInt(
        json['product_id'] ??
            json['id'],
      ),

      productName:
          json['product_name']?.toString() ??
          json['name']?.toString() ??
          'صنف',

      companyId:
          _toInt(
        json['company_id'],
      ),

      companyName:
          json['company_name']?.toString() ??
          json['company']?.toString() ??
          '',

      price:
          _toDouble(
        json['price'],
      ),

      minimumQuantity:
          _toInt(
        json['minimum_quantity'] ??
            json['min_quantity'] ??
            1,
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}