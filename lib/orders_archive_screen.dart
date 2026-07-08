import 'package:flutter/material.dart';
import 'package:project_2/order_details_screen.dart';
import 'package:project_2/orders_store.dart';

enum ArchiveFilter { all, today, week, month, selectedDate }

class OrdersArchiveScreen extends StatefulWidget {
  const OrdersArchiveScreen({super.key});

  @override
  State<OrdersArchiveScreen> createState() => _OrdersArchiveScreenState();
}

class _OrdersArchiveScreenState extends State<OrdersArchiveScreen> {
  static const Color navyColor = Color(0xFF071F49);
  static const Color backgroundColor = Color(0xFFF5F6FA);

  final TextEditingController searchController = TextEditingController();

  ArchiveFilter selectedFilter = ArchiveFilter.all;
  DateTime? selectedDate;

  // بيانات مؤقتة فقط حتى يظهر تصميم الواجهة.
  // لاحقاً عند الربط نحذفها ونضع الطلبات القادمة من الباك.

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ArchiveOrder> _filterOrders(List<Map<String, dynamic>> storedOrders) {
    final now = DateTime.now();
    final searchText = searchController.text.trim().toLowerCase();

    final orders = storedOrders
        .map((order) => ArchiveOrder.fromMap(order))
        .toList();

    final result = orders.where((order) {
      bool matchesDate = true;

      switch (selectedFilter) {
        case ArchiveFilter.all:
          matchesDate = true;
          break;

        case ArchiveFilter.today:
          matchesDate = _isSameDay(order.date, now);
          break;

        case ArchiveFilter.week:
          final weekAgo = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 6));

          final orderDate = DateTime(
            order.date.year,
            order.date.month,
            order.date.day,
          );

          matchesDate = !orderDate.isBefore(weekAgo) && !orderDate.isAfter(now);
          break;

        case ArchiveFilter.month:
          matchesDate =
              order.date.year == now.year && order.date.month == now.month;
          break;

        case ArchiveFilter.selectedDate:
          matchesDate =
              selectedDate != null && _isSameDay(order.date, selectedDate!);
          break;
      }

      final matchesSearch =
          searchText.isEmpty ||
          order.orderNumber.toLowerCase().contains(searchText) ||
          order.pharmacyName.toLowerCase().contains(searchText);

      return matchesDate && matchesSearch;
    }).toList();

    result.sort((first, second) => second.date.compareTo(first.date));

    return result;
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ الطلبات',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (pickedDate == null) return;

    setState(() {
      selectedDate = pickedDate;
      selectedFilter = ArchiveFilter.selectedDate;
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toStringAsFixed(0);
    }

    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: navyColor,
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            'أرشيف الطلبات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: _buildSearchField(),
            ),
            _buildFilters(),
            const SizedBox(height: 5),
            Expanded(
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: OrdersStore.instance.ordersNotifier,
                builder: (context, storedOrders, child) {
                  final visibleOrders = _filterOrders(storedOrders);

                  if (visibleOrders.isEmpty) {
                    return const _EmptyOrdersWidget();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
                    itemCount: visibleOrders.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final order = visibleOrders[index];

                      return _OrderArchiveCard(
                        order: order,
                        formatDate: _formatDate,
                        formatAmount: _formatAmount,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(
                                orderNumber: order.orderNumber,
                              ),
                            ),
                          );
                          // لاحقاً نفتح تفاصيل الطلبية.
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'رقم الطلب أو اسم الصيدلية...',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close, size: 19),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: navyColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _filterButton(title: 'الكل', filter: ArchiveFilter.all),
          _filterButton(title: 'اليوم', filter: ArchiveFilter.today),
          _filterButton(title: 'الأسبوع', filter: ArchiveFilter.week),
          _filterButton(title: 'الشهر', filter: ArchiveFilter.month),
          _filterButton(
            title: selectedDate == null
                ? 'اختر تاريخ'
                : _formatDate(selectedDate!),
            filter: ArchiveFilter.selectedDate,
            icon: Icons.calendar_month_outlined,
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String title,
    required ArchiveFilter filter,
    IconData? icon,
  }) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (filter == ArchiveFilter.selectedDate) {
            _pickDate();
            return;
          }

          setState(() {
            selectedFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? navyColor : const Color(0xFFE7ECF4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 17,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchiveOrder {
  final String orderNumber;
  final String pharmacyName;
  final DateTime date;
  final int itemsCount;
  final double totalAmount;
  final OrderArchiveStatus status;

  const ArchiveOrder({
    required this.orderNumber,
    required this.pharmacyName,
    required this.date,
    required this.itemsCount,
    required this.totalAmount,
    required this.status,
  });

  factory ArchiveOrder.fromMap(Map<String, dynamic> map) {
    final items = map['items'];

    return ArchiveOrder(
      orderNumber:
          map['orderNumber']?.toString() ??
          map['orderNo']?.toString() ??
          map['id']?.toString() ??
          'بدون رقم',

      pharmacyName:
          map['pharmacyName']?.toString() ??
          map['pharmacy']?.toString() ??
          'صيدلية غير محددة',

      date: _parseDate(map['date'] ?? map['createdAt']),

      itemsCount: map['itemsCount'] is num
          ? (map['itemsCount'] as num).toInt()
          : items is List
          ? items.length
          : 0,

      totalAmount: map['totalAmount'] is num
          ? (map['totalAmount'] as num).toDouble()
          : map['total'] is num
          ? (map['total'] as num).toDouble()
          : 0,

      status: _parseStatus(map['status']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  static OrderArchiveStatus _parseStatus(dynamic value) {
    final status = value?.toString().toLowerCase();

    switch (status) {
      case 'approved':
      case 'معتمد':
        return OrderArchiveStatus.approved;

      case 'rejected':
      case 'مرفوض':
        return OrderArchiveStatus.rejected;

      case 'archived':
      case 'مؤرشف':
        return OrderArchiveStatus.archived;

      case 'modified':
      case 'تم التعديل':
        return OrderArchiveStatus.modified;

      case 'pending_review':
      case 'processing':
      case 'بانتظار المراجعة':
      case 'قيد المعالجة':
      default:
        return OrderArchiveStatus.pendingReview;
    }
  }
}

class _OrderInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _OrderInfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 9)),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF071F49),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EmptyOrdersWidget extends StatelessWidget {
  const _EmptyOrdersWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 75,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 15),
            const Text(
              'لا توجد طلبات',
              style: TextStyle(
                color: Color(0xFF071F49),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'لا توجد طلبات مطابقة للفلتر المحدد',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderArchiveCard extends StatelessWidget {
  final ArchiveOrder order;
  final String Function(DateTime) formatDate;
  final String Function(double) formatAmount;
  final VoidCallback onTap;

  const _OrderArchiveCard({
    required this.order,
    required this.formatDate,
    required this.formatAmount,
    required this.onTap,
  });

  static const Color navyColor = Color(0xFF071F49);

  @override
  Widget build(BuildContext context) {
    final statusColor = order.status.color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border(right: BorderSide(color: statusColor, width: 3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طلب رقم ${order.orderNumber}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.pharmacyName,
                          style: const TextStyle(
                            color: navyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      order.status.title,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OrderInfoItem(
                      title: 'التاريخ',
                      value: formatDate(order.date),
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
                  Container(height: 38, width: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: _OrderInfoItem(
                      title: 'عدد الأصناف',
                      value: '${order.itemsCount}',
                      icon: Icons.medication_outlined,
                    ),
                  ),
                  Container(height: 38, width: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: _OrderInfoItem(
                      title: 'القيمة الإجمالية',
                      value: '${formatAmount(order.totalAmount)} ر.س',
                      icon: Icons.account_balance_wallet_outlined,
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
}

enum OrderArchiveStatus {
  approved,
  pendingReview,
  rejected,
  modified,
  archived,
}

extension OrderArchiveStatusExtension on OrderArchiveStatus {
  String get title {
    switch (this) {
      case OrderArchiveStatus.approved:
        return 'معتمد';

      case OrderArchiveStatus.pendingReview:
        return 'بانتظار المراجعة';

      case OrderArchiveStatus.rejected:
        return 'مرفوض';

      case OrderArchiveStatus.modified:
        return 'تم التعديل';

      case OrderArchiveStatus.archived:
        return 'مؤرشف';
    }
  }

  Color get color {
    switch (this) {
      case OrderArchiveStatus.approved:
        return Colors.green;

      case OrderArchiveStatus.pendingReview:
        return Colors.orange;

      case OrderArchiveStatus.rejected:
        return Colors.red;

      case OrderArchiveStatus.modified:
        return Colors.blue;

      case OrderArchiveStatus.archived:
        return Colors.grey;
    }
  }
}
