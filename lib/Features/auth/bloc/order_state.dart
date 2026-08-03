abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderSending extends OrderState {
  const OrderSending();
}

class OrderSuccess extends OrderState {
  final String orderNumber;
  final String message;

  const OrderSuccess({
    required this.orderNumber,
    required this.message,
  });
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure({
    required this.message,
  });
}