import 'package:project_2/Features/auth/data/models/work_plan_model.dart';

abstract class WorkPlansState {}

class WorkPlansInitial extends WorkPlansState {}

class WorkPlansLoading extends WorkPlansState {}

class WorkPlansLoaded extends WorkPlansState {
  final List<WorkPlanModel> assignedPlans;
  final List<WorkPlanModel> createdPlans;

  WorkPlansLoaded({
    required this.assignedPlans,
    required this.createdPlans,
  });
}

class WorkPlansFailure extends WorkPlansState {
  final String message;

  WorkPlansFailure({
    required this.message,
  });
}