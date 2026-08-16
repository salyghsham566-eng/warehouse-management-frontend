import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';

abstract class PromotionalBasketDetailsState {}

class PromotionalBasketDetailsInitial
    extends PromotionalBasketDetailsState {}

class PromotionalBasketDetailsLoading
    extends PromotionalBasketDetailsState {}

class PromotionalBasketDetailsSuccess
    extends PromotionalBasketDetailsState {
  final PromotionalBasketDetailsModel
      basket;

  PromotionalBasketDetailsSuccess({
    required this.basket,
  });
}

class PromotionalBasketDetailsFailure
    extends PromotionalBasketDetailsState {
  final String message;

  PromotionalBasketDetailsFailure({
    required this.message,
  });
}