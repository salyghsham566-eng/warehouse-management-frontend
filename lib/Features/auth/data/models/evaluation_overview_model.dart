class EvaluationOverviewModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final List<EvaluationRegionModel> regions;

  // UC-205
  final EvaluationScoreModel targetScore;
  final EvaluationScoreModel coverageScore;
  final EvaluationScoreModel repeatedScore;
  final EvaluationScoreModel oneTimeScore;
// ==========================================================
// UC-210 - Final Evaluation
// ==========================================================

double get finalScore {
  return targetScore.score +
      coverageScore.score +
      repeatedScore.score +
      oneTimeScore.score;
}

double get finalMaxScore {
  return targetScore.maxScore +
      coverageScore.maxScore +
      repeatedScore.maxScore +
      oneTimeScore.maxScore;
}

double get finalPercentage {
  if (finalMaxScore <= 0) {
    return 0;
  }

  return (finalScore / finalMaxScore) * 100;
}
  const EvaluationOverviewModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.regions,
    required this.targetScore,
    required this.coverageScore,
    required this.repeatedScore,
    required this.oneTimeScore,  
    
  });

  factory EvaluationOverviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> data =
        _toMap(json['data']) ?? json;

    final Map<String, dynamic> period =
        _toMap(data['period']) ??
            <String, dynamic>{};

    final Map<String, dynamic> scope =
        _toMap(data['scope']) ??
            <String, dynamic>{};

    final Map<String, dynamic> scores =
        _toMap(data['scores']) ??
            <String, dynamic>{};

    final dynamic rawRegions =
        data['regions'];

    return EvaluationOverviewModel(
      month: _parseInt(
        period['month'],
        fallback: DateTime.now().month,
      ),

      year: _parseInt(
        period['year'],
        fallback: DateTime.now().year,
      ),

      regionId:
          scope['id']?.toString() ??
          'all',

      regionName:
          scope['name']?.toString() ??
          'جميع المناطق',

      regions: rawRegions is List
          ? rawRegions
              .whereType<Map>()
              .map(
                (item) =>
                    EvaluationRegionModel.fromJson(
                  Map<String, dynamic>.from(
                    item,
                  ),
                ),
              )
              .where(
                (region) =>
                    region.id.isNotEmpty,
              )
              .toList()
          : const [],

      targetScore:
          EvaluationScoreModel.fromJson(
        _toMap(scores['target']) ?? {},
        defaultMaxScore: 35,
      ),

      coverageScore:
          EvaluationScoreModel.fromJson(
        _toMap(
              scores['pharmacy_coverage'],
            ) ??
            {},
        defaultMaxScore: 35,
      ),

      repeatedScore:
          EvaluationScoreModel.fromJson(
        _toMap(
              scores['repeated_pharmacies'],
            ) ??
            {},
        defaultMaxScore: 20,
      ),

      oneTimeScore:
          EvaluationScoreModel.fromJson(
        _toMap(
              scores['one_time_pharmacies'],
            ) ??
            {},
        defaultMaxScore: 10,
      ),
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

  static int _parseInt(
    dynamic value, {
    required int fallback,
  }) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }
}

// ==========================================================
// Region
// ==========================================================

class EvaluationRegionModel {
  final String id;
  final String name;

  const EvaluationRegionModel({
    required this.id,
    required this.name,
  });

  factory EvaluationRegionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationRegionModel(
      id: json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ?? '',
    );
  }
}

// ==========================================================
// UC-205 - Evaluation Score
// ==========================================================

class EvaluationScoreModel {
  final double score;
  final double maxScore;

  const EvaluationScoreModel({
    required this.score,
    required this.maxScore,
  });

  factory EvaluationScoreModel.fromJson(
    Map<String, dynamic> json, {
    required double defaultMaxScore,
  }) {
    return EvaluationScoreModel(
      score: _toDouble(
        json['score'] ??
            json['points'] ??
            0,
      ),

      maxScore: _toDouble(
        json['max_score'] ??
            json['max_points'] ??
            defaultMaxScore,
      ),
    );
  }

  double get percentage {
    if (maxScore <= 0) {
      return 0;
    }

    return (score / maxScore) * 100;
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