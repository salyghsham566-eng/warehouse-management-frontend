import '../models/order_request_model.dart';
import '../models/order_response_model.dart';

abstract class OrderDataSource {
  Future<OrderResponseModel> sendOrder(
    OrderRequestModel order,
  );
}