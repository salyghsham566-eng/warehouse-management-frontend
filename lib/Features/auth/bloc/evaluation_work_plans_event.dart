abstract class EvaluationWorkPlansEvent {}

class LoadEvaluationWorkPlansEvent
    extends EvaluationWorkPlansEvent {
  final String regionId;
  final int month;
  final int year;

  LoadEvaluationWorkPlansEvent({
    required this.regionId,
    required this.month,
    required this.year,
  });
}