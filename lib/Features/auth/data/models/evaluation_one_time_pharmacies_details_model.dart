class EvaluationOneTimePharmaciesDetailsModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final int oneTimeCount;
  final int totalSoldPharmacies;

  final double percentage;

  final double score;
  final double maxScore;

  final List<EvaluationOneTimePharmacyModel> pharmacies;

  const EvaluationOneTimePharmaciesDetailsModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.oneTimeCount,
    required this.totalSoldPharmacies,
    required this.percentage,
    required this.score,
    required this.maxScore,
    required this.pharmacies,
  });

  factory EvaluationOneTimePharmaciesDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> period =
        _toMap(data['period']) ?? {};

    final Map<String, dynamic> scope =
        _toMap(data['scope']) ?? {};

    final Map<String, dynamic> oneTime =
        _toMap(data['one_time']) ?? {};

    final dynamic rawPharmacies =
        data['pharmacies'];

    final pharmacies =
        rawPharmacies is List
            ? rawPharmacies
                .whereType<Map>()
                .map(
                  (item) =>
                      EvaluationOneTimePharmacyModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
            : <EvaluationOneTimePharmacyModel>[];

    final int oneTimeCount =
        _toInt(
      oneTime['one_time_count'] ??
          pharmacies.length,
    );

    final int totalSoldPharmacies =
        _toInt(
      oneTime['total_sold_pharmacies'] ??
          oneTimeCount,
    );

    final double percentage =
        _toDouble(
      oneTime['percentage'] ??
          (totalSoldPharmacies == 0
              ? 0
              : (oneTimeCount /
                      totalSoldPharmacies) *
                  100),
    );

    return EvaluationOneTimePharmaciesDetailsModel(
      month:
          _toInt(period['month']),

      year:
          _toInt(period['year']),

      regionId:
          scope['id']?.toString() ??
          'all',

      regionName:
          scope['name']?.toString() ??
          'جميع المناطق',

      oneTimeCount:
          oneTimeCount,

      totalSoldPharmacies:
          totalSoldPharmacies,

      percentage:
          percentage,

      score:
          _toDouble(
        oneTime['score'] ??
            oneTime['points'] ??
            0,
      ),

      maxScore:
          _toDouble(
        oneTime['max_score'] ??
            oneTime['max_points'] ??
            10,
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

// ==========================================================
// Pharmacy
// ==========================================================

class EvaluationOneTimePharmacyModel {
  final int pharmacyId;
  final String pharmacyName;
  final String regionName;

  final int salesCount;

  final double salesAmount;

  final String? lastSaleDate;

  const EvaluationOneTimePharmacyModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.regionName,
    required this.salesCount,
    required this.salesAmount,
    this.lastSaleDate,
  });

  factory EvaluationOneTimePharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationOneTimePharmacyModel(
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
            1,
      ),

      salesAmount:
          _toDouble(
        json['sales_amount'] ??
            json['amount'] ??
            0,
      ),

      lastSaleDate:
          json['last_sale_date']
              ?.toString(),
    );
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