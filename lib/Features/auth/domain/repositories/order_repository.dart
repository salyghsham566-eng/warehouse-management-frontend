import '../../data/models/order_request_model.dart';
import '../../data/models/order_response_model.dart';

abstract class OrderRepository {
  Future<OrderResponseModel> sendOrder(
    OrderRequestModel order,
  );
}