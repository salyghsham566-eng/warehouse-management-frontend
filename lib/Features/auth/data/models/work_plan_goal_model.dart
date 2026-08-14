enum WorkPlanGoalType {
  general,
  sales,
  pharmacyCoverage,
  visits,
  collection,
}

class WorkPlanGoalModel {
  final int id;
  final String title;
  final String description;
  final WorkPlanGoalType type;

  final double targetValue;
  final double achievedValue;

  /// النسبة محسوبة من الباك وليست من إدخال المندوب.
  final double progress;

  final String unit;

  const WorkPlanGoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.achievedValue,
    required this.progress,
    required this.unit,
  });

  factory WorkPlanGoalModel.fromJson(Map<String, dynamic> json) {
    return WorkPlanGoalModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: goalTypeFromString(
        json['type']?.toString(),
      ),
      targetValue: _toDouble(json['target_value']),
      achievedValue: _toDouble(json['achieved_value']),
      progress: _toDouble(json['progress']),
      unit: json['unit'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

WorkPlanGoalType goalTypeFromString(String? value) {
  switch (value) {
    case 'sales':
      return WorkPlanGoalType.sales;

    case 'pharmacy_coverage':
      return WorkPlanGoalType.pharmacyCoverage;

    case 'visits':
      return WorkPlanGoalType.visits;

    case 'collection':
      return WorkPlanGoalType.collection;

    case 'general':
    default:
      return WorkPlanGoalType.general;
  }
}