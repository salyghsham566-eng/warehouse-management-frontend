import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/orders_tracking_bloc.dart';
import 'package:project_2/Features/auth/bloc/orders_tracking_event.dart';
import 'package:project_2/Features/auth/bloc/orders_tracking_state.dart';
import 'package:project_2/Features/auth/presentation/ChooseCompanyScreen.dart';
import 'package:project_2/Features/auth/presentation/order_details_screen.dart';
import 'package:project_2/Features/auth/presentation/orders_archive_screen.dart';
import 'package:project_2/Features/auth/presentation/orders_tracking_screen.dart';
import 'package:project_2/orders_store.dart';

class OrdersScreen extends StatefulWidget {

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersTrackingBloc _ordersBloc;
  @override
void initState() {
  super.initState();

  _ordersBloc = sl<OrdersTrackingBloc>()
    ..add(const OrdersTrackingStarted());

  // أي طلبية جديدة تُحفظ في OrdersStore لازم تحدث قسم آخر الطلبات فوراً.
  OrdersStore.instance.ordersNotifier.addListener(
    _refreshLatestOrders,
  );
}

void _refreshLatestOrders() {
  if (!mounted || _ordersBloc.isClosed) {
    return;
  }

  _ordersBloc.add(
    const OrdersTrackingRefreshed(),
  );
}

@override
void dispose() {
  OrdersStore.instance.ordersNotifier.removeListener(
    _refreshLatestOrders,
  );
  _ordersBloc.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<OrdersTrackingBloc>.value(
  value: _ordersBloc,
    
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xffF5F6FA),
      
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
      
            title: const Text(
              "الطلبات",
              style: TextStyle(
                color: Color(0xff081F4D),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
      
           
          ),
      
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
      
              child: Column(
                children: [
               
      
                  /// Welcome Card
                  ///////////////////////////////////////////////
                  /// Create Order Card
                  ////////////////////////////////////////////////
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseCompanyPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff082B63),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
      
                          const Spacer(),
      
                          const Text(
                            "إنشاء طلبية جديدة",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
      
                          const SizedBox(width: 18),
      
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 22),
      
                  ////////////////////////////////////////////////
                  /// Two Cards
                  ////////////////////////////////////////////////
                  Row(
                    children: [
                      Expanded(
                        child: _menuCard(
                          title: "أرشيف الطلبات",
                          icon: Icons.history,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrdersArchiveScreen(),
                              ),
                            );
                          },
                        ),
                      ),
      
                      const SizedBox(width: 16),
      
                      Expanded(
                        child: _menuCard(
                          title: "حالة الطلبات",
                          icon: Icons.assignment_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrdersTrackingScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 22),
      
                  ////////////////////////////////////////////////
                  /// آخر الطلبات
                  ////////////////////////////////////////////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "آخر الطلبات",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
      
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersArchiveScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض الكل",
                          style: TextStyle(
                            color: Color(0xff082B63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 15),
      BlocBuilder<OrdersTrackingBloc, OrdersTrackingState>(
  builder: (context, state) {
    if (state is OrdersTrackingInitial ||
        state is OrdersTrackingLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 35),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is OrdersTrackingFailure) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 45,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                context.read<OrdersTrackingBloc>().add(
                  const OrdersTrackingStarted(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state is OrdersTrackingLoaded) {
      final List<Map<String, dynamic>> latestOrders =
          state.orders
              .map((order) => order.toMap())
              .toList();

      latestOrders.sort((firstOrder, secondOrder) {
        final DateTime firstDate = _parseOrderDate(
          firstOrder['createdAt'] ??
              firstOrder['created_at'] ??
              firstOrder['date'],
        );

        final DateTime secondDate = _parseOrderDate(
          secondOrder['createdAt'] ??
              secondOrder['created_at'] ??
              secondOrder['date'],
        );

        return secondDate.compareTo(firstDate);
      });

      final List<Map<String, dynamic>> lastThreeOrders =
          latestOrders.take(3).toList();

      if (lastThreeOrders.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 35,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 45,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                'لا توجد طلبات حتى الآن',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lastThreeOrders.length,
        itemBuilder: (context, index) {
          return _orderCard(
            context,
            lastThreeOrders[index],
          );
        },
      );
    }

    return const SizedBox.shrink();
  },
),
                  
                  const SizedBox(height: 30),
      
                  /// الأجزاء التالية سنضيفها بالرسالة القادمة
                ],
              ),
            ),
          ),
        ),
      ),);

  }
}

Widget _menuCard({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 42, color: const Color(0xff082B63)),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Color(0xff082B63),
            ),
          ),
        ],
      ),
    ),
  );
}

DateTime _parseOrderDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _formatOrderDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}

String _getStatusText(dynamic value) {
  final status = value?.toString().toLowerCase();

  switch (status) {
    case "approved":
    case "معتمد":
      return "معتمد";

    case "rejected":
    case "مرفوض":
      return "مرفوض";

    case "modified":
    case "تم التعديل":
      return "تم التعديل";

    case "archived":
    case "مؤرشف":
      return "مؤرشف";

    case "pending_review":
    case "processing":
    case "قيد المعالجة":
    case "بانتظار المراجعة":
    default:
      return "بانتظار المراجعة";
  }
}

Color _getStatusColor(dynamic value) {
  final status = value?.toString().toLowerCase();

  switch (status) {
    case "approved":
    case "معتمد":
      return Colors.green;

    case "rejected":
    case "مرفوض":
      return Colors.red;

    case "modified":
    case "تم التعديل":
      return Colors.blue;

    case "archived":
    case "مؤرشف":
      return Colors.grey;

    default:
      return Colors.orange;
  }
}

double _parseOrderPrice(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

Widget _orderCard(BuildContext context, Map<String, dynamic> order) {
  final pharmacyName =
      order["pharmacyName"]?.toString() ??
      order["pharmacy"]?.toString() ??
      "صيدلية غير محددة";

  final orderNumber =
      order["orderNumber"]?.toString() ??
      order["orderNo"]?.toString() ??
      order["id"]?.toString() ??
      "بدون رقم";

  final totalAmount = _parseOrderPrice(
    order["totalAmount"] ?? order["price"] ?? order["total"],
  );

  final orderDate = _parseOrderDate(order["date"] ?? order["createdAt"]);

  final statusText = _getStatusText(order["status"]);

  final statusColor = _getStatusColor(order["status"]);

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.15),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                pharmacyName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Text("رقم الطلب : $orderNumber", style: const TextStyle(fontSize: 16)),

        const SizedBox(height: 8),

        Text(
          "القيمة : ${totalAmount.toStringAsFixed(2)} ريال",
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 8),

        Text(
          "التاريخ : ${_formatOrderDate(orderDate)}",
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(orderNumber: orderNumber),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff082B63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "عرض التفاصيل",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
