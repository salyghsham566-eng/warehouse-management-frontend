import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';
import '../models/order_request_model.dart';
import '../models/order_response_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;

  const OrderRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<OrderResponseModel> sendOrder(
    OrderRequestModel order,
  ) {
    return dataSource.sendOrder(order);
  }
}