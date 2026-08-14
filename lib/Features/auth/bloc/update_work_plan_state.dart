abstract class UpdateWorkPlanState {}

class UpdateWorkPlanInitial
    extends UpdateWorkPlanState {}

class UpdateWorkPlanLoading
    extends UpdateWorkPlanState {}

class UpdateWorkPlanSuccess
    extends UpdateWorkPlanState {
  final String message;

  UpdateWorkPlanSuccess({
    required this.message,
  });
}

class UpdateWorkPlanFailure
    extends UpdateWorkPlanState {
  final String message;

  UpdateWorkPlanFailure({
    required this.message,
  });
}