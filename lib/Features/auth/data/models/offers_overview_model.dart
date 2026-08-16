class OffersOverviewModel {
  final List<RepresentativeOfferModel> activeOffers;

  final List<PromotionalBasketModel>
      promotionalBaskets;

  const OffersOverviewModel({
    required this.activeOffers,
    required this.promotionalBaskets,
  });

  factory OffersOverviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final dynamic rawOffers =
        data['active_offers'] ??
            data['offers'] ??
            const [];

    final dynamic rawBaskets =
        data['promotional_baskets'] ??
            data['baskets'] ??
            data['promotion_baskets'] ??
            const [];

    return OffersOverviewModel(
      activeOffers:
          rawOffers is List
              ? rawOffers
                  .whereType<Map>()
                  .map(
                    (item) =>
                        RepresentativeOfferModel
                            .fromJson(
                      Map<String, dynamic>.from(
                        item,
                      ),
                    ),
                  )
                  .toList()
              : const [],

      promotionalBaskets:
          rawBaskets is List
              ? rawBaskets
                  .whereType<Map>()
                  .map(
                    (item) =>
                        PromotionalBasketModel
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
}

// =========================================================
// Active Offer
// =========================================================

class RepresentativeOfferModel {
  final String id;

  final String title;

  final String description;

  final String discountText;

  final String validFrom;

  final String validTo;

  const RepresentativeOfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.validFrom,
    required this.validTo,
  });

  factory RepresentativeOfferModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RepresentativeOfferModel(
      id:
          json['id']?.toString() ??
          json['offer_id']?.toString() ??
          '',

      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'عرض',

      description:
          json['description']?.toString() ??
          '',

      discountText:
          json['discount_text']?.toString() ??
          json['discount']?.toString() ??
          '',

      validFrom:
          json['valid_from']?.toString() ??
          json['start_date']?.toString() ??
          '',

      validTo:
          json['valid_to']?.toString() ??
          json['end_date']?.toString() ??
          '',
    );
  }
}

// =========================================================
// Promotional Basket
// =========================================================

class PromotionalBasketModel {
  final String id;

  final String title;

  final String description;

  final String discountText;

  final int productsCount;

  final String sentBy;

  const PromotionalBasketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.productsCount,
    required this.sentBy,
  });

  factory PromotionalBasketModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PromotionalBasketModel(
      id:
          json['id']?.toString() ??
          json['basket_id']?.toString() ??
          '',

      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'سلة ترويجية',

      description:
          json['description']?.toString() ??
          '',

      discountText:
          json['discount_text']?.toString() ??
          json['discount']?.toString() ??
          '',

      productsCount:
          _toInt(
        json['products_count'] ??
            json['items_count'] ??
            0,
      ),

      sentBy:
          json['sent_by']?.toString() ??
          json['supervisor_name']?.toString() ??
          'المشرف',
    );
  }

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}