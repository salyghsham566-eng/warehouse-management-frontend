abstract class EvaluationCoverageDetailsEvent {}

class LoadEvaluationCoverageDetailsEvent
    extends EvaluationCoverageDetailsEvent {
  final String regionId;
  final int month;
  final int year;

  LoadEvaluationCoverageDetailsEvent({
    required this.regionId,
    required this.month,
    required this.year,
  });
}