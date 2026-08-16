import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

abstract class UsedOffersHistoryState {}

class UsedOffersHistoryInitial
    extends UsedOffersHistoryState {}

class UsedOffersHistoryLoading
    extends UsedOffersHistoryState {}

class UsedOffersHistorySuccess
    extends UsedOffersHistoryState {
  final List<UsedOfferHistoryModel> offers;

  UsedOffersHistorySuccess({
    required this.offers,
  });
}

class UsedOffersHistoryFailure
    extends UsedOffersHistoryState {
  final String message;

  UsedOffersHistoryFailure({
    required this.message,
  });
}