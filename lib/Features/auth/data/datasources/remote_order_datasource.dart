import 'package:dio/dio.dart';
import 'package:project_2/Core/network/api_endpoints.dart';

import '../models/order_request_model.dart';
import '../models/order_response_model.dart';
import 'order_datasource.dart';

class RemoteOrderDataSource implements OrderDataSource {
  final Dio dio;

  const RemoteOrderDataSource({
    required this.dio,
  });

  @override
  Future<OrderResponseModel> sendOrder(
    OrderRequestModel order,
  ) async {
    final response = await dio.post(
      ApiEndpoints.orders,
      data: order.toJson(),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'صيغة استجابة إرسال الطلب غير صحيحة',
      );
    }

    final dynamic rawData = responseData['data'];

    if (rawData is Map<String, dynamic>) {
      return OrderResponseModel.fromJson({
        ...rawData,
        'message':
            responseData['message'] ??
            rawData['message'] ??
            '',
      });
    }

    // يدعم أيضًا Response بدون data.
    return OrderResponseModel.fromJson(responseData);
  }
}