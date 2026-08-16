import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';

abstract class OffersState {}

class OffersInitial
    extends OffersState {}

class OffersLoading
    extends OffersState {}

class OffersSuccess
    extends OffersState {
  final OffersOverviewModel data;

  OffersSuccess({
    required this.data,
  });
}

class OffersFailure
    extends OffersState {
  final String message;

  OffersFailure({
    required this.message,
  });
}