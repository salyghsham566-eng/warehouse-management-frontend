import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';

abstract class UpdateWorkPlanEvent {}

class UpdateWorkPlanSubmitted
    extends UpdateWorkPlanEvent {
  final int planId;
  final UpdateWorkPlanRequestModel request;

  UpdateWorkPlanSubmitted({
    required this.planId,
    required this.request,
  });
}