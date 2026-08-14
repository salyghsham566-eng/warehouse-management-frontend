class EvaluationTargetDetailsModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final double requiredTarget;
  final double achievedTarget;
  final double percentage;

  final double score;
  final double maxScore;

  final List<EvaluationTargetPharmacyModel> pharmacies;

  const EvaluationTargetDetailsModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.requiredTarget,
    required this.achievedTarget,
    required this.percentage,
    required this.score,
    required this.maxScore,
    required this.pharmacies,
  });

  factory EvaluationTargetDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> period =
        _toMap(data['period']) ?? {};

    final Map<String, dynamic> scope =
        _toMap(data['scope']) ?? {};

    final Map<String, dynamic> target =
        _toMap(data['target']) ?? {};

    final dynamic rawPharmacies =
        data['pharmacies'];

    return EvaluationTargetDetailsModel(
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

      requiredTarget: _toDouble(
        target['required'] ??
            target['required_target'] ??
            0,
      ),

      achievedTarget: _toDouble(
        target['achieved'] ??
            target['achieved_target'] ??
            0,
      ),

      percentage: _toDouble(
        target['percentage'] ?? 0,
      ),

      score: _toDouble(
        target['score'] ??
            target['points'] ??
            0,
      ),

      maxScore: _toDouble(
        target['max_score'] ??
            target['max_points'] ??
            35,
      ),

      pharmacies:
          rawPharmacies is List
              ? rawPharmacies
                  .whereType<Map>()
                  .map(
                    (item) =>
                        EvaluationTargetPharmacyModel
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

// ==========================================================
// Pharmacy row
// ==========================================================

class EvaluationTargetPharmacyModel {
  final int pharmacyId;
  final String pharmacyName;

  /// قيمة المبيعات المحتسبة لهذه الصيدلية
  final double salesAmount;

  const EvaluationTargetPharmacyModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.salesAmount,
  });

  factory EvaluationTargetPharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationTargetPharmacyModel(
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

      salesAmount:
          _toDouble(
        json['sales_amount'] ??
            json['amount'] ??
            0,
      ),
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