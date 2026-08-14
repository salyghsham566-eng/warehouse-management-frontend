abstract class
    EvaluationOneTimePharmaciesDetailsEvent {}

class LoadEvaluationOneTimePharmaciesDetailsEvent
    extends EvaluationOneTimePharmaciesDetailsEvent {
  final String regionId;
  final int month;
  final int year;

  LoadEvaluationOneTimePharmaciesDetailsEvent({
    required this.regionId,
    required this.month,
    required this.year,
  });
}