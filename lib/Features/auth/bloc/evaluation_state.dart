import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';

abstract class EvaluationState {}

class EvaluationInitial
    extends EvaluationState {}

class EvaluationLoading
    extends EvaluationState {}

class EvaluationSuccess
    extends EvaluationState {
  final EvaluationOverviewModel evaluation;

  EvaluationSuccess({
    required this.evaluation,
  });
}

class EvaluationFailure
    extends EvaluationState {
  final String message;

  EvaluationFailure({
    required this.message,
  });
}