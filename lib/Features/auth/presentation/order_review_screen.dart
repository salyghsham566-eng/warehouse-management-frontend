import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/order_bloc.dart';
import 'package:project_2/Features/auth/bloc/order_event.dart';
import 'package:project_2/Features/auth/bloc/order_state.dart';
import 'package:project_2/Features/auth/data/models/order_item_model.dart';
import 'package:project_2/Features/auth/data/models/order_request_model.dart';
import 'package:project_2/Features/auth/domain/repositories/order_repository.dart';
import 'package:project_2/Features/auth/presentation/order_success_screen.dart';
import 'package:project_2/orders_store.dart';

class OrderReviewScreen extends StatefulWidget {
  final Map<String, dynamic> pharmacy;
  final List<Map<String, dynamic>> cartItems;
  final String initialNote;
  final VoidCallback? onOrderSent;

  const OrderReviewScreen({
    super.key,
    required this.pharmacy,
    required this.cartItems,
    this.initialNote = "",
    this.onOrderSent,
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  final TextEditingController noteController = TextEditingController();

  late List<Map<String, dynamic>> reviewItems;
  late final OrderBloc _orderBloc;

  bool isSending = false;

 @override
void initState() {
  super.initState();

  _orderBloc = sl<OrderBloc>();

  reviewItems = widget.cartItems
      .map((item) => Map<String, dynamic>.from(item))
      .toList();

  debugPrint('===== CART ITEMS =====');
  debugPrint(reviewItems.toString());

  for (final item in reviewItems) {
    debugPrint(
      'المنتج: ${item['name']} - id: ${item['id']}',
    );
  }

  noteController.text = widget.initialNote;
}
  

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "") ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  int _getQuantity(Map<String, dynamic> item) {
    final quantity = _toInt(item["quantity"]);

    return quantity <= 0 ? 1 : quantity;
  }

  double _getPrice(Map<String, dynamic> item) {
    return _toDouble(item["price"]);
  }

  double _getDiscountPercent(Map<String, dynamic> item) {
    return _toDouble(item["discountPercent"]);
  }

  int _getFreeQuantity(Map<String, dynamic> item) {
    final dynamic offer = item["basicOffer"];

    if (offer is! Map) {
      return _toInt(item["freeQuantity"]);
    }

    final int buyQuantity = _toInt(offer["buyQuantity"]);

    final int freeQuantity = _toInt(offer["freeQuantity"]);

    final int quantity = _getQuantity(item);

    if (buyQuantity <= 0) {
      return 0;
    }

    final int offerCount = quantity ~/ buyQuantity;

    return offerCount * freeQuantity;
  }

  String _getOfferSource(Map<String, dynamic> item) {
    final int freeQuantity = _getFreeQuantity(item);

    if (freeQuantity <= 0) {
      return "لا يوجد عرض";
    }

    return item["offerSource"]?.toString() ?? "عرض صنف أساسي";
  }

  double _getItemSubtotal(Map<String, dynamic> item) {
    return _getPrice(item) * _getQuantity(item);
  }

  double _getItemDiscount(Map<String, dynamic> item) {
    final subtotal = _getItemSubtotal(item);

    final discountPercent = _getDiscountPercent(item);

    return subtotal * (discountPercent / 100);
  }

  double _getItemTotal(Map<String, dynamic> item) {
    return _getItemSubtotal(item) - _getItemDiscount(item);
  }

  double get subtotal {
    return reviewItems.fold<double>(
      0,
      (sum, item) => sum + _getItemSubtotal(item),
    );
  }

  double get totalDiscount {
    return reviewItems.fold<double>(
      0,
      (sum, item) => sum + _getItemDiscount(item),
    );
  }

  double get finalTotal {
    return subtotal - totalDiscount;
  }

  int get totalPaidQuantity {
    return reviewItems.fold<int>(0, (sum, item) => sum + _getQuantity(item));
  }

  int get totalFreeQuantity {
    return reviewItems.fold<int>(
      0,
      (sum, item) => sum + _getFreeQuantity(item),
    );
  }

  void _increaseQuantity(int index) {
    setState(() {
      final currentQuantity = _getQuantity(reviewItems[index]);

      reviewItems[index]["quantity"] = currentQuantity + 1;
    });
  }

  void _decreaseQuantity(int index) {
    final currentQuantity = _getQuantity(reviewItems[index]);

    if (currentQuantity <= 1) {
      return;
    }

    setState(() {
      reviewItems[index]["quantity"] = currentQuantity - 1;
    });
  }

  void _deleteItem(int index) {
    final deletedName = reviewItems[index]["name"]?.toString() ?? "الصنف";

    setState(() {
      reviewItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("تم حذف $deletedName من الطلبية")));
  }

  Map<String, dynamic> _getReviewResult() {
    return {
      "items": reviewItems
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      "note": noteController.text,
    };
  }

  void _returnToCart() {
    Navigator.pop(context, _getReviewResult());
  }
Map<String, dynamic> _buildStoredOrder({
  required String orderNumber,
  required DateTime sentAt,
}) {
  return {
    'orderNumber': orderNumber,
    'pharmacyId': widget.pharmacy['id'],
    'pharmacyName':
        widget.pharmacy['name']?.toString() ??
        'صيدلية غير محددة',
    'pharmacy': Map<String, dynamic>.from(
      widget.pharmacy,
    ),
    'status': 'pending_review',
    'note': noteController.text.trim(),
    'items': reviewItems.map((item) {
      return {
        'medicineId': item['id'],
        'medicineName':
            item['name']?.toString() ?? '',
        'companyId': item['companyId'],
        'companyName':
            item['company']?.toString() ??
            item['companyName']?.toString() ??
            '',
        'quantity': _getQuantity(item),
        'price': _getPrice(item),
        'discountPercent':
            _getDiscountPercent(item),
        'freeQuantity': _getFreeQuantity(item),
        'offerSource': _getOfferSource(item),
        'subtotal': _getItemSubtotal(item),
        'discountValue': _getItemDiscount(item),
        'itemTotal': _getItemTotal(item),
      };
    }).toList(),
    'itemsCount': reviewItems.length,
    'paidQuantity': totalPaidQuantity,
    'freeQuantity': totalFreeQuantity,
    'subtotal': subtotal,
    'discount': totalDiscount,
    'total': finalTotal,
    'createdAt': sentAt.toIso8601String(),
  };
}
  Future<void> _sendOrder() async {
    if (reviewItems.isEmpty) {
      _showMessage("لا يمكن إرسال طلبية فارغة");
      return;
    }

    if (isSending) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("تأكيد إرسال الطلبية"),
            content: Text(
              "هل أنت متأكد من إرسال الطلبية إلى "
              "${widget.pharmacy["name"]}؟\n\n"
              "بعد الإرسال لن تتمكن من تعديلها "
              "إلا إذا رفضها المفوتر.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0A2954),
                  foregroundColor: Colors.white,
                ),
                child: const Text("تأكيد الإرسال"),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }
final int pharmacyId = _toInt(
  widget.pharmacy['id'],
);

if (pharmacyId <= 0) {
  _showMessage('يجب اختيار صيدلية صحيحة');
  return;
}

final List<OrderItemModel> orderItems =
    reviewItems.map((item) {
  return OrderItemModel(
    productId: _toInt(
  item['id'] ??
      item['product_id'] ??
      item['productId'] ??
      item['medicineId'],
),
    quantity: _getQuantity(item),
    price: _getPrice(item),
  );
}).toList();

final bool hasInvalidProduct = orderItems.any(
  (item) => item.productId <= 0,
);

if (hasInvalidProduct) {
  _showMessage(
    'يوجد صنف بدون رقم معرّف صحيح',
  );
  return;
}

setState(() {
  isSending = true;
});

final orderRequest = OrderRequestModel(
  pharmacyId: pharmacyId,
  items: orderItems,
  totalAmount: finalTotal,
  notes: noteController.text.trim(),
);

_orderBloc.add(
  SendOrderEvent(
    order: orderRequest,
  ),
);
    
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

 @override
void dispose() {
  noteController.dispose();
  _orderBloc.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>.value(
  value: _orderBloc,
  child: BlocListener<OrderBloc, OrderState>(
    listener: (context, state) {
      if (state is OrderSending) {
        if (!isSending) {
          setState(() {
            isSending = true;
          });
        }
      }

      if (state is OrderFailure) {
        setState(() {
          isSending = false;
        });

        _showMessage(state.message);
      }

      if (state is OrderSuccess) {
        final DateTime sentAt = DateTime.now();

        final storedOrder = _buildStoredOrder(
          orderNumber: state.orderNumber,
          sentAt: sentAt,
        );

        OrdersStore.instance.addOrder(
          storedOrder,
        );

        widget.onOrderSent?.call();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              orderNumber: state.orderNumber,
              pharmacyName:
                  widget.pharmacy['name']
                          ?.toString() ??
                      'صيدلية غير محددة',
              sentAt: sentAt,
            ),
          ),
          (route) => route.isFirst,
        );
      }
    },
      child: WillPopScope(
        onWillPop: () async {
          _returnToCart();
          return false;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xffF5F7FC),
            appBar: AppBar(
              title: const Text(
                "مراجعة الطلبية",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff0A2954),
              surfaceTintColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: _returnToCart,
                icon: const Icon(Icons.arrow_back, color: Color(0xff0A2954)),
              ),
            ),
            body: reviewItems.isEmpty
                ? _buildEmptyReview()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    children: [
                      _buildPharmacyCard(),
                      const SizedBox(height: 16),
                      _buildSectionTitle(),
                      const SizedBox(height: 10),
                      ...List.generate(reviewItems.length, (index) {
                        return _buildMedicineCard(reviewItems[index], index);
                      }),
                      const SizedBox(height: 4),
                      _buildNoteCard(),
                      const SizedBox(height: 12),
                      _buildOrderSummary(),
                    ],
                  ),
            bottomNavigationBar: _buildBottomButton(),
          ),
        ),
      ),),
    );
  }

  Widget _buildPharmacyCard() {
    final String pharmacyName =
        widget.pharmacy["name"]?.toString() ?? "صيدلية غير محددة";

    final String branch = widget.pharmacy["branch"]?.toString() ?? "";

    final String address =
        widget.pharmacy["address"]?.toString() ??
        widget.pharmacy["area"]?.toString() ??
        "";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffEEF3FF),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffDCE5F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xff0A2954),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "الصيدلية المختارة",
                  style: TextStyle(color: Color(0xff6C7A91), fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  branch.isEmpty ? pharmacyName : "$pharmacyName - $branch",
                  style: const TextStyle(
                    color: Color(0xff1A2F4D),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Color(0xff60758F),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Icon(Icons.fact_check_outlined, color: Color(0xff0A2954)),
        const SizedBox(width: 8),
        const Text(
          "الأصناف",
          style: TextStyle(
            color: Color(0xff0A2954),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          "${reviewItems.length} صنف",
          style: const TextStyle(color: Color(0xff60758F), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> item, int index) {
    final int quantity = _getQuantity(item);

    final int freeQuantity = _getFreeQuantity(item);

    final double price = _getPrice(item);

    final double discount = _getDiscountPercent(item);

    final double itemTotal = _getItemTotal(item);

    final String imagePath = item["image"]?.toString() ?? "";

    final String companyName =
        item["company"]?.toString() ??
        item["companyName"]?.toString() ??
        "شركة غير محددة";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5EAF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 65,
                height: 72,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F6F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imagePath.isEmpty
                    ? const Icon(
                        Icons.medication_outlined,
                        color: Color(0xff4F8B8A),
                        size: 36,
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.medication_outlined,
                            color: Color(0xff4F8B8A),
                            size: 36,
                          );
                        },
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"]?.toString() ?? "دواء",
                      style: const TextStyle(
                        color: Color(0xff1A2F4D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "الشركة: $companyName",
                      style: const TextStyle(
                        color: Color(0xff60758F),
                        fontSize: 11,
                      ),
                    ),
                    if (item["scientificName"]?.toString().isNotEmpty ==
                        true) ...[
                      const SizedBox(height: 4),
                      Text(
                        item["scientificName"].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff60758F),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _deleteItem(index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xffD83A3A),
                ),
              ),
            ],
          ),
          const Divider(height: 22, color: Color(0xffE8ECF2)),
          Row(
            children: [
              Expanded(
                child: _buildItemValue(
                  title: "سعر الوحدة",
                  value: "${price.toStringAsFixed(2)} ر.س",
                ),
              ),
              Expanded(
                child: _buildItemValue(
                  title: "الحسم",
                  value: "${discount.toStringAsFixed(0)}%",
                  valueColor: discount > 0 ? const Color(0xff169967) : null,
                ),
              ),
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffEEF3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _decreaseQuantity(index);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 36,
                      ),
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xff0A2954),
                        size: 19,
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        "$quantity",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff0A2954),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _increaseQuantity(index);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 36,
                      ),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xff0A2954),
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: freeQuantity > 0
                  ? const Color(0xffE8F8EF)
                  : const Color(0xffF5F6F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  freeQuantity > 0
                      ? Icons.card_giftcard
                      : Icons.remove_circle_outline,
                  size: 17,
                  color: freeQuantity > 0
                      ? const Color(0xff169967)
                      : const Color(0xff7D8796),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    freeQuantity > 0
                        ? "مجاني: $freeQuantity عبوة — المصدر: ${_getOfferSource(item)}"
                        : "لا توجد كمية مجانية لهذا الصنف",
                    style: TextStyle(
                      color: freeQuantity > 0
                          ? const Color(0xff169967)
                          : const Color(0xff7D8796),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              const Text(
                "إجمالي الصنف بعد الحسم",
                style: TextStyle(color: Color(0xff53657E), fontSize: 11),
              ),
              const Spacer(),
              Text(
                "${itemTotal.toStringAsFixed(2)} ر.س",
                style: const TextStyle(
                  color: Color(0xff0A2954),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemValue({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xff7D8796), fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xff1A2F4D),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE5EAF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ملاحظة للمفوتر",
            style: TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "اكتب أي ملاحظة تخص الطلبية...",
              hintStyle: const TextStyle(
                color: Color(0xff9AA5B5),
                fontSize: 11,
              ),
              filled: true,
              fillColor: const Color(0xffF6F8FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE5EAF1)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            title: "عدد الأصناف",
            value: "${reviewItems.length} صنف",
          ),
          _buildSummaryRow(
            title: "الكميات المدفوعة",
            value: "$totalPaidQuantity عبوة",
          ),
          _buildSummaryRow(
            title: "الكميات المجانية",
            value: "$totalFreeQuantity عبوة",
            valueColor: const Color(0xff169967),
          ),
          const Divider(height: 22),
          _buildSummaryRow(
            title: "الإجمالي قبل الحسم",
            value: "${subtotal.toStringAsFixed(2)} ر.س",
          ),
          _buildSummaryRow(
            title: "قيمة الحسم",
            value: "- ${totalDiscount.toStringAsFixed(2)} ر.س",
            valueColor: const Color(0xff169967),
          ),
          const Divider(height: 22),
          _buildSummaryRow(
            title: "الإجمالي بعد الحسم",
            value: "${finalTotal.toStringAsFixed(2)} ر.س",
            isTotal: true,
            valueColor: const Color(0xff0A2954),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xff53657E),
              fontSize: isTotal ? 13 : 11,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xff1A2F4D),
              fontSize: isTotal ? 16 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffE3E8F0))),
          boxShadow: [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: isSending || reviewItems.isEmpty ? null : _sendOrder,
            icon: isSending
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(
              isSending ? "جارٍ إرسال الطلبية..." : "تأكيد وإرسال الطلبية",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0A2954),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xff8897AA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyReview() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_checkout_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            "لا توجد أصناف للمراجعة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("العودة إلى السلة"),
          ),
        ],
      ),
    );
  }
}
