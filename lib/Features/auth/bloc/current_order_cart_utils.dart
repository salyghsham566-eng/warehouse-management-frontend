int cartValueToInt(
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

double cartValueToDouble(
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

// =========================================================
// مصدر الصنف
// =========================================================

String getCurrentOrderItemSource(
  Map<String, dynamic> item,
) {
  final String existing =
      item['cartSource']
              ?.toString()
              .trim() ??
          '';

  if (existing.isNotEmpty) {
    return existing;
  }

  final String basketId =
      item['promotionBasketId']
              ?.toString()
              .trim() ??
          item['promotion_basket_id']
                  ?.toString()
                  .trim() ??
              '';

  if (basketId.isNotEmpty) {
    return 'promotionalBasket';
  }

  final String offerId =
      item['offerId']
              ?.toString()
              .trim() ??
          item['offer_id']
                  ?.toString()
                  .trim() ??
              '';

  if (offerId.isNotEmpty) {
    return 'offer';
  }

  return 'normal';
}

// =========================================================
// Cart Key
//
// الشركة + المنتج + المصدر + العرض + السلة
//
// نفس الدواء عادي ومن عرض يبقوا سطرين مختلفين.
// =========================================================

String buildCurrentOrderCartKey(
  Map<String, dynamic> item,
) {
  final String companyId =
      (item['companyId'] ??
              item['company_id'] ??
              '-')
          .toString();

  final String productId =
      (item['product_id'] ??
              item['productId'] ??
              item['id'] ??
              item['medicineId'] ??
              item['name'] ??
              '')
          .toString();

  final String source =
      getCurrentOrderItemSource(
    item,
  );

  final String offerId =
      item['offerId']
              ?.toString()
              .trim() ??
          item['offer_id']
                  ?.toString()
                  .trim() ??
              '';

  final String basketId =
      item['promotionBasketId']
              ?.toString()
              .trim() ??
          item['promotion_basket_id']
                  ?.toString()
                  .trim() ??
              '';

  return '$companyId|$productId|$source|'
      '${offerId.isEmpty ? '-' : offerId}|'
      '${basketId.isEmpty ? '-' : basketId}';
}

// =========================================================
// Free Quantity
// =========================================================

int getCurrentOrderFreeQuantity(
  Map<String, dynamic> item,
) {
  final dynamic rawOffer =
      item['basicOffer'];

  if (rawOffer is! Map) {
    return cartValueToInt(
      item['freeQuantity'],
    );
  }

  final int buyQuantity =
      cartValueToInt(
    rawOffer['buyQuantity'],
  );

  final int freeQuantity =
      cartValueToInt(
    rawOffer['freeQuantity'],
  );

  final int quantity =
      cartValueToInt(
    item['quantity'],
  );

  if (buyQuantity <= 0 ||
      freeQuantity <= 0 ||
      quantity <= 0) {
    return 0;
  }

  final int offersCount =
      quantity ~/ buyQuantity;

  return offersCount *
      freeQuantity;
}

// =========================================================
// Normalize
// =========================================================

Map<String, dynamic>
    normalizeCurrentOrderCartItem(
  Map<String, dynamic> item,
) {
  final result =
      Map<String, dynamic>.from(
    item,
  );

  int quantity =
      cartValueToInt(
    result['quantity'],
  );

  if (quantity <= 0) {
    quantity = 1;
  }

  result['quantity'] =
      quantity;

  final String source =
      getCurrentOrderItemSource(
    result,
  );

  result['cartSource'] =
      source;

  final String cartKey =
      buildCurrentOrderCartKey(
    result,
  );

  result['cartKey'] =
      cartKey;

  final int freeQuantity =
      getCurrentOrderFreeQuantity(
    result,
  );

  result['freeQuantity'] =
      freeQuantity;

  result['totalQuantity'] =
      quantity + freeQuantity;

  final String existingOfferSource =
      result['offerSource']
              ?.toString()
              .trim() ??
          '';

  if (existingOfferSource.isEmpty &&
      freeQuantity > 0) {
    result['offerSource'] =
        'عرض صنف أساسي';
  }

  return result;
}