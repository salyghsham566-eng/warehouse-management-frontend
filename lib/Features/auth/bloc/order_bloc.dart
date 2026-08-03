import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/domain/repositories/order_repository.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({
    required this.repository,
  }) : super(const OrderInitial()) {
    on<SendOrderEvent>(_sendOrder);
  }

  Future<void> _sendOrder(
    SendOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderSending());

    try {
      final response = await repository.sendOrder(
        event.order,
      );

      emit(
        OrderSuccess(
          orderNumber: response.orderNumber,
          message: response.message,
        ),
      );
    } catch (error) {
      emit(
        OrderFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return 'حدث خطأ أثناء إرسال الطلب';
  }
}