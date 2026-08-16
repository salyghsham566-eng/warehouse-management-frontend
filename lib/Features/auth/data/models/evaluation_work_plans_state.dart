class EvaluationWorkPlanModel {
  final int planId;
  final String planName;
  final String startDate;
  final String endDate;
  final double completionPercentage;
  final String rating;

  const EvaluationWorkPlanModel({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.completionPercentage,
    required this.rating,
  });

  factory EvaluationWorkPlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvaluationWorkPlanModel(
      planId: _toInt(
        json['plan_id'] ?? json['id'],
      ),

      planName:
          json['plan_name']?.toString() ??
          json['name']?.toString() ??
          'خطة عمل',

      startDate:
          json['start_date']?.toString() ??
          json['from_date']?.toString() ??
          '',

      endDate:
          json['end_date']?.toString() ??
          json['to_date']?.toString() ??
          '',

      completionPercentage: _toDouble(
        json['completion_percentage'] ??
            json['completion'] ??
            json['progress'] ??
            0,
      ).clamp(0.0, 100.0).toDouble(),

      rating:
          json['rating']?.toString() ??
          json['descriptive_rating']?.toString() ??
          'غير مقيم',
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