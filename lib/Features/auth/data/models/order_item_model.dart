class OrderItemModel {
  final int productId;

  final int quantity;

  final double price;

  final double discountPercent;

  final String? offerSource;

  final String? offerId;

  final String? promotionBasketId;

  const OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
    this.discountPercent = 0,
    this.offerSource,
    this.offerId,
    this.promotionBasketId,
  });

  factory OrderItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderItemModel(
      productId:
          _parseInt(
        json['product_id'] ??
            json['productId'],
      ),

      quantity:
          _parseInt(
        json['quantity'],
      ),

      price:
          _parseDouble(
        json['price'],
      ),

      discountPercent:
          _parseDouble(
        json['discount_percent'] ??
            json['discountPercent'] ??
            0,
      ),

      offerSource:
          json['offer_source']
                  ?.toString() ??
              json['offerSource']
                  ?.toString(),

      offerId:
          json['offer_id']
                  ?.toString() ??
              json['offerId']
                  ?.toString(),

      promotionBasketId:
          json['promotion_basket_id']
                  ?.toString() ??
              json['promotionBasketId']
                  ?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id':
          productId,

      'quantity':
          quantity,

      'price':
          price,

      if (discountPercent > 0)
        'discount_percent':
            discountPercent,

      if (offerSource != null &&
          offerSource!
              .trim()
              .isNotEmpty)
        'offer_source':
            offerSource,

      if (offerId != null &&
          offerId!
              .trim()
              .isNotEmpty)
        'offer_id':
            offerId,

      if (promotionBasketId != null &&
          promotionBasketId!
              .trim()
              .isNotEmpty)
        'promotion_basket_id':
            promotionBasketId,
    };
  }
}

int _parseInt(
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

double _parseDouble(
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