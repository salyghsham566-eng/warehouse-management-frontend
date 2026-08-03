import 'package:flutter/foundation.dart';

class OrdersStore {
  OrdersStore._();

  static final OrdersStore instance = OrdersStore._();

  final ValueNotifier<List<Map<String, dynamic>>> ordersNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  List<Map<String, dynamic>> get orders => ordersNotifier.value;

  void addOrder(Map<String, dynamic> order) {
    final Map<String, dynamic> newOrder = Map<String, dynamic>.from(order);

    ordersNotifier.value = [newOrder, ...ordersNotifier.value];
  }

  void updateOrderStatus({
    required String orderNumber,
    required String status,
  }) {
    ordersNotifier.value = ordersNotifier.value.map((order) {
    final String currentOrderNumber =
        order['orderNumber']?.toString() ??
        order['order_number']?.toString() ??
        '';

    if (currentOrderNumber == orderNumber) {
      return {
        ...order,
        'status': status,
      };
    }

    return order;
  }).toList();
}
}
