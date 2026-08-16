class UsedOfferHistoryModel {
  final String historyId;

  final String offerId;

  final String offerName;

  /// offer / basket
  final String offerType;

  final String orderNumber;

  final String pharmacyName;

  final String usedAt;

  final String discountText;

  final double discountAmount;

  final String? promotionBasketId;

  const UsedOfferHistoryModel({
    required this.historyId,
    required this.offerId,
    required this.offerName,
    required this.offerType,
    required this.orderNumber,
    required this.pharmacyName,
    required this.usedAt,
    required this.discountText,
    required this.discountAmount,
    this.promotionBasketId,
  });

  bool get isBasket =>
      offerType.toLowerCase() == 'basket';

  factory UsedOfferHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UsedOfferHistoryModel(
      historyId:
          json['history_id']?.toString() ??
              json['id']?.toString() ??
              '',

      offerId:
          json['offer_id']?.toString() ??
              json['promotion_id']?.toString() ??
              '',

      offerName:
          json['offer_name']?.toString() ??
              json['title']?.toString() ??
              json['name']?.toString() ??
              'عرض',

      offerType:
          json['offer_type']?.toString() ??
              json['type']?.toString() ??
              'offer',

      orderNumber:
          json['order_number']?.toString() ??
              json['orderNumber']?.toString() ??
              '',

      pharmacyName:
          json['pharmacy_name']?.toString() ??
              json['pharmacyName']?.toString() ??
              '',

      usedAt:
          json['used_at']?.toString() ??
              json['date']?.toString() ??
              json['created_at']?.toString() ??
              '',

      discountText:
          json['discount_text']?.toString() ??
              json['discount']?.toString() ??
              '',

      discountAmount:
          _toDouble(
        json['discount_amount'] ??
            json['discountAmount'] ??
            json['saving_amount'] ??
            0,
      ),

      promotionBasketId:
          json['promotion_basket_id']
                  ?.toString() ??
              json['promotionBasketId']
                  ?.toString(),
    );
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