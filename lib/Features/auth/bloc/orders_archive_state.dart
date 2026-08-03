import '../data/models/tracked_order_model.dart';

abstract class OrdersArchiveState {
  const OrdersArchiveState();
}

class OrdersArchiveInitial extends OrdersArchiveState {
  const OrdersArchiveInitial();
}

class OrdersArchiveLoading extends OrdersArchiveState {
  const OrdersArchiveLoading();
}

class OrdersArchiveLoaded extends OrdersArchiveState {
  final List<TrackedOrderModel> orders;

  const OrdersArchiveLoaded({
    required this.orders,
  });
}

class OrdersArchiveFailure extends OrdersArchiveState {
  final String message;

  const OrdersArchiveFailure({
    required this.message,
  });
}