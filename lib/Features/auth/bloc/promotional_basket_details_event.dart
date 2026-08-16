abstract class PromotionalBasketDetailsEvent {}

class LoadPromotionalBasketDetailsEvent
    extends PromotionalBasketDetailsEvent {
  final String basketId;

  LoadPromotionalBasketDetailsEvent({
    required this.basketId,
  });
}