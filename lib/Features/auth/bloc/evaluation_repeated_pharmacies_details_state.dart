import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';

abstract class
    EvaluationRepeatedPharmaciesDetailsState {}

class EvaluationRepeatedPharmaciesDetailsInitial
    extends EvaluationRepeatedPharmaciesDetailsState {}

class EvaluationRepeatedPharmaciesDetailsLoading
    extends EvaluationRepeatedPharmaciesDetailsState {}

class EvaluationRepeatedPharmaciesDetailsSuccess
    extends EvaluationRepeatedPharmaciesDetailsState {
  final EvaluationRepeatedPharmaciesDetailsModel
      details;

  EvaluationRepeatedPharmaciesDetailsSuccess({
    required this.details,
  });
}

class EvaluationRepeatedPharmaciesDetailsFailure
    extends EvaluationRepeatedPharmaciesDetailsState {
  final String message;

  EvaluationRepeatedPharmaciesDetailsFailure({
    required this.message,
  });
}