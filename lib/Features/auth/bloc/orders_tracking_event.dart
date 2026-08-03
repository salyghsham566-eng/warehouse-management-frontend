abstract class OrdersTrackingEvent {
  const OrdersTrackingEvent();
}

class OrdersTrackingStarted
    extends OrdersTrackingEvent {
  const OrdersTrackingStarted();
}

class OrdersTrackingRefreshed
    extends OrdersTrackingEvent {
  const OrdersTrackingRefreshed();
}