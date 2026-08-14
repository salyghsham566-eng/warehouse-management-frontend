import 'package:project_2/Features/auth/data/models/create_work_plan_response_model.dart';

abstract class CreateWorkPlanState {}

class CreateWorkPlanInitial
    extends CreateWorkPlanState {}

class CreateWorkPlanLoading
    extends CreateWorkPlanState {}

class CreateWorkPlanSuccess
    extends CreateWorkPlanState {
  final CreateWorkPlanResponseModel response;

  CreateWorkPlanSuccess({
    required this.response,
  });
}

class CreateWorkPlanFailure
    extends CreateWorkPlanState {
  final String message;

  CreateWorkPlanFailure({
    required this.message,
  });
}