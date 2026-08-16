import 'package:project_2/Features/auth/data/models/evaluation_work_plans_state.dart';

abstract class EvaluationWorkPlansState {}

class EvaluationWorkPlansInitial
    extends EvaluationWorkPlansState {}

class EvaluationWorkPlansLoading
    extends EvaluationWorkPlansState {}

class EvaluationWorkPlansSuccess
    extends EvaluationWorkPlansState {
  final List<EvaluationWorkPlanModel> plans;

  EvaluationWorkPlansSuccess({
    required this.plans,
  });
}

class EvaluationWorkPlansFailure
    extends EvaluationWorkPlansState {
  final String message;

  EvaluationWorkPlansFailure({
    required this.message,
  });
}