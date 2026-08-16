import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_work_plans_state.dart';

class EvaluationArchiveModel {
  final int month;
  final int year;

  final String regionId;
  final String regionName;

  final EvaluationScoreModel targetScore;
  final EvaluationScoreModel coverageScore;
  final EvaluationScoreModel repeatedScore;
  final EvaluationScoreModel oneTimeScore;

  final List<EvaluationWorkPlanModel>
      workPlanEvaluations;

  const EvaluationArchiveModel({
    required this.month,
    required this.year,
    required this.regionId,
    required this.regionName,
    required this.targetScore,
    required this.coverageScore,
    required this.repeatedScore,
    required this.oneTimeScore,
    required this.workPlanEvaluations,
  });

  // =========================================================
  // Final Evaluation
  // =========================================================

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

  // =========================================================
  // From Json
  // =========================================================

  factory EvaluationArchiveModel.fromJson(
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

    final dynamic rawPlans =
        data['work_plan_evaluations'] ??
            data['work_plans'] ??
            data['plans'] ??
            const [];

    return EvaluationArchiveModel(
      month: _toInt(
        period['month'] ??
            data['month'],
      ),

      year: _toInt(
        period['year'] ??
            data['year'],
      ),

      regionId:
          scope['id']?.toString() ??
              data['region_id']?.toString() ??
              'all',

      regionName:
          scope['name']?.toString() ??
              data['region_name']?.toString() ??
              'جميع المناطق',

      targetScore:
          EvaluationScoreModel.fromJson(
        _toMap(
              scores['target'],
            ) ??
            {},
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

      workPlanEvaluations:
          rawPlans is List
              ? rawPlans
                  .whereType<Map>()
                  .map(
                    (item) =>
                        EvaluationWorkPlanModel
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