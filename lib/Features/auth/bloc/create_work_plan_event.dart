import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';

abstract class CreateWorkPlanEvent {}

class CreateWorkPlanSubmitted
    extends CreateWorkPlanEvent {
  final CreateWorkPlanRequestModel request;

  CreateWorkPlanSubmitted({
    required this.request,
  });
}