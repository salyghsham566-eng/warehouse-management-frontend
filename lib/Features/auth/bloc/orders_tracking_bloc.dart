import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/orders_tracking_repository.dart';
import 'orders_tracking_event.dart';
import 'orders_tracking_state.dart';

class OrdersTrackingBloc extends Bloc<
    OrdersTrackingEvent,
    OrdersTrackingState> {
  final OrdersTrackingRepository repository;

  OrdersTrackingBloc({
    required this.repository,
  }) : super(const OrdersTrackingInitial()) {
    on<OrdersTrackingStarted>(_loadOrders);
    on<OrdersTrackingRefreshed>(_loadOrders);
  }

  Future<void> _loadOrders(
    OrdersTrackingEvent event,
    Emitter<OrdersTrackingState> emit,
  ) async {
    emit(const OrdersTrackingLoading());

    try {
      final orders = await repository.getOrders();

      emit(
        OrdersTrackingLoaded(
          orders: orders,
        ),
      );
    } catch (error) {
      emit(
        const OrdersTrackingFailure(
          message: 'تعذر تحميل الطلبات',
        ),
      );
    }
  }
}