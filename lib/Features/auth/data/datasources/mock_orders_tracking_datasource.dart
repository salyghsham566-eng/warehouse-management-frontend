import 'package:project_2/Features/auth/data/models/order_details_model.dart'
    show OrderDetailsModel;
import 'package:project_2/orders_store.dart';

import '../models/tracked_order_model.dart';
import 'orders_tracking_datasource.dart';

class MockOrdersTrackingDataSource implements OrdersTrackingDataSource {
  List<Map<String, dynamic>> _fallbackOrders() {
    final DateTime now = DateTime.now();

    return [
      {
        'id': 1,
        'orderNumber': 'ORD-1001',
        'pharmacyName': 'صيدلية النهدي',
        'status': 'pending_review',
        'createdAt': now.toIso8601String(),
        'note': 'يرجى تجهيز الطلبية حسب الكميات المحددة.',
        'items': [
          {
            'productId': 101,
            'medicineName': 'Panadol Extra',
            'companyName': 'GSK',
            'quantity': 2,
            'freeQuantity': 0,
            'price': 35.00,
            'discountPercent': 0,
            'itemTotal': 70.00,
            'offerSource': 'لا يوجد عرض',
          },
          {
            'productId': 102,
            'medicineName': 'Augmentin 1g',
            'companyName': 'GSK',
            'quantity': 1,
            'freeQuantity': 0,
            'price': 122.50,
            'discountPercent': 0,
            'itemTotal': 122.50,
            'offerSource': 'لا يوجد عرض',
          },
        ],
        'itemsCount': 2,
        'subtotal': 192.50,
        'discount': 0.0,
        'total': 192.50,
      },
      {
        'id': 2,
        'orderNumber': 'ORD-1002',
        'pharmacyName': 'صيدلية الدواء',
        'status': 'approved',
        'createdAt': now
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'items': [
          {
            'productId': 201,
            'medicineName': 'Brufen 400',
            'companyName': 'Abbott',
            'quantity': 3,
            'freeQuantity': 0,
            'price': 40.00,
            'discountPercent': 0,
            'itemTotal': 120.00,
            'offerSource': 'لا يوجد عرض',
          },
          {
            'productId': 202,
            'medicineName': 'Voltaren',
            'companyName': 'Novartis',
            'quantity': 2,
            'freeQuantity': 0,
            'price': 55.00,
            'discountPercent': 0,
            'itemTotal': 110.00,
            'offerSource': 'لا يوجد عرض',
          },
          {
            'productId': 203,
            'medicineName': 'Concor 5mg',
            'companyName': 'Merck',
            'quantity': 2,
            'freeQuantity': 0,
            'price': 45.00,
            'discountPercent': 0,
            'itemTotal': 90.00,
            'offerSource': 'لا يوجد عرض',
          },
          {
            'productId': 204,
            'medicineName': 'Nexium 40mg',
            'companyName': 'AstraZeneca',
            'quantity': 2,
            'freeQuantity': 0,
            'price': 50.00,
            'discountPercent': 0,
            'itemTotal': 100.00,
            'offerSource': 'لا يوجد عرض',
          },
        ],
        'itemsCount': 4,
        'subtotal': 420.00,
        'discount': 0.0,
        'total': 420.00,
      },
    ];
  }

  List<Map<String, dynamic>> _allOrders() {
    final List<Map<String, dynamic>> result = [];
    final Set<String> usedNumbers = <String>{};

    // الطلبات التي أنشأها المستخدم تأتي أولاً حتى تكون هي الأحدث
    // وحتى تتغلب على أي طلب Mock يحمل نفس الرقم.
    final List<Map<String, dynamic>> sources = [
      ...OrdersStore.instance.ordersNotifier.value.map(
        (order) => Map<String, dynamic>.from(order),
      ),
      ..._fallbackOrders(),
    ];

    for (final order in sources) {
      final String number =
          order['orderNumber']?.toString() ??
          order['order_number']?.toString() ??
          '';

      if (number.isEmpty || usedNumbers.add(number)) {
        result.add(order);
      }
    }

    return result;
  }

  @override
  Future<List<TrackedOrderModel>> getOrders() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    return _allOrders()
        .map(
          (order) => TrackedOrderModel.fromJson(
            Map<String, dynamic>.from(order),
          ),
        )
        .toList();
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(
    String orderNumber,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );

    for (final order in _allOrders()) {
      final String number =
          order['orderNumber']?.toString() ??
          order['order_number']?.toString() ??
          '';

      if (number == orderNumber) {
        return OrderDetailsModel.fromJson(
          Map<String, dynamic>.from(order),
        );
      }
    }

    throw Exception('لم يتم العثور على الطلب');
  }
}
