import 'package:project_2/Features/auth/data/models/submit_work_plan_response_model.dart';

abstract class SubmitWorkPlanState {}

class SubmitWorkPlanInitial
    extends SubmitWorkPlanState {}

class SubmitWorkPlanLoading
    extends SubmitWorkPlanState {}

class SubmitWorkPlanSuccess
    extends SubmitWorkPlanState {
  final SubmitWorkPlanResponseModel response;

  SubmitWorkPlanSuccess({
    required this.response,
  });
}

class SubmitWorkPlanFailure
    extends SubmitWorkPlanState {
  final String message;

  SubmitWorkPlanFailure({
    required this.message,
  });
}