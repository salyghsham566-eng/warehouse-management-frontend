abstract class EvaluationArchiveEvent {}

class LoadEvaluationArchiveEvent
    extends EvaluationArchiveEvent {
  final String regionId;

  final int? month;
  final int? year;

  LoadEvaluationArchiveEvent({
    required this.regionId,
    this.month,
    this.year,
  });
}