import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';

abstract class EvaluationCoverageDetailsState {}

class EvaluationCoverageDetailsInitial
    extends EvaluationCoverageDetailsState {}

class EvaluationCoverageDetailsLoading
    extends EvaluationCoverageDetailsState {}

class EvaluationCoverageDetailsSuccess
    extends EvaluationCoverageDetailsState {
  final EvaluationCoverageDetailsModel
      details;

  EvaluationCoverageDetailsSuccess({
    required this.details,
  });
}

class EvaluationCoverageDetailsFailure
    extends EvaluationCoverageDetailsState {
  final String message;

  EvaluationCoverageDetailsFailure({
    required this.message,
  });
}