import 'package:project_2/Features/auth/data/datasources/offers_data_source.dart';
import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';

import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';
import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';
import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

class MockOffersDataSource
    implements OffersDataSource {
  // =========================================================
  // UC-213
  // =========================================================

  @override
  Future<OffersOverviewModel>
      getRepresentativeOffers() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    return const OffersOverviewModel(
      activeOffers: [
        RepresentativeOfferModel(
          id:
              'offer-1',

          title:
              'عرض شراء 10 + 2 مجاناً',

          description:
              'عند شراء 10 قطع من الأصناف المشمولة يحصل العميل على قطعتين إضافيتين مجاناً.',

          discountText:
              '10 + 2 مجاناً',

          validFrom:
              '2026-08-01',

          validTo:
              '2026-08-31',
        ),

        RepresentativeOfferModel(
          id:
              'offer-2',

          title:
              'خصم على الأصناف المحددة',

          description:
              'حسم خاص على مجموعة من الأصناف الموجهة للمندوب خلال فترة العرض.',

          discountText:
              'خصم 15%',

          validFrom:
              '2026-08-10',

          validTo:
              '2026-08-25',
        ),
      ],

      promotionalBaskets: [
        PromotionalBasketModel(
          id:
              'basket-1',

          title:
              'سلة العناية بالأطفال',

          description:
              'سلة ترويجية جاهزة تحتوي على مجموعة أصناف مقترحة للبيع.',

          discountText:
              'حسم إجمالي 15%',

          productsCount:
              5,

          sentBy:
              'المشرف المباشر',
        ),

        PromotionalBasketModel(
          id:
              'basket-2',

          title:
              'سلة الإسعافات الأولية',

          description:
              'مجموعة أصناف مختارة من المشرف ضمن حملة المبيعات الحالية.',

          discountText:
              'حسم إجمالي 20%',

          productsCount:
              7,

          sentBy:
              'المشرف المباشر',
        ),
      ],
    );
  }

  // =========================================================
  // UC-214 -> UC-218
  // =========================================================

  @override
  Future<PromotionalBasketDetailsModel>
      getPromotionalBasketDetails({
    required String basketId,
  }) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    if (basketId == 'basket-1') {
      return const PromotionalBasketDetailsModel(
        id:
            'basket-1',

        title:
            'سلة العناية بالأطفال',

        description:
            'سلة ترويجية مجهزة من المشرف وتحتوي على مجموعة من أصناف العناية بالأطفال.',

        discountText:
            'حسم 15%',

        discountPercent:
            15,

        sentBy:
            'المشرف المباشر',

        validFrom:
            '2026-08-01',

        validTo:
            '2026-08-31',

        items: [
          PromotionalBasketItemModel(
            productId:
                101,

            productName:
                'شراب أطفال A',

            scientificName:
                'Paracetamol',

            companyId:
                1,

            companyName:
                'شركة الشفاء',

            price:
                8500,

            quantity:
                3,

            discountPercent:
                15,

            image:
                '',
          ),

          PromotionalBasketItemModel(
            productId:
                102,

            productName:
                'فيتامين أطفال',

            scientificName:
                'Multivitamin',

            companyId:
                1,

            companyName:
                'شركة الشفاء',

            price:
                12000,

            quantity:
                2,

            discountPercent:
                15,

            image:
                '',
          ),

          PromotionalBasketItemModel(
            productId:
                103,

            productName:
                'كريم أطفال',

            scientificName:
                'Baby Cream',

            companyId:
                2,

            companyName:
                'شركة الحياة',

            price:
                9500,

            quantity:
                2,

            discountPercent:
                15,

            image:
                '',
          ),

          PromotionalBasketItemModel(
            productId:
                104,

            productName:
                'قطرات أطفال',

            scientificName:
                'Vitamin D',

            companyId:
                2,

            companyName:
                'شركة الحياة',

            price:
                7000,

            quantity:
                4,

            discountPercent:
                15,

            image:
                '',
          ),

          PromotionalBasketItemModel(
            productId:
                105,

            productName:
                'محلول أنفي للأطفال',

            scientificName:
                'Saline Solution',

            companyId:
                3,

            companyName:
                'شركة الأمل',

            price:
                5500,

            quantity:
                3,

            discountPercent:
                15,

            image:
                '',
          ),
        ],
      );
    }

    if (basketId == 'basket-2') {
      return const PromotionalBasketDetailsModel(
        id:
            'basket-2',

        title:
            'سلة الإسعافات الأولية',

        description:
            'سلة ترويجية تحتوي على أصناف أساسية للإسعافات الأولية بخصم خاص.',

        discountText:
            'حسم 20%',

        discountPercent:
            20,

        sentBy:
            'المشرف المباشر',

        validFrom:
            '2026-08-05',

        validTo:
            '2026-08-31',

        items: [
          PromotionalBasketItemModel(
            productId: 201,
            productName: 'مطهر طبي',
            scientificName: 'Antiseptic',
            companyId: 4,
            companyName: 'شركة ميديكال',
            price: 6500,
            quantity: 3,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 202,
            productName: 'شاش طبي',
            scientificName: 'Medical Gauze',
            companyId: 4,
            companyName: 'شركة ميديكال',
            price: 4000,
            quantity: 5,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 203,
            productName: 'لاصق طبي',
            scientificName: 'Medical Tape',
            companyId: 4,
            companyName: 'شركة ميديكال',
            price: 3000,
            quantity: 4,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 204,
            productName: 'قطن طبي',
            scientificName: 'Medical Cotton',
            companyId: 5,
            companyName: 'شركة الصحة',
            price: 4500,
            quantity: 3,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 205,
            productName: 'ضماد طبي',
            scientificName: 'Bandage',
            companyId: 5,
            companyName: 'شركة الصحة',
            price: 5000,
            quantity: 4,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 206,
            productName: 'قفازات طبية',
            scientificName: 'Medical Gloves',
            companyId: 5,
            companyName: 'شركة الصحة',
            price: 8000,
            quantity: 2,
            discountPercent: 20,
            image: '',
          ),

          PromotionalBasketItemModel(
            productId: 207,
            productName: 'محلول معقم',
            scientificName: 'Disinfectant',
            companyId: 5,
            companyName: 'شركة الصحة',
            price: 7500,
            quantity: 2,
            discountPercent: 20,
            image: '',
          ),
        ],
      );
    }

    throw Exception(
      'السلة الترويجية غير موجودة',
    );
  }
  // =========================================================
// UC-220 -> UC-221
// Used Offers History
// =========================================================

@override
Future<List<UsedOfferHistoryModel>>
    getUsedOffersHistory() async {
  await Future<void>.delayed(
    const Duration(
      milliseconds: 500,
    ),
  );

  return const [
    UsedOfferHistoryModel(
      historyId: 'history-1',

      offerId: 'basket-1',

      offerName:
          'سلة العناية بالأطفال',

      offerType: 'basket',

      orderNumber:
          'ORD-202608-001',

      pharmacyName:
          'صيدلية الشفاء',

      usedAt:
          '2026-08-12',

      discountText:
          'حسم 15%',

      discountAmount:
          16875,

      promotionBasketId:
          'basket-1',
    ),

    UsedOfferHistoryModel(
      historyId: 'history-2',

      offerId: 'offer-2',

      offerName:
          'خصم على الأصناف المحددة',

      offerType: 'offer',

      orderNumber:
          'ORD-202608-002',

      pharmacyName:
          'صيدلية الحياة',

      usedAt:
          '2026-08-10',

      discountText:
          'خصم 15%',

      discountAmount:
          12500,
    ),

    UsedOfferHistoryModel(
      historyId: 'history-3',

      offerId: 'basket-2',

      offerName:
          'سلة الإسعافات الأولية',

      offerType: 'basket',

      orderNumber:
          'ORD-202608-003',

      pharmacyName:
          'صيدلية الأمل',

      usedAt:
          '2026-08-08',

      discountText:
          'حسم 20%',

      discountAmount:
          19500,

      promotionBasketId:
          'basket-2',
    ),

    UsedOfferHistoryModel(
      historyId: 'history-4',

      offerId: 'offer-1',

      offerName:
          'عرض شراء 10 + 2 مجاناً',

      offerType: 'offer',

      orderNumber:
          'ORD-202607-018',

      pharmacyName:
          'صيدلية النور',

      usedAt:
          '2026-07-28',

      discountText:
          '10 + 2 مجاناً',

      discountAmount:
          14000,
    ),

    UsedOfferHistoryModel(
      historyId: 'history-5',

      offerId: 'basket-1',

      offerName:
          'سلة العناية بالأطفال',

      offerType: 'basket',

      orderNumber:
          'ORD-202607-014',

      pharmacyName:
          'صيدلية السلام',

      usedAt:
          '2026-07-21',

      discountText:
          'حسم 15%',

      discountAmount:
          15100,

      promotionBasketId:
          'basket-1',
    ),
  ];
}
// =========================================================
// Active Offer Details
// =========================================================

@override
Future<ActiveOfferDetailsModel>
    getActiveOfferDetails({
  required String offerId,
}) async {
  await Future<void>.delayed(
    const Duration(
      milliseconds: 400,
    ),
  );

  // =======================================================
  // شراء 10 + 2 مجاني
  // =======================================================

  if (offerId == 'offer-1') {
    return const ActiveOfferDetailsModel(
      id: 'offer-1',

      title:
          'عرض شراء 10 + 2 مجاناً',

      description:
          'اشتري 10 قطع من أي صنف مشمول واحصل على قطعتين مجاناً.',

      offerType:
          'buy_x_get_y',

      discountText:
          '10 + 2 مجاناً',

      discountPercent:
          0,

      buyQuantity:
          10,

      freeQuantity:
          2,

      validFrom:
          '2026-08-01',

      validTo:
          '2026-08-31',

      products: [
        ActiveOfferProductModel(
          productId: 301,
          productName:
              'باراسيتامول 500',

          companyId: 1,
          companyName:
              'شركة الشفاء',

          price: 5000,

          minimumQuantity: 10,
        ),

        ActiveOfferProductModel(
          productId: 302,
          productName:
              'إيبوبروفين 400',

          companyId: 2,
          companyName:
              'شركة الحياة',

          price: 6500,

          minimumQuantity: 10,
        ),
      ],
    );
  }

  // =======================================================
  // خصم 15%
  // =======================================================

  if (offerId == 'offer-2') {
    return const ActiveOfferDetailsModel(
      id: 'offer-2',

      title:
          'خصم على الأصناف المحددة',

      description:
          'خصم 15% على الأصناف المشمولة ضمن هذا العرض.',

      offerType:
          'percentage_discount',

      discountText:
          'خصم 15%',

      discountPercent:
          15,

      buyQuantity:
          0,

      freeQuantity:
          0,

      validFrom:
          '2026-08-10',

      validTo:
          '2026-08-25',

      products: [
        ActiveOfferProductModel(
          productId: 401,
          productName:
              'فيتامين C',

          companyId: 3,
          companyName:
              'شركة الأمل',

          price: 10000,

          minimumQuantity: 1,
        ),

        ActiveOfferProductModel(
          productId: 402,
          productName:
              'زنك 25mg',

          companyId: 3,
          companyName:
              'شركة الأمل',

          price: 9000,

          minimumQuantity: 1,
        ),
      ],
    );
  }

  // العرض الثالث إذا ضفناه بـUC-213
  if (offerId == 'offer-3') {
    return const ActiveOfferDetailsModel(
      id: 'offer-3',

      title:
          'عرض الكمية الشهرية',

      description:
          'خصم 8% على الأصناف المشمولة بالعرض.',

      offerType:
          'percentage_discount',

      discountText:
          'خصم 8%',

      discountPercent:
          8,

      buyQuantity:
          0,

      freeQuantity:
          0,

      validFrom:
          '2026-08-01',

      validTo:
          '2026-08-31',

      products: [
        ActiveOfferProductModel(
          productId: 501,
          productName:
              'مكمل غذائي',

          companyId: 4,
          companyName:
              'شركة ميديكال',

          price: 15000,

          minimumQuantity: 3,
        ),
      ],
    );
  }

  throw Exception(
    'العرض غير موجود',
  );
}
}