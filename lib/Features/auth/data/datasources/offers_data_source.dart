import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';
import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';
import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';
import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

abstract class OffersDataSource {
  // =========================================================
  // UC-213
  // =========================================================

  Future<OffersOverviewModel>
      getRepresentativeOffers();

  // =========================================================
  // UC-214 -> UC-218
  // =========================================================

  Future<PromotionalBasketDetailsModel>
      getPromotionalBasketDetails({
    required String basketId,
  });

  // =========================================================
  // UC-220 -> UC-221
  // =========================================================

  Future<List<UsedOfferHistoryModel>>
      getUsedOffersHistory();
      // =========================================================
// Active Offer Details
// UC-214 -> UC-218
// =========================================================

Future<ActiveOfferDetailsModel>
    getActiveOfferDetails({
  required String offerId,
});
}