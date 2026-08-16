import 'package:project_2/Features/auth/data/models/evaluation_archive_model.dart';

abstract class EvaluationArchiveState {}

class EvaluationArchiveInitial
    extends EvaluationArchiveState {}

class EvaluationArchiveLoading
    extends EvaluationArchiveState {}

class EvaluationArchiveSuccess
    extends EvaluationArchiveState {
  final List<EvaluationArchiveModel>
      evaluations;

  EvaluationArchiveSuccess({
    required this.evaluations,
  });
}

class EvaluationArchiveFailure
    extends EvaluationArchiveState {
  final String message;

  EvaluationArchiveFailure({
    required this.message,
  });
}