import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/orders_tracking_repository.dart';
import 'orders_archive_event.dart';
import 'orders_archive_state.dart';

class OrdersArchiveBloc
    extends Bloc<OrdersArchiveEvent, OrdersArchiveState> {
  final OrdersTrackingRepository repository;

  OrdersArchiveBloc({
    required this.repository,
  }) : super(const OrdersArchiveInitial()) {
    on<OrdersArchiveStarted>(_loadOrders);
    on<OrdersArchiveRefreshed>(_refreshOrders);
  }

  Future<void> _loadOrders(
    OrdersArchiveStarted event,
    Emitter<OrdersArchiveState> emit,
  ) async {
    emit(const OrdersArchiveLoading());

    try {
      final orders = await repository.getOrders();

      emit(
        OrdersArchiveLoaded(
          orders: orders,
        ),
      );
    } catch (error) {
      emit(
        OrdersArchiveFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _refreshOrders(
    OrdersArchiveRefreshed event,
    Emitter<OrdersArchiveState> emit,
  ) async {
    try {
      final orders = await repository.getOrders();

      emit(
        OrdersArchiveLoaded(
          orders: orders,
        ),
      );
    } catch (error) {
      emit(
        OrdersArchiveFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    return 'تعذر تحميل أرشيف الطلبات';
  }
}