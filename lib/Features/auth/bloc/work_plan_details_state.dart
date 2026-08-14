import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';

abstract class WorkPlanDetailsState {}

class WorkPlanDetailsInitial
    extends WorkPlanDetailsState {}

class WorkPlanDetailsLoading
    extends WorkPlanDetailsState {}

class WorkPlanDetailsLoaded
    extends WorkPlanDetailsState {
  final WorkPlanDetailsModel plan;

  WorkPlanDetailsLoaded({
    required this.plan,
  });
}

class WorkPlanDetailsFailure
    extends WorkPlanDetailsState {
  final String message;

  WorkPlanDetailsFailure({
    required this.message,
  });
}