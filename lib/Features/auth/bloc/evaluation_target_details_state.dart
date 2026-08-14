import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';

abstract class EvaluationTargetDetailsState {}

class EvaluationTargetDetailsInitial
    extends EvaluationTargetDetailsState {}

class EvaluationTargetDetailsLoading
    extends EvaluationTargetDetailsState {}

class EvaluationTargetDetailsSuccess
    extends EvaluationTargetDetailsState {
  final EvaluationTargetDetailsModel details;

  EvaluationTargetDetailsSuccess({
    required this.details,
  });
}

class EvaluationTargetDetailsFailure
    extends EvaluationTargetDetailsState {
  final String message;

  EvaluationTargetDetailsFailure({
    required this.message,
  });
}