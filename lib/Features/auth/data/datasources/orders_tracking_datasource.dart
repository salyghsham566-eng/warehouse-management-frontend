import 'package:project_2/Features/auth/data/models/order_details_model.dart';

import '../models/tracked_order_model.dart';

abstract class OrdersTrackingDataSource {
  Future<List<TrackedOrderModel>> getOrders();
  Future<OrderDetailsModel> getOrderDetails(
    String orderNumber,
  );Future<void> cancelOrder(
  String orderNumber,
);
}