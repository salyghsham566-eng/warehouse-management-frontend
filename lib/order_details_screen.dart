import 'package:flutter/material.dart';
import 'package:project_2/orders_store.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailsScreen({super.key, required this.orderNumber});

  Map<String, dynamic>? _findOrder(List<Map<String, dynamic>> orders) {
    for (final order in orders) {
      final number = _orderNumber(order);

      if (number == orderNumber) {
        return order;
      }
    }

    return null;
  }

  String _orderNumber(Map<String, dynamic> order) {
    return order["orderNumber"]?.toString() ??
        order["order_number"]?.toString() ??
        order["orderNo"]?.toString() ??
        order["id"]?.toString() ??
        "غير محدد";
  }

  String _pharmacyName(Map<String, dynamic> order) {
    return order["pharmacyName"]?.toString() ??
        order["pharmacy_name"]?.toString() ??
        order["pharmacy"]?["name"]?.toString() ??
        "صيدلية غير محددة";
  }

  String _status(Map<String, dynamic> order) {
    return order["status"]?.toString() ?? "pending_review";
  }

  String _statusLabel(String status) {
    switch (status) {
      case "pending_review":
        return "قيد المعالجة";
      case "approved":
        return "معتمدة";
      case "rejected":
        return "مرفوضة";
      case "modified":
        return "تم التعديل";
      case "archived":
        return "مؤرشفة";
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "approved":
        return const Color(0xff169967);
      case "rejected":
        return const Color(0xffD83A3A);
      case "modified":
        return const Color(0xff276FBF);
      case "archived":
        return const Color(0xff7D8796);
      case "pending_review":
      default:
        return const Color(0xffE9A12C);
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case "approved":
        return const Color(0xffE8F8EF);
      case "rejected":
        return const Color(0xffFDECEC);
      case "modified":
        return const Color(0xffEAF2FD);
      case "archived":
        return const Color(0xffF0F2F5);
      case "pending_review":
      default:
        return const Color(0xffFFF4DF);
    }
  }

  DateTime _createdAt(Map<String, dynamic> order) {
    final value = order["createdAt"] ?? order["created_at"];

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value?.toString() ?? "") ?? DateTime.now();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, "0");
    final month = date.month.toString().padLeft(2, "0");

    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, "0");
    final period = date.hour >= 12 ? "م" : "ص";

    return "$day/$month/${date.year} - $hour12:$minute $period";
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

  List<Map<String, dynamic>> _items(Map<String, dynamic> order) {
    final dynamic items = order["items"];

    if (items is! List) {
      return [];
    }

    return items
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _itemsCount(Map<String, dynamic> order) {
    final count = order["itemsCount"] ?? order["items_count"];

    if (count != null) {
      return _toInt(count);
    }

    return _items(order).length;
  }

  double _total(Map<String, dynamic> order) {
    return _toDouble(order["total"]);
  }

  double _subtotal(Map<String, dynamic> order) {
    return _toDouble(order["subtotal"]);
  }

  double _discount(Map<String, dynamic> order) {
    return _toDouble(order["discount"]);
  }

  String _delegateNote(Map<String, dynamic> order) {
    return order["note"]?.toString() ??
        order["delegateNote"]?.toString() ??
        order["salesRepNote"]?.toString() ??
        "";
  }

  String _billerNote(Map<String, dynamic> order) {
    return order["billerNote"]?.toString() ??
        order["invoiceNote"]?.toString() ??
        order["accountantNote"]?.toString() ??
        order["reviewer_note"]?.toString() ??
        "";
  }

  String _rejectionReason(Map<String, dynamic> order) {
    return order["rejectionReason"]?.toString() ??
        order["reject_reason"]?.toString() ??
        order["reason"]?.toString() ??
        "";
  }

  String _medicineName(Map<String, dynamic> item) {
    return item["medicineName"]?.toString() ??
        item["medicine_name"]?.toString() ??
        item["name"]?.toString() ??
        "دواء";
  }

  String _companyName(Map<String, dynamic> item) {
    return item["companyName"]?.toString() ??
        item["company_name"]?.toString() ??
        item["company"]?.toString() ??
        "شركة غير محددة";
  }

  int _quantity(Map<String, dynamic> item) {
    return _toInt(item["quantity"]);
  }

  int _freeQuantity(Map<String, dynamic> item) {
    return _toInt(item["freeQuantity"] ?? item["free_quantity"]);
  }

  double _price(Map<String, dynamic> item) {
    return _toDouble(item["price"]);
  }

  double _discountPercent(Map<String, dynamic> item) {
    return _toDouble(item["discountPercent"] ?? item["discount_percent"]);
  }

  double _itemTotal(Map<String, dynamic> item) {
    return _toDouble(item["itemTotal"] ?? item["item_total"]);
  }

  String _offerSource(Map<String, dynamic> item) {
    return item["offerSource"]?.toString() ??
        item["offer_source"]?.toString() ??
        "لا يوجد عرض";
  }

  List<Map<String, dynamic>> _modifiedItems(Map<String, dynamic> order) {
    final dynamic directList =
        order["modifiedItems"] ?? order["modified_items"];

    if (directList is List) {
      return directList
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    final result = <Map<String, dynamic>>[];

    for (final item in _items(order)) {
      final originalQuantity =
          item["originalQuantity"] ?? item["original_quantity"];

      final modifiedQuantity =
          item["modifiedQuantity"] ?? item["modified_quantity"];

      if (originalQuantity != null || modifiedQuantity != null) {
        result.add(item);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: OrdersStore.instance.ordersNotifier,
      builder: (context, orders, child) {
        final order = _findOrder(orders);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xffF5F7FC),
            appBar: AppBar(
              title: const Text(
                "تفاصيل الطلبية",
                style: TextStyle(
                  color: Color(0xff0A2954),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff0A2954),
              surfaceTintColor: Colors.white,
              elevation: 0,
            ),
            body: order == null
                ? _buildNotFound(context)
                : _buildDetails(order),
          ),
        );
      },
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 75,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            const Text(
              "لم يتم العثور على الطلبية",
              style: TextStyle(
                color: Color(0xff0A2954),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "قد تكون البيانات غير محفوظة بعد إعادة تشغيل التطبيق.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("رجوع"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> order) {
    final status = _status(order);
    final items = _items(order);
    final delegateNote = _delegateNote(order);
    final billerNote = _billerNote(order);
    final rejectionReason = _rejectionReason(order);
    final modifiedItems = _modifiedItems(order);

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      children: [
        _buildHeaderCard(order),
        const SizedBox(height: 12),
        _buildSummaryCards(order),
        const SizedBox(height: 12),

        if (delegateNote.isNotEmpty)
          _buildNoteCard(
            title: "ملاحظات المندوب",
            text: delegateNote,
            icon: Icons.edit_note_outlined,
            color: const Color(0xff0A2954),
            background: const Color(0xffEEF3FF),
          ),

        if (billerNote.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildNoteCard(
            title: "ملاحظات المفوتر",
            text: billerNote,
            icon: Icons.account_balance_wallet_outlined,
            color: const Color(0xff276FBF),
            background: const Color(0xffEAF2FD),
          ),
        ],

        if (status == "rejected") ...[
          const SizedBox(height: 10),
          _buildNoteCard(
            title: "سبب الرفض",
            text: rejectionReason.isEmpty
                ? "لم يتم إدخال سبب الرفض بعد."
                : rejectionReason,
            icon: Icons.cancel_outlined,
            color: const Color(0xffD83A3A),
            background: const Color(0xffFDECEC),
          ),
        ],

        if (status == "modified") ...[
          const SizedBox(height: 10),
          _buildModifiedSection(modifiedItems),
        ],

        const SizedBox(height: 16),

        _buildSectionTitle(title: "الأصناف", count: items.length),

        const SizedBox(height: 10),

        ...items.map((item) => _buildItemCard(item)),

        const SizedBox(height: 8),

        _buildTotalsCard(order),
      ],
    );
  }

  Widget _buildHeaderCard(Map<String, dynamic> order) {
    final status = _status(order);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE2E7EF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "طلبية #${_orderNumber(order)}",
                  style: const TextStyle(
                    color: Color(0xff0A2954),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(status),
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.local_pharmacy_outlined,
            title: "الصيدلية",
            value: _pharmacyName(order),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: "تاريخ الإرسال",
            value: _formatDate(_createdAt(order)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: _statusColor(status),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xffEEF3FF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xff0A2954), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xff7D8796), fontSize: 10),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xff1A2F4D),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> order) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallInfoCard(
            title: "عدد الأصناف",
            value: "${_itemsCount(order)}",
            icon: Icons.medication_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSmallInfoCard(
            title: "القيمة",
            value: "${_total(order).toStringAsFixed(2)} ر.س",
            icon: Icons.payments_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE2E7EF)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff0A2954), size: 23),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Color(0xff7D8796), fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard({
    required String title,
    required String text,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xff1A2F4D),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModifiedSection(List<Map<String, dynamic>> modifiedItems) {
    if (modifiedItems.isEmpty) {
      return _buildNoteCard(
        title: "الأصناف المعدلة",
        text: "تم تعديل الطلبية، وستظهر تفاصيل التعديل بعد ربط المفوتر.",
        icon: Icons.edit_outlined,
        color: const Color(0xff276FBF),
        background: const Color(0xffEAF2FD),
      );
    }

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xffEAF2FD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xff276FBF).withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_outlined, color: Color(0xff276FBF)),
              SizedBox(width: 8),
              Text(
                "الأصناف والكميات المعدلة",
                style: TextStyle(
                  color: Color(0xff276FBF),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...modifiedItems.map((item) {
            final oldQuantity =
                item["originalQuantity"] ?? item["original_quantity"] ?? "-";

            final newQuantity =
                item["modifiedQuantity"] ??
                item["modified_quantity"] ??
                item["quantity"] ??
                "-";

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _medicineName(item),
                      style: const TextStyle(
                        color: Color(0xff1A2F4D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "$oldQuantity ← $newQuantity",
                    style: const TextStyle(
                      color: Color(0xff276FBF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required int count}) {
    return Row(
      children: [
        const Icon(Icons.inventory_2_outlined, color: Color(0xff0A2954)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff0A2954),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          "$count صنف",
          style: const TextStyle(color: Color(0xff60758F), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final quantity = _quantity(item);
    final freeQuantity = _freeQuantity(item);
    final price = _price(item);
    final discount = _discountPercent(item);
    final total = _itemTotal(item);
    final offerSource = _offerSource(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE2E7EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _medicineName(item),
            style: const TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "الشركة: ${_companyName(item)}",
            style: const TextStyle(color: Color(0xff60758F), fontSize: 11),
          ),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: _buildItemValue(title: "الكمية", value: "$quantity"),
              ),
              Expanded(
                child: _buildItemValue(
                  title: "السعر",
                  value: "${price.toStringAsFixed(2)}",
                ),
              ),
              Expanded(
                child: _buildItemValue(
                  title: "الحسم",
                  value: "${discount.toStringAsFixed(0)}%",
                  valueColor: discount > 0 ? const Color(0xff169967) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildItemValue(
                  title: "مجاني",
                  value: "$freeQuantity",
                  valueColor: freeQuantity > 0 ? const Color(0xff169967) : null,
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildItemValue(
                  title: "مصدر العرض",
                  value: offerSource,
                  valueColor: freeQuantity > 0 ? const Color(0xff169967) : null,
                ),
              ),
            ],
          ),
          const Divider(height: 22),
          Row(
            children: [
              const Text(
                "إجمالي الصنف",
                style: TextStyle(color: Color(0xff53657E), fontSize: 11),
              ),
              const Spacer(),
              Text(
                "${total.toStringAsFixed(2)} ر.س",
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
          style: const TextStyle(color: Color(0xff8B96A8), fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ?? const Color(0xff1A2F4D),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsCard(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE2E7EF)),
      ),
      child: Column(
        children: [
          _buildTotalRow(
            title: "الإجمالي قبل الحسم",
            value: "${_subtotal(order).toStringAsFixed(2)} ر.س",
          ),
          _buildTotalRow(
            title: "قيمة الحسم",
            value: "- ${_discount(order).toStringAsFixed(2)} ر.س",
            valueColor: const Color(0xff169967),
          ),
          const Divider(height: 22),
          _buildTotalRow(
            title: "الإجمالي النهائي",
            value: "${_total(order).toStringAsFixed(2)} ر.س",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow({
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
              color: valueColor ?? const Color(0xff0A2954),
              fontSize: isTotal ? 16 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
