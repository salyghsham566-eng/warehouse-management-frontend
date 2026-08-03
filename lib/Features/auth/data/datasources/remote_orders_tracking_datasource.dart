import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/models/order_details_model.dart';

import '../models/tracked_order_model.dart';
import 'orders_tracking_datasource.dart';

class RemoteOrdersTrackingDataSource
    implements OrdersTrackingDataSource {
  final Dio dio;

  const RemoteOrdersTrackingDataSource({
    required this.dio,
  });

  @override
  Future<List<TrackedOrderModel>> getOrders() async {
    final response = await dio.get(
      ApiEndpoints.orders,
    );

    final ordersJson = _extractOrders(
      response.data,
    );

    return ordersJson.map((item) {
      if (item is! Map) {
        throw const FormatException(
          'بيانات إحدى الطلبيات غير صحيحة',
        );
      }

      return TrackedOrderModel.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  List<dynamic> _extractOrders(dynamic responseData) {
    if (responseData is List<dynamic>) {
      return responseData;
    }

    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];

      if (data is List<dynamic>) {
        return data;
      }

      if (data is Map<String, dynamic>) {
        final dynamic orders = data['orders'];

        if (orders is List<dynamic>) {
          return orders;
        }
      }

      final dynamic orders = responseData['orders'];

      if (orders is List<dynamic>) {
        return orders;
      }
    }

    throw const FormatException(
      'صيغة استجابة الطلبات غير صحيحة',
    );
  }
  @override
Future<OrderDetailsModel> getOrderDetails(
  String orderNumber,
) async {
  final response = await dio.get(
    '${ApiEndpoints.orders}/$orderNumber',
  );

  final dynamic responseData = response.data;

  final dynamic data = responseData is Map
      ? responseData['data']
      : null;

  if (data is! Map) {
    throw const FormatException(
      'بيانات تفاصيل الطلب غير صحيحة',
    );
  }

  return OrderDetailsModel.fromJson(
    Map<String, dynamic>.from(data),
  );
}
}