import '../models/order_request_model.dart';
import '../models/order_response_model.dart';
import 'order_datasource.dart';

class MockOrderDataSource implements OrderDataSource {
  @override
  Future<OrderResponseModel> sendOrder(
    OrderRequestModel order,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );

    if (order.pharmacyId <= 0) {
      throw Exception('يجب اختيار صيدلية صحيحة');
    }

    if (order.items.isEmpty) {
      throw Exception('لا يمكن إرسال طلب فارغ');
    }

    if (order.totalAmount <= 0) {
      throw Exception('إجمالي الطلب غير صحيح');
    }

    return const OrderResponseModel(
      orderNumber: 'ORD-1001',
      message: 'تم إرسال الطلب بنجاح',
    );
  }
}