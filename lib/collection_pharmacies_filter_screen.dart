import 'package:flutter/material.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacies_filter.dart';

//enum CollectionPharmacyFilter { all, hasDebt, paid, pendingPayments, pendingCollection }

class CollectionPharmaciesFilterScreen extends StatefulWidget {
  const CollectionPharmaciesFilterScreen({super.key});

  @override
  State<CollectionPharmaciesFilterScreen> createState() =>
      _CollectionPharmaciesFilterScreenState();
}

class _CollectionPharmaciesFilterScreenState
    extends State<CollectionPharmaciesFilterScreen> {
  final TextEditingController searchController = TextEditingController();

  CollectionPharmacyFilter selectedFilter = CollectionPharmacyFilter.all;

  final List<Map<String, dynamic>> pharmacies = [
    {
      "name": "صيدلية النهدي - فرع الملقا",
      "area": "حي الملقا، شارع أنس بن مالك، الرياض",
      "dueAmount": 1250.00,
      "lastPayment": 500.00,
      "hasPendingPayment": true,
      "isFavorite": false,
      "phone": "0999999999",
    },
    {
      "name": "صيدلية الدواء - فرع اليرموك",
      "area": "طريق عثمان بن عفان، حي اليرموك",
      "dueAmount": 3840.50,
      "lastPayment": 1200.00,
      "hasPendingPayment": true,
      "isFavorite": true,
      "phone": "0988888888",
    },
    {
      "name": "صيدلية أطلس - فرع المحافظة",
      "area": "طريق الملك الفهد، الرياض",
      "dueAmount": 0.00,
      "lastPayment": 2450.00,
      "hasPendingPayment": false,
      "isFavorite": false,
      "phone": "0977777777",
    },
    {
      "name": "صيدلية الشفاء",
      "area": "حي الياسمين، الرياض",
      "dueAmount": 750.00,
      "lastPayment": 300.00,
      "hasPendingPayment": false,
      "isFavorite": false,
      "phone": "0966666666",
    },
  ];

  List<Map<String, dynamic>> get filteredPharmacies {
    final searchText = searchController.text.trim().toLowerCase();

    List<Map<String, dynamic>> result = pharmacies.where((pharmacy) {
      final name = pharmacy["name"].toString().toLowerCase();
      final area = pharmacy["area"].toString().toLowerCase();

      return name.contains(searchText) || area.contains(searchText);
    }).toList();

    switch (selectedFilter) {
      case CollectionPharmacyFilter.hasDebt:
        result = result.where((pharmacy) {
          final dueAmount = _asDouble(pharmacy["dueAmount"]);
          return dueAmount > 0;
        }).toList();
        break;

      case CollectionPharmacyFilter.settled:
        result = result.where((pharmacy) {
          final dueAmount = _asDouble(pharmacy["dueAmount"]);
          final hasPendingPayment = pharmacy["hasPendingPayment"] == true;

          return dueAmount == 0 && !hasPendingPayment;
        }).toList();
        break;

      case CollectionPharmacyFilter.pendingCollection:
        result = result.where((pharmacy) {
          return pharmacy["hasPendingPayment"] == true;
        }).toList();
        break;

      case CollectionPharmacyFilter.all:
        break;
    }

    return result;
  }

  double _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "") ?? 0;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visiblePharmacies = filteredPharmacies;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "اختيار الصيدلية",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_forward, color: Color(0xff0A2954)),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Color(0xff0A2954)),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),

            _buildFilterChips(),

            const SizedBox(height: 8),

            Expanded(
              child: visiblePharmacies.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                      itemCount: visiblePharmacies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _buildPharmacyCard(visiblePharmacies[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xffE8F0FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, color: Color(0xff0A2954), size: 21),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "ابحث عن صيدلية...",
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff7A869A),
                  size: 21,
                ),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Color(0xffD9DFEA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: Color(0xff0A2954),
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildFilterChip(title: "الكل", filter: CollectionPharmacyFilter.all),
          _buildFilterChip(
            title: "عليها ذمة",
            filter: CollectionPharmacyFilter.hasDebt,
          ),
          _buildFilterChip(
            title: "المسددة",
            filter: CollectionPharmacyFilter.settled,
          ),
          _buildFilterChip(
            title: "دفعات معلقة",
            filter: CollectionPharmacyFilter.pendingCollection,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String title,
    required CollectionPharmacyFilter filter,
  }) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) {
          setState(() {
            selectedFilter = filter;
          });
        },
        label: Text(title),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xff0A2954),
        side: BorderSide(
          color: isSelected ? const Color(0xff0A2954) : const Color(0xffD9E0EA),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xff53657E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> pharmacy) {
    final double dueAmount = _asDouble(pharmacy["dueAmount"]);
    final double lastPayment = _asDouble(pharmacy["lastPayment"]);
    final bool hasDebt = dueAmount > 0;
    final bool hasPendingPayment = pharmacy["hasPendingPayment"] == true;
    final bool isPaid = dueAmount == 0 && !hasPendingPayment;
    final bool isFavorite = pharmacy["isFavorite"] == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFavorite ? const Color(0xff0A2954) : const Color(0xffE3E8F0),
          width: isFavorite ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
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
              Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite
                    ? const Color(0xff0A2954)
                    : const Color(0xff7A869A),
                size: 22,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy["name"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff1A2F4D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xff7A869A),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pharmacy["area"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xff7A869A),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: hasDebt
                      ? const Color(0xffE5F4EF)
                      : const Color(0xffEAF3F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasDebt
                      ? Icons.account_balance_wallet_outlined
                      : Icons.check_circle_outline,
                  color: hasDebt
                      ? const Color(0xff116B53)
                      : const Color(0xff18A05E),
                  size: 23,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildAmountBox(
                  title: "الرصيد المستحق",
                  amount: dueAmount,
                  amountColor: hasDebt
                      ? const Color(0xffD63B35)
                      : const Color(0xff18A05E),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildAmountBox(
                  title: "آخر دفعة",
                  amount: lastPayment,
                  amountColor: const Color(0xff169967),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 43,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: اتصال بالصيدلية
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Color(0xffD9E0EA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    color: Color(0xff0A2954),
                    size: 19,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: isPaid
                        ? null
                        : () {
                            // TODO: الانتقال إلى شاشة تسجيل دفعة
                            // Navigator.push(...);
                          },
                    icon: Icon(
                      isPaid
                          ? Icons.check_circle_outline
                          : Icons.payments_outlined,
                      size: 18,
                    ),
                    label: Text(
                      isPaid ? "مسدد" : "تسديد",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaid
                          ? const Color(0xffA0A7B2)
                          : const Color(0xff0A2954),
                      disabledBackgroundColor: const Color(0xffA0A7B2),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (hasPendingPayment) ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xffFFF2E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "لديها دفعة معلقة بانتظار اعتماد المفوتر",
                style: TextStyle(
                  color: Color(0xffE78324),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountBox({
    required String title,
    required double amount,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xffEDF0F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff7A869A),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${amount.toStringAsFixed(2)} ر.س",
            style: TextStyle(
              color: amountColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_pharmacy_outlined,
            size: 65,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            "لا توجد صيدليات مطابقة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "غيّري كلمة البحث أو الفلتر",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
