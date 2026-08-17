abstract class OrderDetailsEvent {
  const OrderDetailsEvent();
}

class OrderDetailsRequested extends OrderDetailsEvent {
  final String orderNumber;

  const OrderDetailsRequested({
    required this.orderNumber,
  });
}

class OrderDetailsRefreshed extends OrderDetailsEvent {
  final String orderNumber;

  const OrderDetailsRefreshed({
    required this.orderNumber,
  });
}class OrderCancellationRequested
    extends OrderDetailsEvent {
  final String orderNumber;

  const OrderCancellationRequested({
    required this.orderNumber,
  });
}