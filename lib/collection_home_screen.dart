import 'package:flutter/material.dart';
import 'package:project_2/collection_pharmacies_filter_screen.dart';

enum CollectionFilter {
  all,
  approved,
  pending,
  rejected,
}

class CollectionHomeScreen extends StatefulWidget {
  const CollectionHomeScreen({super.key});

  @override
  State<CollectionHomeScreen> createState() => _CollectionHomeScreenState();
}

class _CollectionHomeScreenState extends State<CollectionHomeScreen> {
  CollectionFilter selectedFilter = CollectionFilter.all;

  final List<Map<String, dynamic>> collections = [
    {
      "pharmacyName": "صيدلية الشفاء",
      "area": "حي الميدان - دمشق",
      "amount": 1200.00,
      "status": "approved",
    },
    {
      "pharmacyName": "مستشفى المواساة",
      "area": "شارع عدنان المالكي - دمشق",
      "amount": 3500.00,
      "status": "pending",
    },
    {
      "pharmacyName": "مركز العناية الطبي",
      "area": "المالكي - دمشق",
      "amount": 700.00,
      "status": "rejected",
    },
    {
      "pharmacyName": "صيدلية الحياة",
      "area": "حي التجارة - دمشق",
      "amount": 900.00,
      "status": "approved",
    },
  ];

  List<Map<String, dynamic>> get filteredCollections {
    if (selectedFilter == CollectionFilter.all) {
      return collections;
    }

    return collections.where((item) {
      final status = item["status"];

      switch (selectedFilter) {
        case CollectionFilter.approved:
          return status == "approved";

        case CollectionFilter.pending:
          return status == "pending";

        case CollectionFilter.rejected:
          return status == "rejected";

        case CollectionFilter.all:
          return true;
      }
    }).toList();
  }

  double get todayTotal {
    return collections.fold<double>(0, (sum, item) {
      final amount = item["amount"];

      if (amount is num) {
        return sum + amount.toDouble();
      }

      return sum;
    });
  }

  int get approvedCount {
    return collections.where((item) => item["status"] == "approved").length;
  }

  int get pendingCount {
    return collections.where((item) => item["status"] == "pending").length;
  }

  int get rejectedCount {
    return collections.where((item) => item["status"] == "rejected").length;
  }

  @override
  Widget build(BuildContext context) {
    final visibleCollections = filteredCollections;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "إدارة التحصيل",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Color(0xff0A2954),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xffEAF0F8),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/profile.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        color: Color(0xff0A2954),
                        size: 18,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        body: ListView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
          children: [
            _buildHeader(),

            const SizedBox(height: 14),

            _buildMainActions(),

            const SizedBox(height: 14),

            _buildTodaySummary(),

            const SizedBox(height: 12),

            _buildStatusCards(),

            const SizedBox(height: 16),

            _buildSectionHeader(),

            const SizedBox(height: 10),

            _buildFilters(),

            const SizedBox(height: 10),

            if (visibleCollections.isEmpty)
              _buildEmptyState()
            else
              ...visibleCollections.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildCollectionCard(item),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "التحصيل",
          style: TextStyle(
            color: Color(0xff0A2954),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          "متابعة وتسجيل الدفعات النقدية اليومية",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMainActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: الانتقال إلى شاشة تسجيل دفعة جديدة
            },
            icon: const Icon(Icons.add_circle_outline, size: 19),
            label: const Text(
              "تسجيل دفعة جديدة",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff062B57),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),

        const SizedBox(height: 9),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: الانتقال إلى سجل التحصيلات
            },
            icon: const Icon(Icons.history, size: 19),
            label: const Text(
              "سجل التحصيلات",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff0A2954),
              side: const BorderSide(color: Color(0xff0A2954)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffCFE7D7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffDDF8E8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              "+12%",
              style: TextStyle(
                color: Color(0xff18A05E),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "إجمالي تحصيل اليوم",
                style: TextStyle(
                  color: Color(0xff53657E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${todayTotal.toStringAsFixed(0)} ر.س",
                style: const TextStyle(
                  color: Color(0xff169967),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              title: "التحصيلات المعتمدة",
              count: approvedCount,
              icon: Icons.check_circle_outline,
              borderColor: const Color(0xff70C99B),
              iconColor: const Color(0xff18A05E),
              filter: CollectionFilter.approved,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatusCard(
              title: "بانتظار الاعتماد",
              count: pendingCount,
              icon: Icons.hourglass_empty,
              borderColor: const Color(0xffF1A548),
              iconColor: const Color(0xffF1A548),
              filter: CollectionFilter.pending,
            ),
          ),
        ],
      ),

      const SizedBox(height: 10),

      Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              title: "التحصيلات المرفوضة",
              count: rejectedCount,
              icon: Icons.cancel_outlined,
              borderColor: const Color(0xffE17676),
              iconColor: const Color(0xffD63B35),
              filter: CollectionFilter.rejected,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: SizedBox()),
        ],
      ),
    ],
  );
}

 Widget _buildStatusCard({
  required String title,
  required int count,
  required IconData icon,
  required Color borderColor,
  required Color iconColor,
  required CollectionFilter filter,
}) {
  final isSelected = selectedFilter == filter;

  return InkWell(
    onTap: () {
      setState(() {
        selectedFilter = filter;
      });
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      constraints: const BoxConstraints(
        minHeight: 92,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? iconColor : borderColor,
          width: isSelected ? 1.8 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 18,
          ),

          const SizedBox(height: 6),

          Text(
            "$count",
            style: const TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff53657E),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Text(
          "العمليات الأخيرة",
          style: TextStyle(
            color: Color(0xff1A2F4D),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
        
           Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const CollectionPharmaciesFilterScreen(),
  ),
);
          },
          child: const Text(
            "عرض الكل",
            style: TextStyle(
              color: Color(0xff169967),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            title: "الكل",
            filter: CollectionFilter.all,
          ),
          _buildFilterChip(
            title: "معتمدة",
            filter: CollectionFilter.approved,
          ),
          _buildFilterChip(
            title: "بانتظار الاعتماد",
            filter: CollectionFilter.pending,
          ),
          _buildFilterChip(
            title: "مرفوضة",
            filter: CollectionFilter.rejected,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String title,
    required CollectionFilter filter,
  }) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(title),
        onSelected: (_) {
          setState(() {
            selectedFilter = filter;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xff0A2954),
        side: BorderSide(
          color: isSelected
              ? const Color(0xff0A2954)
              : const Color(0xffD9E0EA),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xff53657E),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> item) {
    final status = item["status"].toString();
    final amount = (item["amount"] as num).toDouble();

    final statusData = _getStatusData(status);

    return InkWell(
      onTap: () {
        // TODO: الانتقال إلى تفاصيل الصيدلية أو تفاصيل التحصيل
      },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xffE5EAF1)),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xffEDF3FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                statusData["icon"],
                color: const Color(0xff60758F),
                size: 24,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["pharmacyName"].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff1A2F4D),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["area"].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${amount.toStringAsFixed(0)} ر.س",
                  style: const TextStyle(
                    color: Color(0xff169967),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusData["backgroundColor"],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusData["text"],
                    style: TextStyle(
                      color: statusData["textColor"],
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case "approved":
        return {
          "text": "معتمدة",
          "icon": Icons.account_balance_wallet_outlined,
          "backgroundColor": const Color(0xffE4FAEF),
          "textColor": const Color(0xff18A05E),
        };

      case "pending":
        return {
          "text": "بانتظار الاعتماد",
          "icon": Icons.receipt_long_outlined,
          "backgroundColor": const Color(0xffFFF2E3),
          "textColor": const Color(0xffE78324),
        };

      case "rejected":
        return {
          "text": "مرفوضة",
          "icon": Icons.receipt_outlined,
          "backgroundColor": const Color(0xffFFE8E8),
          "textColor": const Color(0xffD63B35),
        };

      default:
        return {
          "text": "غير محدد",
          "icon": Icons.receipt_outlined,
          "backgroundColor": const Color(0xffEDF3FB),
          "textColor": const Color(0xff60758F),
        };
    }
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          const Text(
            "لا توجد عمليات مطابقة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
