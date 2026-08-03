import 'package:project_2/Features/auth/data/models/order_details_model.dart' show OrderDetailsModel;
import 'package:project_2/orders_store.dart';

import '../models/tracked_order_model.dart';
import 'orders_tracking_datasource.dart';

class MockOrdersTrackingDataSource
    implements OrdersTrackingDataSource {
  @override
  Future<List<TrackedOrderModel>> getOrders() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    final localOrders =
        OrdersStore.instance.ordersNotifier.value;

    if (localOrders.isNotEmpty) {
      return localOrders
          .map(
            (order) => TrackedOrderModel.fromJson(
              Map<String, dynamic>.from(order),
            ),
          )
          .toList();
    }

    return [
      TrackedOrderModel(
        id: 1,
        orderNumber: 'ORD-1001',
        pharmacyName: 'صيدلية النهدي',
        status: 'pending_review',
        createdAt: DateTime.now(),
        itemsCount: 2,
        total: 192.50,
      ),
      TrackedOrderModel(
        id: 2,
        orderNumber: 'ORD-1002',
        pharmacyName: 'صيدلية الدواء',
        status: 'approved',
        createdAt: DateTime.now().subtract(
          const Duration(days: 1),
        ),
        itemsCount: 4,
        total: 420,
      ),
    ];
  }
  @override
Future<OrderDetailsModel> getOrderDetails(
  String orderNumber,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 400),
  );

  final orders =
      OrdersStore.instance.ordersNotifier.value;

  for (final order in orders) {
    final number =
        order['orderNumber']?.toString() ??
        order['order_number']?.toString();

    if (number == orderNumber) {
      return OrderDetailsModel.fromJson(order);
    }
  }

  throw Exception('لم يتم العثور على الطلب');
}
}