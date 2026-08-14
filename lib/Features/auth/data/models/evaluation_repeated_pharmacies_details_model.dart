class EvaluationRepeatedPharmaciesDetailsModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final int repeatedCount;
  final int totalSoldPharmacies;

  final double percentage;

  final double score;
  final double maxScore;

  final List<EvaluationRepeatedPharmacyModel> pharmacies;

  const EvaluationRepeatedPharmaciesDetailsModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.repeatedCount,
    required this.totalSoldPharmacies,
    required this.percentage,
    required this.score,
    required this.maxScore,
    required this.pharmacies,
  });

  factory EvaluationRepeatedPharmaciesDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> period =
        _toMap(data['period']) ?? {};

    final Map<String, dynamic> scope =
        _toMap(data['scope']) ?? {};

    final Map<String, dynamic> repeated =
        _toMap(data['repeated']) ?? {};

    final dynamic rawPharmacies =
        data['pharmacies'];

    final pharmacies =
        rawPharmacies is List
            ? rawPharmacies
                .whereType<Map>()
                .map(
                  (item) =>
                      EvaluationRepeatedPharmacyModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
            : <EvaluationRepeatedPharmacyModel>[];

    final int repeatedCount =
        _toInt(
      repeated['repeated_count'] ??
          pharmacies.length,
    );

    final int totalSoldPharmacies =
        _toInt(
      repeated['total_sold_pharmacies'] ??
          repeatedCount,
    );

    final double percentage =
        _toDouble(
      repeated['percentage'] ??
          (totalSoldPharmacies == 0
              ? 0
              : (repeatedCount /
                      totalSoldPharmacies) *
                  100),
    );

    return EvaluationRepeatedPharmaciesDetailsModel(
      month: _toInt(
        period['month'],
      ),

      year: _toInt(
        period['year'],
      ),

      regionId:
          scope['id']?.toString() ??
          'all',

      regionName:
          scope['name']?.toString() ??
          'جميع المناطق',

      repeatedCount:
          repeatedCount,

      totalSoldPharmacies:
          totalSoldPharmacies,

      percentage:
          percentage,

      score:
          _toDouble(
        repeated['score'] ??
            repeated['points'] ??
            0,
      ),

      maxScore:
          _toDouble(
        repeated['max_score'] ??
            repeated['max_points'] ??
            20,
      ),

      pharmacies:
          pharmacies,
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

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
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

class EvaluationRepeatedPharmacyModel {
  final int pharmacyId;
  final String pharmacyName;
  final String regionName;

  final int salesCount;

  final double totalSalesAmount;

  const EvaluationRepeatedPharmacyModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.regionName,
    required this.salesCount,
    required this.totalSalesAmount,
  });

  factory EvaluationRepeatedPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationRepeatedPharmacyModel(
      pharmacyId:
          _toInt(
        json['pharmacy_id'] ??
            json['id'],
      ),

      pharmacyName:
          json['pharmacy_name']
                  ?.toString() ??
              json['name']?.toString() ??
              '',

      regionName:
          json['region_name']
                  ?.toString() ??
              json['region']?.toString() ??
              '',

      salesCount:
          _toInt(
        json['sales_count'] ??
            json['sales_operations'] ??
            0,
      ),

      totalSalesAmount:
          _toDouble(
        json['total_sales_amount'] ??
            json['sales_amount'] ??
            0,
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

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