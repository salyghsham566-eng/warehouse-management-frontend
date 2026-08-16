import '../models/order_request_model.dart';
import '../models/order_response_model.dart';
import 'order_datasource.dart';

class MockOrderDataSource implements OrderDataSource {
  // ORD-1001 و ORD-1002 مستخدمان في البيانات الافتراضية.
  // لذلك تبدأ الطلبيات الجديدة من 1003 ويزيد الرقم مع كل إرسال.
  static int _nextOrderNumber = 1003;

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

    final String orderNumber =
        'ORD-${_nextOrderNumber++}';

    return OrderResponseModel(
      orderNumber: orderNumber,
      message: 'تم إرسال الطلب بنجاح',
    );
  }
}
