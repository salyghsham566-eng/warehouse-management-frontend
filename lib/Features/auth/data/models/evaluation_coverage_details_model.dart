class EvaluationCoverageDetailsModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final int coveredCount;
  final int uncoveredCount;
  final int totalPharmacies;

  final double percentage;

  final double score;
  final double maxScore;

  final List<EvaluationCoveragePharmacyModel>
      coveredPharmacies;

  final List<EvaluationCoveragePharmacyModel>
      uncoveredPharmacies;

  const EvaluationCoverageDetailsModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.coveredCount,
    required this.uncoveredCount,
    required this.totalPharmacies,
    required this.percentage,
    required this.score,
    required this.maxScore,
    required this.coveredPharmacies,
    required this.uncoveredPharmacies,
  });

  factory EvaluationCoverageDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> period =
        _toMap(data['period']) ?? {};

    final Map<String, dynamic> scope =
        _toMap(data['scope']) ?? {};

    final Map<String, dynamic> coverage =
        _toMap(data['coverage']) ?? {};

    final dynamic rawCovered =
        data['covered_pharmacies'];

    final dynamic rawUncovered =
        data['uncovered_pharmacies'];

    final covered =
        rawCovered is List
            ? rawCovered
                .whereType<Map>()
                .map(
                  (item) =>
                      EvaluationCoveragePharmacyModel
                          .fromJson(
                    Map<String, dynamic>.from(
                      item,
                    ),
                  ),
                )
                .toList()
            : <EvaluationCoveragePharmacyModel>[];

    final uncovered =
        rawUncovered is List
            ? rawUncovered
                .whereType<Map>()
                .map(
                  (item) =>
                      EvaluationCoveragePharmacyModel
                          .fromJson(
                    Map<String, dynamic>.from(
                      item,
                    ),
                  ),
                )
                .toList()
            : <EvaluationCoveragePharmacyModel>[];

    final int coveredCount =
        _toInt(
      coverage['covered_count'] ??
          covered.length,
    );

    final int uncoveredCount =
        _toInt(
      coverage['uncovered_count'] ??
          uncovered.length,
    );

    final int total =
        _toInt(
      coverage['total_pharmacies'] ??
          coveredCount + uncoveredCount,
    );

    final double percentage =
        _toDouble(
      coverage['percentage'] ??
          (total == 0
              ? 0
              : (coveredCount / total) * 100),
    );

    return EvaluationCoverageDetailsModel(
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

      coveredCount:
          coveredCount,

      uncoveredCount:
          uncoveredCount,

      totalPharmacies:
          total,

      percentage:
          percentage,

      score:
          _toDouble(
        coverage['score'] ??
            coverage['points'] ??
            0,
      ),

      maxScore:
          _toDouble(
        coverage['max_score'] ??
            coverage['max_points'] ??
            35,
      ),

      coveredPharmacies:
          covered,

      uncoveredPharmacies:
          uncovered,
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
}

// ==========================================================
// Pharmacy
// ==========================================================

class EvaluationCoveragePharmacyModel {
  final int pharmacyId;
  final String pharmacyName;
  final String regionName;

  final int salesCount;

  const EvaluationCoveragePharmacyModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.regionName,
    required this.salesCount,
  });

  factory EvaluationCoveragePharmacyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationCoveragePharmacyModel(
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
}