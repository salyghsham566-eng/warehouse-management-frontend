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

bool cartValueToBool(
  dynamic value,
) {
  if (value is bool) {
    return value;
  }

  final String normalized =
      value?.toString().trim().toLowerCase() ?? '';

  return normalized == 'true' ||
      normalized == '1' ||
      normalized == 'yes';
}

// =========================================================
// هل البند مجاني بالكامل؟
// =========================================================

bool isCurrentOrderFreeOnlyItem(
  Map<String, dynamic> item,
) {
  if (cartValueToBool(
    item['isFree'] ?? item['is_free'],
  )) {
    return true;
  }

  final int paidQuantity = cartValueToInt(
    item['quantity'] ?? item['paidQuantity'],
  );

  final int freeQuantity = cartValueToInt(
    item['freeQuantity'] ?? item['free_quantity'],
  );

  final double price = cartValueToDouble(
    item['price'],
  );

  return paidQuantity <= 0 &&
      freeQuantity > 0 &&
      price <= 0;
}

// =========================================================
// مصدر الصنف
// =========================================================

String getCurrentOrderItemSource(
  Map<String, dynamic> item,
) {
  final String existing =
      item['cartSource']?.toString().trim() ?? '';

  if (existing.isNotEmpty) {
    return existing;
  }

  final String basketId =
      item['promotionBasketId']?.toString().trim() ??
          item['promotion_basket_id']?.toString().trim() ??
          '';

  if (basketId.isNotEmpty) {
    return 'promotionalBasket';
  }

  final String offerId =
      item['offerId']?.toString().trim() ??
          item['offer_id']?.toString().trim() ??
          '';

  if (offerId.isNotEmpty) {
    return 'offer';
  }

  return 'normal';
}

// =========================================================
// Cart Key
//
// الشركة + المنتج + المصدر + العرض + السلة + نوع البند
//
// نوع البند مهم حتى لا يندمج صنف مدفوع مع نفس الصنف إذا كان
// موجوداً أيضاً كسطر مجاني ضمن نفس السلة.
// =========================================================

String buildCurrentOrderCartKey(
  Map<String, dynamic> item,
) {
  final String companyId =
      (item['companyId'] ?? item['company_id'] ?? '-')
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
      item['offerId']?.toString().trim() ??
          item['offer_id']?.toString().trim() ??
          '';

  final String basketId =
      item['promotionBasketId']?.toString().trim() ??
          item['promotion_basket_id']?.toString().trim() ??
          '';

  final String lineType =
      isCurrentOrderFreeOnlyItem(item) ? 'free' : 'paid';

  return '$companyId|$productId|$source|'
      '${offerId.isEmpty ? '-' : offerId}|'
      '${basketId.isEmpty ? '-' : basketId}|'
      '$lineType';
}

// =========================================================
// Free Quantity
// =========================================================

int getCurrentOrderFreeQuantity(
  Map<String, dynamic> item,
) {
  final dynamic rawOffer = item['basicOffer'];

  // السلال الترويجية أو أي بند يحمل كمية مجانية صريحة.
  if (rawOffer is! Map) {
    return cartValueToInt(
      item['freeQuantity'] ?? item['free_quantity'],
    );
  }

  final int buyQuantity =
      cartValueToInt(
    rawOffer['buyQuantity'] ?? rawOffer['buy_quantity'],
  );

  final int freeQuantity =
      cartValueToInt(
    rawOffer['freeQuantity'] ?? rawOffer['free_quantity'],
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

  final int offersCount = quantity ~/ buyQuantity;

  return offersCount * freeQuantity;
}

// =========================================================
// Normalize
// =========================================================

Map<String, dynamic>
    normalizeCurrentOrderCartItem(
  Map<String, dynamic> item,
) {
  final result = Map<String, dynamic>.from(item);

  final bool freeOnly =
      isCurrentOrderFreeOnlyItem(result);

  int quantity = cartValueToInt(
    result['quantity'],
  );

  if (freeOnly) {
    quantity = 0;
  } else if (quantity <= 0) {
    quantity = 1;
  }

  result['quantity'] = quantity;
  result['isFree'] = freeOnly;

  final String source =
      getCurrentOrderItemSource(
    result,
  );

  result['cartSource'] = source;

  final int freeQuantity =
      getCurrentOrderFreeQuantity(
    result,
  );

  result['freeQuantity'] = freeQuantity;
  result['totalQuantity'] = quantity + freeQuantity;

  final String existingOfferSource =
      result['offerSource']?.toString().trim() ?? '';

  if (existingOfferSource.isEmpty) {
    final String basketId =
        result['promotionBasketId']?.toString().trim() ??
            result['promotion_basket_id']?.toString().trim() ??
            '';

    final String offerId =
        result['offerId']?.toString().trim() ??
            result['offer_id']?.toString().trim() ??
            '';

    if (basketId.isNotEmpty) {
      result['offerSource'] = 'سلة ترويجية';
    } else if (offerId.isNotEmpty) {
      result['offerSource'] = 'عرض ترويجي';
    } else if (freeQuantity > 0) {
      result['offerSource'] = 'عرض صنف أساسي';
    }
  }

  result['cartKey'] =
      buildCurrentOrderCartKey(
    result,
  );

  return result;
}
