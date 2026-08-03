class OrderResponseModel {
  final String orderNumber;
  final String message;

  const OrderResponseModel({
    required this.orderNumber,
    required this.message,
  });

  factory OrderResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderResponseModel(
      orderNumber:
          (json['order_number'] ?? json['orderNumber'])
                  ?.toString() ??
              '',
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_number': orderNumber,
      'message': message,
    };
  }
}