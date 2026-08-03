import 'package:project_2/Features/auth/data/models/order_details_model.dart';

import '../../domain/repositories/orders_tracking_repository.dart';
import '../datasources/orders_tracking_datasource.dart';
import '../models/tracked_order_model.dart';

class OrdersTrackingRepositoryImpl
    implements OrdersTrackingRepository {
  final OrdersTrackingDataSource dataSource;

  const OrdersTrackingRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<TrackedOrderModel>> getOrders() {
    return dataSource.getOrders();
  }
  @override
Future<OrderDetailsModel> getOrderDetails(
  String orderNumber,
) {
  return dataSource.getOrderDetails(orderNumber);
}
}