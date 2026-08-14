import 'package:project_2/Features/auth/data/models/work_plan_goal_model.dart';

class WorkPlanGoalDetailsModel {
  final int goalId;
  final String title;
  final WorkPlanGoalType type;

  final double targetValue;
  final double achievedValue;
  final double progress;
  final String unit;

  /// UC-194 البيانات الفعلية العامة
  final List<GoalActualDataModel> actualData;

  /// UC-195 الفواتير المحتسبة
  final List<GoalInvoiceModel> invoices;

  /// UC-196 الزيارات / تغطية الصيدليات
  final List<GoalCoverageModel> coverage;

  /// UC-197 ملخص التحصيل فقط
  final CollectionGoalSummaryModel? collectionSummary;

  const WorkPlanGoalDetailsModel({
    required this.goalId,
    required this.title,
    required this.type,
    required this.targetValue,
    required this.achievedValue,
    required this.progress,
    required this.unit,
    required this.actualData,
    required this.invoices,
    required this.coverage,
    this.collectionSummary,
  });

  factory WorkPlanGoalDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkPlanGoalDetailsModel(
      goalId: json['goal_id'] ?? 0,
      title: json['title'] ?? '',
      type: goalTypeFromString(
        json['type']?.toString(),
      ),
      targetValue: _toDouble(json['target_value']),
      achievedValue: _toDouble(json['achieved_value']),
      progress: _toDouble(json['progress']),
      unit: json['unit'] ?? '',

      actualData:
          (json['actual_data'] as List<dynamic>? ?? [])
              .map(
                (e) => GoalActualDataModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),

      invoices:
          (json['invoices'] as List<dynamic>? ?? [])
              .map(
                (e) => GoalInvoiceModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),

      coverage:
          (json['coverage'] as List<dynamic>? ?? [])
              .map(
                (e) => GoalCoverageModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),

      collectionSummary:
          json['collection_summary'] != null
              ? CollectionGoalSummaryModel.fromJson(
                  Map<String, dynamic>.from(
                    json['collection_summary'],
                  ),
                )
              : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}class GoalActualDataModel {
  final String label;
  final String value;
  final String date;

  const GoalActualDataModel({
    required this.label,
    required this.value,
    required this.date,
  });

  factory GoalActualDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GoalActualDataModel(
      label: json['label'] ?? '',
      value: json['value']?.toString() ?? '',
      date: json['date'] ?? '',
    );
  }
}

class GoalInvoiceModel {
  final int id;
  final String invoiceNumber;
  final String pharmacyName;
  final String date;
  final double amount;

  const GoalInvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.pharmacyName,
    required this.date,
    required this.amount,
  });

  factory GoalInvoiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GoalInvoiceModel(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '',
      pharmacyName: json['pharmacy_name'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class GoalCoverageModel {
  final int pharmacyId;
  final String pharmacyName;
  final String date;
  final bool completed;

  const GoalCoverageModel({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.date,
    required this.completed,
  });

  factory GoalCoverageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GoalCoverageModel(
      pharmacyId: json['pharmacy_id'] ?? 0,
      pharmacyName: json['pharmacy_name'] ?? '',
      date: json['date'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}

class CollectionGoalSummaryModel {
  final double targetAmount;
  final double collectedAmount;
  final int operationsCount;

  const CollectionGoalSummaryModel({
    required this.targetAmount,
    required this.collectedAmount,
    required this.operationsCount,
  });

  factory CollectionGoalSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CollectionGoalSummaryModel(
      targetAmount:
          (json['target_amount'] as num?)?.toDouble() ?? 0,
      collectedAmount:
          (json['collected_amount'] as num?)?.toDouble() ?? 0,
      operationsCount:
          json['operations_count'] ?? 0,
    );
  }
}