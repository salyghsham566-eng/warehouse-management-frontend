abstract class ActiveOfferDetailsEvent {}

class LoadActiveOfferDetailsEvent
    extends ActiveOfferDetailsEvent {
  final String offerId;

  LoadActiveOfferDetailsEvent({
    required this.offerId,
  });
}