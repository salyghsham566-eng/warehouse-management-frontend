abstract class
    EvaluationRepeatedPharmaciesDetailsEvent {}

class LoadEvaluationRepeatedPharmaciesDetailsEvent
    extends EvaluationRepeatedPharmaciesDetailsEvent {
  final String regionId;
  final int month;
  final int year;

  LoadEvaluationRepeatedPharmaciesDetailsEvent({
    required this.regionId,
    required this.month,
    required this.year,
  });
}