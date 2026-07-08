import 'package:flutter/material.dart';
import 'package:project_2/order_details_screen.dart';
import 'package:project_2/orders_store.dart';

class OrdersTrackingScreen extends StatefulWidget {


  const OrdersTrackingScreen({
    super.key,
  
  });

  @override
  State<OrdersTrackingScreen> createState() =>
      _OrdersTrackingScreenState();
}

class _OrdersTrackingScreenState
    extends State<OrdersTrackingScreen> {
  String selectedStatus = "all";

  DateTimeRange? selectedDateRange;

  late List<Map<String, dynamic>> orders;

  final Map<String, String> statusLabels = const {
    "all": "الكل",
    "pending_review": "بانتظار المراجعة",
    "approved": "معتمدة",
    "rejected": "مرفوضة",
    "modified": "تم التعديل",
    "archived": "مؤرشفة",
  };



  

 

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  DateTime _orderDate(Map<String, dynamic> order) {
    final dynamic value =
        order["createdAt"] ?? order["created_at"];

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
          value?.toString() ?? "",
        ) ??
        DateTime.now();
  }

  String _orderNumber(Map<String, dynamic> order) {
    return order["orderNumber"]?.toString() ??
        order["order_number"]?.toString() ??
        order["id"]?.toString() ??
        "غير محدد";
  }

  String _pharmacyName(Map<String, dynamic> order) {
    return order["pharmacyName"]?.toString() ??
        order["pharmacy_name"]?.toString() ??
        order["pharmacy"]?["name"]?.toString() ??
        "صيدلية غير محددة";
  }

  int _itemsCount(Map<String, dynamic> order) {
    final dynamic count =
        order["itemsCount"] ?? order["items_count"];

    if (count != null) {
      return _toInt(count);
    }

    final dynamic items = order["items"];

    if (items is List) {
      return items.length;
    }

    return 0;
  }


List<Map<String, dynamic>> _filteredOrders(
  List<Map<String, dynamic>> orders,
) {
  final List<Map<String, dynamic>> result =
      orders.where((order) {
    final String status =
        order["status"]?.toString() ?? "";

    if (selectedStatus != "all" &&
        status != selectedStatus) {
      return false;
    }

    if (selectedDateRange != null) {
      final DateTime date = _orderDate(order);

      final DateTime start = DateTime(
        selectedDateRange!.start.year,
        selectedDateRange!.start.month,
        selectedDateRange!.start.day,
      );

      final DateTime end = DateTime(
        selectedDateRange!.end.year,
        selectedDateRange!.end.month,
        selectedDateRange!.end.day,
        23,
        59,
        59,
      );

      if (date.isBefore(start) ||
          date.isAfter(end)) {
        return false;
      }
    }

    return true;
  }).toList();

  result.sort(
    (first, second) => _orderDate(second)
        .compareTo(_orderDate(first)),
  );

  return result;
}

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();

    final DateTimeRange? result =
        await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1),
      initialDateRange: selectedDateRange,
      helpText: "اختيار فترة الطلبات",
      cancelText: "إلغاء",
      confirmText: "تطبيق",
      saveText: "حفظ",
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedDateRange = result;
    });
  }

  String _formatDate(DateTime date) {
    final String day =
        date.day.toString().padLeft(2, "0");

    final String month =
        date.month.toString().padLeft(2, "0");

    return "$day/$month/${date.year}";
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

  String _statusLabel(String status) {
    return statusLabels[status] ?? status;
  }

  void _openOrderDetails(
  Map<String, dynamic> order,
) {
  final String number =
      _orderNumber(order);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderDetailsScreen(
        orderNumber: number,
      ),
    ),
  );
}

 @override
Widget build(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: const Color(0xffF5F7FC),
      appBar: AppBar(
        title: const Text(
          "متابعة الطلبات",
          style: TextStyle(
            color: Color(0xff0A2954),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xff0A2954),
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder<
          List<Map<String, dynamic>>>(
        valueListenable:
            OrdersStore.instance.ordersNotifier,
        builder: (
          context,
          orders,
          child,
        ) {
          final visibleOrders =
              _filteredOrders(orders);

          return Column(
            children: [
              _buildFilters(),
              _buildDateFilter(),
              _buildResultHeader(
                visibleOrders.length,
              ),
              Expanded(
                child: visibleOrders.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(
                          12,
                          4,
                          12,
                          20,
                        ),
                        itemCount:
                            visibleOrders.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return _buildOrderCard(
                            visibleOrders[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: statusLabels.length,
          separatorBuilder: (
            context,
            index,
          ) {
            return const SizedBox(width: 7);
          },
          itemBuilder: (context, index) {
            final String status =
                statusLabels.keys.elementAt(index);

            final bool selected =
                selectedStatus == status;

            return ChoiceChip(
              selected: selected,
              label: Text(
                statusLabels[status]!,
              ),
              onSelected: (_) {
                setState(() {
                  selectedStatus = status;
                });
              },
              selectedColor:
                  const Color(0xff0A2954),
              backgroundColor:
                  const Color(0xffEEF3FF),
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xff53657E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              showCheckmark: false,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    final String dateText;

    if (selectedDateRange == null) {
      dateText = "تحديد فترة من / إلى تاريخ";
    } else {
      dateText =
          "${_formatDate(selectedDateRange!.start)}"
          " - "
          "${_formatDate(selectedDateRange!.end)}";
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        12,
      ),
      child: InkWell(
        onTap: _selectDateRange,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffF6F8FC),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: const Color(0xffE2E7EF),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: Color(0xff0A2954),
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  dateText,
                  style: const TextStyle(
                    color: Color(0xff53657E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selectedDateRange != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDateRange = null;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xffD83A3A),
                    size: 18,
                  ),
                )
              else
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff7D8796),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        8,
      ),
      child: Row(
        children: [
          const Text(
            "الطلبات",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            "$count طلبية",
            style: const TextStyle(
              color: Color(0xff60758F),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
  ) {
    final String status =
        order["status"]?.toString() ??
            "pending_review";

    final DateTime createdAt =
        _orderDate(order);

    final double total =
        _toDouble(order["total"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE2E7EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _openOrderDetails(order);
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "طلب #${_orderNumber(order)}",
                          style: const TextStyle(
                            color:
                                Color(0xff0A2954),
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _pharmacyName(order),
                          style: const TextStyle(
                            color:
                                Color(0xff53657E),
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const Divider(
                height: 24,
                color: Color(0xffE8ECF2),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildOrderValue(
                      icon:
                          Icons.calendar_today_outlined,
                      title: "التاريخ",
                      value:
                          _formatDate(createdAt),
                    ),
                  ),
                  Expanded(
                    child: _buildOrderValue(
                      icon:
                          Icons.medication_outlined,
                      title: "عدد الأصناف",
                      value:
                          "${_itemsCount(order)} أصناف",
                    ),
                  ),
                  Expanded(
                    child: _buildOrderValue(
                      icon:
                          Icons.payments_outlined,
                      title: "القيمة",
                      value:
                          "${total.toStringAsFixed(2)} ر.س",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: _statusColor(status),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderValue({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xff60758F),
          size: 18,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff8B96A8),
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff1A2F4D),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              "لا توجد طلبات مطابقة",
              style: TextStyle(
                color: Color(0xff0A2954),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "جرّبي تغيير الحالة أو الفترة المحددة",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff7D8796),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}