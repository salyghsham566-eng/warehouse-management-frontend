import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';

abstract class WorkPlanGoalDetailsState {}

class WorkPlanGoalDetailsInitial
    extends WorkPlanGoalDetailsState {}

class WorkPlanGoalDetailsLoading
    extends WorkPlanGoalDetailsState {}

class WorkPlanGoalDetailsLoaded
    extends WorkPlanGoalDetailsState {
  final WorkPlanGoalDetailsModel details;

  WorkPlanGoalDetailsLoaded({
    required this.details,
  });
}

class WorkPlanGoalDetailsFailure
    extends WorkPlanGoalDetailsState {
  final String message;

  WorkPlanGoalDetailsFailure({
    required this.message,
  });
}