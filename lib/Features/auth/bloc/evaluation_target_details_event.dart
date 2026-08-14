abstract class EvaluationTargetDetailsEvent {}

class LoadEvaluationTargetDetailsEvent
    extends EvaluationTargetDetailsEvent {
  final String regionId;
  final int month;
  final int year;

  LoadEvaluationTargetDetailsEvent({
    required this.regionId,
    required this.month,
    required this.year,
  });
}