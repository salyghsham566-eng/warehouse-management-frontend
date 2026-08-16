import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';

abstract class ActiveOfferDetailsState {}

class ActiveOfferDetailsInitial
    extends ActiveOfferDetailsState {}

class ActiveOfferDetailsLoading
    extends ActiveOfferDetailsState {}

class ActiveOfferDetailsSuccess
    extends ActiveOfferDetailsState {
  final ActiveOfferDetailsModel offer;

  ActiveOfferDetailsSuccess({
    required this.offer,
  });
}

class ActiveOfferDetailsFailure
    extends ActiveOfferDetailsState {
  final String message;

  ActiveOfferDetailsFailure({
    required this.message,
  });
}