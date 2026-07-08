import 'package:flutter/material.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "العروض الحالية",
            style: TextStyle(
              color: Color(0xff002D62),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            labelColor: const Color(0xff002D62),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xff002D62),
            tabs: const [
              Tab(text: "العروض الحالية"),
              Tab(text: "الحسومات"),
            ],
          ),
        ),

        body: TabBarView(

          controller: tabController,
          children: [

            /// OFFERS TAB
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// Main Offer Card
                 Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "نشط الآن",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    const Text(
      "أبرز العروض الأسبوعية",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xff002D62),
      ),
    ),
  ],
),

                        const SizedBox(height: 20),
GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 6,
  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1,
    childAspectRatio: 1.3,
    mainAxisSpacing: 15,
  ),
  itemBuilder: (context, index) {
    return OfferCard();
  },
),

                  const SizedBox(height: 25),

                  /// Suggested Products
                  sectionTitle("الأصناف المقترحة للبيع"),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
//ربط
                        ProductCard(
                          name: "Panadol Extra",
                          discount: "5%",
                        ),

                        ProductCard(
                          name: "Vitamin C",
                          discount: "10%",
                        ),

                        ProductCard(
                          name: "Omega 3",
                          discount: "12%",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Bundles
                  sectionTitle("السلات المقترحة للبيع من المشرف"),

                  const SizedBox(height: 10),
//ربط
                  const BundleCard(
                    title: "سلة عناية الأطفال",
                    products: [
                      "شراب خافض حرارة",
                      "فيتامين أطفال",
                      "حفاضات",
                    ],
                    discount: "15%",
                  ),

                  const SizedBox(height: 15),

                  const BundleCard(
                    title: "سلة الإسعافات الأولية",
                    products: [
                      "شاش",
                      "مطهر",
                      "لاصق طبي",
                    ],
                    discount: "25%",
                  ),
                ],
              ),
            ),

            /// DISCOUNTS TAB
            ListView(
              padding: const EdgeInsets.all(16),
              children: const [
//ربط
                DiscountTile(
                  title: "أدوية السكري",
                  discount: "8%",
                ),

                DiscountTile(
                  title: "الدفع النقدي المبكر",
                  discount: "3%",
                ),

                DiscountTile(
                  title: "ولاء العملاء الذهبي",
                  discount: "5%",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xff002D62),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String discount;

  const ProductCard({
    super.key,
    required this.name,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Expanded(
            child: Icon(
              Icons.medication,
              size: 60,
              color: Color(0xff002D62),
            ),
          ),
          Text(name),
          const SizedBox(height: 5),
          Text(
            "خصم $discount",
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class BundleCard extends StatelessWidget {
  final String title;
  final List<String> products;
  final String discount;

  const BundleCard({
    super.key,
    required this.title,
    required this.products,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          ...products.map((e) => Text("• $e")),
          const SizedBox(height: 10),
          Text(
            "إجمالي الحسم $discount",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: null,
              child: const Text("عرض السلة"),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscountTile extends StatelessWidget {
  final String title;
  final String discount;

  const DiscountTile({
    super.key,
    required this.title,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          discount,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Row(
            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    "20%",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: const Text("5 + 1"),
                  ),
                ],
              ),

              const Spacer(),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    "عرض المضادات الحيوية الصيفي",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff002D62),
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Amoxicillin - Azithromycin",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: infoBox(
                  "15/10/2025",
                  "الانتهاء",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: infoBox(
                  "50",
                  "الكمية",
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "هذا العرض مخصص للصيدليات من الفئة A",
              textAlign: TextAlign.right,
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xff002D62),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "إضافة العرض الى الطلب",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoBox(
    String value,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffF5F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}