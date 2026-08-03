import '../data/models/tracked_order_model.dart';

abstract class OrdersTrackingState {
  const OrdersTrackingState();
}

class OrdersTrackingInitial
    extends OrdersTrackingState {
  const OrdersTrackingInitial();
}

class OrdersTrackingLoading
    extends OrdersTrackingState {
  const OrdersTrackingLoading();
}

class OrdersTrackingLoaded
    extends OrdersTrackingState {
  final List<TrackedOrderModel> orders;

  const OrdersTrackingLoaded({
    required this.orders,
  });
}

class OrdersTrackingFailure
    extends OrdersTrackingState {
  final String message;

  const OrdersTrackingFailure({
    required this.message,
  });
}