import 'package:flutter/material.dart';
import 'package:project_2/order_details_screen.dart';
import 'package:project_2/orders_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final String pharmacyName;
  final DateTime sentAt;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.pharmacyName,
    required this.sentAt,
  });

  String _formatDate(DateTime date) {
    final int hour12 = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final String period =
        date.hour >= 12 ? "م" : "ص";

    final String minute =
        date.minute.toString().padLeft(2, "0");

    return "${date.day}/${date.month}/${date.year}"
        " - $hour12:$minute $period";
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  void _startNewOrder(BuildContext context) {
    // مؤقتاً نرجع للرئيسية.
    // لاحقاً منربطه مباشرة بواجهة اختيار الشركة.
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

 void _trackOrder(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderDetailsScreen(
        orderNumber: orderNumber,
      ),
    ),
  );
}

 
 

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor:
              const Color(0xffF5F7FC),
          body: SafeArea(
            child: Stack(
              children: [
                const Positioned(
                  top: 180,
                  right: -5,
                  child: _DecorationSquare(
                    color: Color(0xff57D5A0),
                    size: 8,
                  ),
                ),
                const Positioned(
                  top: 270,
                  left: 22,
                  child: _DecorationSquare(
                    color: Color(0xff0A2954),
                    size: 7,
                  ),
                ),
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    45,
                    16,
                    24,
                  ),
                  child: Column(
                    children: [
                      _buildSuccessIcon(),
                      const SizedBox(height: 24),
                      const Text(
                        "تم إرسال الطلبية بنجاح",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff0A2954),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        "سيتم مراجعة طلبك من قبل المفوتر،"
                        "\nوسنخبرك عند تحديث حالته.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff6C7A91),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildOrderHeader(),
                      const SizedBox(height: 10),
                      _buildInfoCard(
                        icon: Icons.local_pharmacy_outlined,
                        title: "الصيدلية",
                        value: pharmacyName,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoCard(
                        icon: Icons.calendar_today_outlined,
                        title: "تاريخ إرسال الطلب",
                        value: _formatDate(sentAt),
                      ),
                      const SizedBox(height: 26),
                      _buildButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xff64E5B3),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.check_circle_outline,
        color: Color(0xff08775A),
        size: 48,
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallCard(
            title: "رقم الطلب",
            value: "#$orderNumber",
            valueColor: const Color(0xff0A2954),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSmallCard(
            title: "حالة الطلب",
            value: "بانتظار المراجعة",
            valueColor: const Color(0xffE9A12C),
            showStatusDot: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallCard({
    required String title,
    required String value,
    required Color valueColor,
    bool showStatusDot = false,
  }) {
    return Container(
      height: 75,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xffE5EAF1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff7D8796),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              if (showStatusDot) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: valueColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xffE5EAF1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffEEF3FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: const Color(0xff0A2954),
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff7D8796),
                    fontSize: 10,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 49,
          child: ElevatedButton.icon(
            onPressed: () {
              _trackOrder(context);
            },
            icon: const Icon(
              Icons.receipt_long_outlined,
              size: 19,
            ),
            label: const Text(
              "متابعة حالة الطلب",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xff0A2954),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          height: 49,
          child: ElevatedButton.icon(
            onPressed: () {
              _startNewOrder(context);
            },
            icon: const Icon(
              Icons.add_shopping_cart_outlined,
              size: 19,
            ),
            label: const Text(
              "إنشاء طلبية جديدة",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xff64E5B3),
              foregroundColor:
                  const Color(0xff075943),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            _goHome(context);
          },
          icon: const Icon(
            Icons.home_outlined,
            size: 19,
          ),
          label: const Text(
            "العودة للرئيسية",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor:
                const Color(0xff0A2954),
          ),
        ),
      ],
    );
  }
}

class _DecorationSquare extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorationSquare({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.7,
      child: Container(
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}