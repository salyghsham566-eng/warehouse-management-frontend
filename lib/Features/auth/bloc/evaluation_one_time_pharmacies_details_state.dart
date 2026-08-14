import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';

abstract class
    EvaluationOneTimePharmaciesDetailsState {}

class EvaluationOneTimePharmaciesDetailsInitial
    extends EvaluationOneTimePharmaciesDetailsState {}

class EvaluationOneTimePharmaciesDetailsLoading
    extends EvaluationOneTimePharmaciesDetailsState {}

class EvaluationOneTimePharmaciesDetailsSuccess
    extends EvaluationOneTimePharmaciesDetailsState {
  final EvaluationOneTimePharmaciesDetailsModel
      details;

  EvaluationOneTimePharmaciesDetailsSuccess({
    required this.details,
  });
}

class EvaluationOneTimePharmaciesDetailsFailure
    extends EvaluationOneTimePharmaciesDetailsState {
  final String message;

  EvaluationOneTimePharmaciesDetailsFailure({
    required this.message,
  });
}