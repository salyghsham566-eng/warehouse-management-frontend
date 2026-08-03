import 'order_item_model.dart';

class OrderRequestModel {
  final int pharmacyId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String? notes;

  const OrderRequestModel({
    required this.pharmacyId,
    required this.items,
    required this.totalAmount,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'pharmacy_id': pharmacyId,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      if (notes != null && notes!.trim().isNotEmpty)
        'notes': notes!.trim(),
    };
  }
}