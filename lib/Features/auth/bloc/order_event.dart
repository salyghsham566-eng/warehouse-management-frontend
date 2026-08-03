import '../data/models/order_request_model.dart';

abstract class OrderEvent {
  const OrderEvent();
}

class SendOrderEvent extends OrderEvent {
  final OrderRequestModel order;

  const SendOrderEvent({
    required this.order,
  });
}