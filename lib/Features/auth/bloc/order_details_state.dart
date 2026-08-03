import '../data/models/order_details_model.dart';

abstract class OrderDetailsState {
  const OrderDetailsState();
}

class OrderDetailsInitial extends OrderDetailsState {
  const OrderDetailsInitial();
}

class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderDetailsModel order;

  const OrderDetailsLoaded({
    required this.order,
  });
}

class OrderDetailsFailure extends OrderDetailsState {
  final String message;

  const OrderDetailsFailure({
    required this.message,
  });
}