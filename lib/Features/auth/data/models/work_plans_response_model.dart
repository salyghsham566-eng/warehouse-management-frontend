import 'package:project_2/Features/auth/data/models/work_plan_model.dart';

class WorkPlansResponseModel {
  final List<WorkPlanModel> assignedPlans;
  final List<WorkPlanModel> createdPlans;

  const WorkPlansResponseModel({
    required this.assignedPlans,
    required this.createdPlans,
  });

  factory WorkPlansResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data =
        json['data'] as Map<String, dynamic>? ?? {};

    final assignedList =
        data['assigned_plans'] as List<dynamic>? ?? [];

    final createdList =
        data['created_plans'] as List<dynamic>? ?? [];

    return WorkPlansResponseModel(
      assignedPlans: assignedList
          .map(
            (item) => WorkPlanModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),

      createdPlans: createdList
          .map(
            (item) => WorkPlanModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}