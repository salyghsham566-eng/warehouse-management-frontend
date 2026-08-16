import 'package:project_2/Features/auth/data/datasources/offers_data_source.dart';
import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';

import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';
import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';
import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';

class OffersRepositoryImpl
    implements OffersRepository {
  final OffersDataSource dataSource;

  const OffersRepositoryImpl({
    required this.dataSource,
  });

  // =========================================================
  // UC-213
  // =========================================================

  @override
  Future<OffersOverviewModel>
      getRepresentativeOffers() {
    return dataSource
        .getRepresentativeOffers();
  }

  // =========================================================
  // UC-214 -> UC-218
  // =========================================================

  @override
  Future<PromotionalBasketDetailsModel>
      getPromotionalBasketDetails({
    required String basketId,
  }) {
    return dataSource
        .getPromotionalBasketDetails(
      basketId: basketId,
    );
  }

  // =========================================================
  // UC-220 -> UC-221
  // =========================================================

  @override
  Future<List<UsedOfferHistoryModel>>
      getUsedOffersHistory() {
    return dataSource
        .getUsedOffersHistory();
  }
  @override
Future<ActiveOfferDetailsModel>
    getActiveOfferDetails({
  required String offerId,
}) {
  return dataSource
      .getActiveOfferDetails(
    offerId: offerId,
  );
}
}