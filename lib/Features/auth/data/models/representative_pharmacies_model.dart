class RepresentativePharmacyModel {
  final String id;
  final String name;
  final String region;

  /// يُستخدم فقط للفلترة حسب آخر تعامل/بيع/تحديث متاح.
  /// لا يظهر ضمن بطاقة الصيدلية في UC-241.
  final DateTime? lastActivityAt;

  const RepresentativePharmacyModel({
    required this.id,
    required this.name,
    required this.region,
    this.lastActivityAt,
  });

  factory RepresentativePharmacyModel.fromJson(
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

    DateTime? readDate(
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = json[key];

        if (value == null) {
          continue;
        }

        if (value is DateTime) {
          return value;
        }

        final text = value.toString().trim();

        if (text.isEmpty) {
          continue;
        }

        final parsed =
            DateTime.tryParse(text);

        if (parsed != null) {
          return parsed;
        }
      }

      return null;
    }

    final name = readString(
      const [
        'name',
        'pharmacy_name',
        'pharmacyName',
      ],
    );

    final id = readString(
      const [
        'id',
        'pharmacy_id',
        'pharmacyId',
      ],
    );

    return RepresentativePharmacyModel(
      id: id.isNotEmpty ? id : name,
      name: name,
      region: readString(
        const [
          'region',
          'region_name',
          'regionName',
          'area',
          'area_name',
          'areaName',
        ],
        fallback: 'غير محدد',
      ),
      lastActivityAt: readDate(
        const [
          'last_activity_at',
          'lastActivityAt',
          'last_interaction_at',
          'lastInteractionAt',
          'last_sale_at',
          'lastSaleAt',
          'last_update_at',
          'lastUpdateAt',
          'updated_at',
          'updatedAt',
        ],
      ),
    );
  }
}

class RepresentativePharmaciesResponseModel {
  final List<RepresentativePharmacyModel> pharmacies;
  final String targetMonth;
  final double? totalTarget;
  final Map<String, double> regionTargets;

  const RepresentativePharmaciesResponseModel({
    required this.pharmacies,
    required this.targetMonth,
    required this.totalTarget,
    required this.regionTargets,
  });
}
