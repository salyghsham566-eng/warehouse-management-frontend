abstract class EvaluationEvent {}

class LoadCurrentEvaluationEvent
    extends EvaluationEvent {
  final String regionId;

  LoadCurrentEvaluationEvent({
    this.regionId = 'all',
  });
}