enum WarehouseStockFilter {
  lowStock,
  outOfStock,
}

extension WarehouseStockFilterX
    on WarehouseStockFilter {
  String get apiValue {
    switch (this) {
      case WarehouseStockFilter.lowStock:
        return 'low_stock';
      case WarehouseStockFilter.outOfStock:
        return 'out_of_stock';
    }
  }

  String get title {
    switch (this) {
      case WarehouseStockFilter.lowStock:
        return 'الأصناف القابلة للنفاد';
      case WarehouseStockFilter.outOfStock:
        return 'الأصناف غير المتوفرة';
    }
  }

  String get availabilityLabel {
    switch (this) {
      case WarehouseStockFilter.lowStock:
        return 'قابل للنفاد';
      case WarehouseStockFilter.outOfStock:
        return 'غير متوفر';
    }
  }
}

class WarehouseStockItemModel {
  final String id;
  final String tradeName;
  final String companyName;
  final String availabilityStatus;
  final String? expiryDate;
  final String expiryStatus;

  const WarehouseStockItemModel({
    required this.id,
    required this.tradeName,
    required this.companyName,
    required this.availabilityStatus,
    this.expiryDate,
    required this.expiryStatus,
  });

  factory WarehouseStockItemModel.fromJson(
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

    String? readNullableString(
      List<String> keys,
    ) {
      final value = readString(keys);
      return value.isEmpty ? null : value;
    }

    String normalizeAvailability(
      String value,
    ) {
      final normalized =
          value.trim().toLowerCase();

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

      if (normalized == 'غير متوفر' ||
          normalized == 'out_of_stock' ||
          normalized == 'out-of-stock' ||
          normalized == 'out of stock' ||
          normalized == 'unavailable' ||
          normalized == 'sold_out' ||
          normalized == 'sold out') {
        return 'غير متوفر';
      }

      if (normalized == 'متوفر' ||
          normalized == 'available' ||
          normalized == 'in_stock' ||
          normalized == 'in-stock' ||
          normalized == 'in stock') {
        return 'متوفر';
      }

      return value.trim().isEmpty
          ? 'غير محدد'
          : value.trim();
    }

    String normalizeExpiry(
      String value,
    ) {
      final normalized =
          value.trim().toLowerCase();

      if (normalized == 'صالح' ||
          normalized == 'valid' ||
          normalized == 'safe' ||
          normalized == 'not_expired' ||
          normalized == 'not expired') {
        return 'صالح';
      }

      if (normalized == 'قريب الانتهاء' ||
          normalized == 'near_expiry' ||
          normalized == 'near-expiry' ||
          normalized == 'near expiry' ||
          normalized == 'expiring_soon' ||
          normalized == 'expiring soon') {
        return 'قريب الانتهاء';
      }

      if (normalized == 'منتهي الصلاحية' ||
          normalized == 'منتهي' ||
          normalized == 'expired') {
        return 'منتهي الصلاحية';
      }

      return 'غير محدد';
    }

    return WarehouseStockItemModel(
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
          'medicine_name',
          'medicineName',
          'product_name',
          'productName',
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
      availabilityStatus:
          normalizeAvailability(
        readString(
          const [
            'availability_status',
            'availabilityStatus',
            'stock_status',
            'stockStatus',
            'status',
          ],
          fallback: 'غير محدد',
        ),
      ),
      expiryDate: readNullableString(
        const [
          'expiry_date',
          'expiryDate',
          'expiration_date',
          'expirationDate',
        ],
      ),
      expiryStatus: normalizeExpiry(
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
    );
  }
}
