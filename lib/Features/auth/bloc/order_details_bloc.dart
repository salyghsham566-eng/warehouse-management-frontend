import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/orders_tracking_repository.dart';
import 'order_details_event.dart';
import 'order_details_state.dart';

class OrderDetailsBloc
    extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrdersTrackingRepository repository;

  OrderDetailsBloc({
    required this.repository,
  }) : super(const OrderDetailsInitial()) {
    on<OrderDetailsRequested>(_getOrderDetails);
    on<OrderDetailsRefreshed>(_refreshOrderDetails);
  }

  Future<void> _getOrderDetails(
    OrderDetailsRequested event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(const OrderDetailsLoading());

    try {
      final order = await repository.getOrderDetails(
        event.orderNumber,
      );

      emit(
        OrderDetailsLoaded(order: order),
      );
    } catch (error) {
      emit(
        OrderDetailsFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _refreshOrderDetails(
    OrderDetailsRefreshed event,
    Emitter<OrderDetailsState> emit,
  ) async {
    try {
      final order = await repository.getOrderDetails(
        event.orderNumber,
      );

      emit(
        OrderDetailsLoaded(order: order),
      );
    } catch (error) {
      emit(
        OrderDetailsFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('لم يتم العثور')) {
      return 'لم يتم العثور على الطلبية';
    }

    return 'تعذر تحميل تفاصيل الطلبية';
  }
}