abstract class OrdersArchiveEvent {
  const OrdersArchiveEvent();
}

class OrdersArchiveStarted extends OrdersArchiveEvent {
  const OrdersArchiveStarted();
}

class OrdersArchiveRefreshed extends OrdersArchiveEvent {
  const OrdersArchiveRefreshed();
}