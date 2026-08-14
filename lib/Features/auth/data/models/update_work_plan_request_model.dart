import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';

class UpdateWorkPlanGoalRequest {
  final int? id;

  final CreateWorkPlanGoalType type;

  final double? targetValue;

  final List<int> productIds;
  final List<int> companyIds;
  final List<int> pharmacyIds;

  const UpdateWorkPlanGoalRequest({
    this.id,
    required this.type,
    this.targetValue,
    this.productIds = const [],
    this.companyIds = const [],
    this.pharmacyIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,

      'type': createWorkPlanGoalTypeToApi(type),

      if (targetValue != null)
        'target_value': targetValue,

      if (productIds.isNotEmpty)
        'product_ids': productIds,

      if (companyIds.isNotEmpty)
        'company_ids': companyIds,

      if (pharmacyIds.isNotEmpty)
        'pharmacy_ids': pharmacyIds,
    };
  }
}

class UpdateWorkPlanRequestModel {
  final String description;

  final DateTime startDate;
  final DateTime endDate;

  final List<UpdateWorkPlanGoalRequest> goals;

  final String? notes;

  const UpdateWorkPlanRequestModel({
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.goals,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description.trim(),

      'start_date':
          startDate.toIso8601String().split('T').first,

      'end_date':
          endDate.toIso8601String().split('T').first,

      'goals': goals
          .map((goal) => goal.toJson())
          .toList(),

      if (notes != null)
        'notes': notes!.trim(),
    };
  }
}