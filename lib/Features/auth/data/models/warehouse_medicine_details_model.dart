class WarehouseMedicineDetailsModel {
  final String id;
  final String tradeName;
  final String scientificName;
  final String companyName;
  final double? price;
  final String? offerText;
  final String? expiryDate;
  final String expiryStatus;
  final String availabilityStatus;

  const WarehouseMedicineDetailsModel({
    required this.id,
    required this.tradeName,
    required this.scientificName,
    required this.companyName,
    this.price,
    this.offerText,
    this.expiryDate,
    required this.expiryStatus,
    required this.availabilityStatus,
  });

  factory WarehouseMedicineDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(
      List<String> keys, {
      String fallback = '',
    }) {
      for (final key in keys) {
        final value = json[key];
        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
      return fallback;
    }

    double? readDouble(List<String> keys) {
      for (final key in keys) {
        final value = json[key];

        if (value is num) {
          return value.toDouble();
        }

        if (value is String) {
          final parsed =
              double.tryParse(value.trim());
          if (parsed != null) {
            return parsed;
          }
        }
      }

      return null;
    }

    String? readNullableString(
      List<String> keys,
    ) {
      final value = readString(keys);

      if (value.isEmpty) {
        return null;
      }

      return value;
    }
String normalizeAvailabilityStatus(
  String value,
) {
  final normalized =
      value.trim().toLowerCase();

  // غير متوفر
  if (normalized == 'غير متوفر' ||
      normalized == 'out_of_stock' ||
      normalized == 'out-of-stock' ||
      normalized == 'out of stock' ||
      normalized == 'unavailable' ||
      normalized == 'sold_out' ||
      normalized == 'sold out') {
    return 'غير متوفر';
  }

  // قابل للنفاد
  if (normalized == 'قابل للنفاد' ||
      normalized == 'low_stock' ||
      normalized == 'low-stock' ||
      normalized == 'low stock' ||
      normalized == 'running_low' ||
      normalized == 'running low' ||
      normalized == 'almost_out' ||
      normalized == 'almost out') {
    return 'قابل للنفاد';
  }

  // متوفر
  if (normalized == 'متوفر' ||
      normalized == 'available' ||
      normalized == 'in_stock' ||
      normalized == 'in-stock' ||
      normalized == 'in stock') {
    return 'متوفر';
  }

  // إذا الباك رجع قيمة غير معروفة،
  // ما منعرض أرقام أو قيمة غريبة للمندوب.
  return 'غير متوفر';
}
String normalizeExpiryStatus(
  String value,
) {
  final normalized =
      value.trim().toLowerCase();

  // صالح
  if (normalized == 'صالح' ||
      normalized == 'valid' ||
      normalized == 'safe' ||
      normalized == 'active' ||
      normalized == 'not_expired' ||
      normalized == 'not expired') {
    return 'صالح';
  }

  // قريب الانتهاء
  if (normalized == 'قريب الانتهاء' ||
      normalized == 'near_expiry' ||
      normalized == 'near-expiry' ||
      normalized == 'near expiry' ||
      normalized == 'expiring_soon' ||
      normalized == 'expiring soon' ||
      normalized == 'near_expiration') {
    return 'قريب الانتهاء';
  }

  // منتهي الصلاحية
  if (normalized == 'منتهي الصلاحية' ||
      normalized == 'منتهي' ||
      normalized == 'expired' ||
      normalized == 'expiry_expired' ||
      normalized == 'expiration_expired') {
    return 'منتهي الصلاحية';
  }

  // غير محدد
  return 'غير محدد';
}
    return WarehouseMedicineDetailsModel(
      id: readString(
        const [
          'id',
          'medicine_id',
          'medicineId',
          'product_id',
          'productId',
        ],
      ),
      tradeName: readString(
        const [
          'trade_name',
          'tradeName',
          'name',
          'product_name',
          'productName',
        ],
      ),
      scientificName: readString(
        const [
          'scientific_name',
          'scientificName',
          'generic_name',
          'genericName',
        ],
      ),
      companyName: readString(
        const [
          'company_name',
          'companyName',
          'company',
          'manufacturer',
        ],
      ),
      price: readDouble(
        const [
          'price',
          'sale_price',
          'salePrice',
          'unit_price',
          'unitPrice',
        ],
      ),
      offerText: readNullableString(
        const [
          'offer',
          'offer_text',
          'offerText',
          'promotion',
          'promotion_text',
          'promotionText',
        ],
      ),
      expiryDate: readNullableString(
        const [
          'expiry_date',
          'expiryDate',
          'expiration_date',
          'expirationDate',
        ],
      ),
      expiryStatus: normalizeExpiryStatus(
  readString(
    const [
      'expiry_status',
      'expiryStatus',
      'expiration_status',
      'expirationStatus',
    ],
    fallback: 'غير محدد',
  ),
),
      availabilityStatus:
    normalizeAvailabilityStatus(
  readString(
    const [
      'availability_status',
      'availabilityStatus',
      'stock_status',
      'stockStatus',
      'status',
    ],
    fallback: 'غير متوفر',
  ),
),
    );
  }
}
