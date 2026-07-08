import 'package:flutter/material.dart';
import 'package:project_2/company_products_screen.dart';

enum CompanyFilter { all, hasOffers, noOffers, mostProducts }

class ChooseCompanyScreen extends StatefulWidget {
  const ChooseCompanyScreen({super.key});

  @override
  State<ChooseCompanyScreen> createState() => _ChooseCompanyScreenState();
}

class _ChooseCompanyScreenState extends State<ChooseCompanyScreen> {
  final TextEditingController searchController = TextEditingController();

  CompanyFilter selectedFilter = CompanyFilter.all;
  final Map<String, Map<String, dynamic>> sharedCartItems = {};
  final List<Map<String, dynamic>> companies = [
    {
      "name": "GSK العالمية",
      "productsCount": 450,
      "offers": 5,
      "image": "assets/images/gsk.png",

      "products": <Map<String, dynamic>>[
        {
          "name": "أوغمنتين 1 جم",
          "scientificName": "Amoxicillin / Clavulanic Acid",
          "description": "14 حبة",
          "expiry": "12/2027",
          "price": 85.50,
          "oldPrice": 95.00,
          "image": "assets/images/augmentin.png",
          "basicOffer": null,
        },
        {
          "name": "فولتارين جل",
          "scientificName": "Diclofenac",
          "description": "أنبوب 50 غرام",
          "expiry": "08/2028",
          "price": 22.00,
          "oldPrice": null,
          "image": "assets/images/voltaren.png",
          "basicOffer": {
            "isActive": true,
            "buyQuantity": 10,
            "freeQuantity": 2,
          },
        },
      ],
    },
    {
      "name": "حما فارما",
      "productsCount": 1200,
      "offers": 0,
      "image": "assets/images/hama.png",

      "products": <Map<String, dynamic>>[
        {
          "name": "باراسيتامول",
          "scientificName": "Paracetamol",
          "description": "20 حبة - 500 ملغ",
          "expiry": "06/2028",
          "price": 12.50,
          "oldPrice": null,
          "image": "assets/images/paracetamol.png",
          "basicOffer": {
            "isActive": true,
            "buyQuantity": 10,
            "freeQuantity": 2,
          },
        },
        {
          "name": "أموكسيسيلين",
          "scientificName": "Amoxicillin",
          "description": "كبسولات 500 ملغ",
          "expiry": "09/2027",
          "price": 28.00,
          "oldPrice": null,
          "image": "assets/images/amoxicillin.png",
          "basicOffer": null,
        },
      ],
    },
  ];
  List<Map<String, dynamic>> get filteredCompanies {
    final searchText = searchController.text.trim().toLowerCase();

    List<Map<String, dynamic>> result = companies.where((company) {
      final companyName = company["name"].toString().toLowerCase();

      return companyName.contains(searchText);
    }).toList();

    switch (selectedFilter) {
      case CompanyFilter.hasOffers:
        result = result.where((company) => company["offers"] > 0).toList();
        break;

      case CompanyFilter.noOffers:
        result = result.where((company) => company["offers"] == 0).toList();
        break;

      case CompanyFilter.mostProducts:
        result.sort(
          (a, b) => (b["products"] as int).compareTo(a["products"] as int),
        );
        break;

      case CompanyFilter.all:
        break;
    }

    return result;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCompanies = filteredCompanies;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        

        title: const Text(
          "اختيار الشركة",
          style: TextStyle(
            color: Color(0xff0A2954),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

   
      
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: TextField(
                controller: searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "ابحث عن اسم الشركة...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff0A2954),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close, size: 20),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xff0A2954),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildFilterChip(title: "الكل", filter: CompanyFilter.all),
                  _buildFilterChip(
                    title: "لديها عروض",
                    filter: CompanyFilter.hasOffers,
                  ),
                  _buildFilterChip(
                    title: "بدون عروض",
                    filter: CompanyFilter.noOffers,
                  ),
                  _buildFilterChip(
                    title: "الأكثر منتجات",
                    filter: CompanyFilter.mostProducts,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: visibleCompanies.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                      itemCount: visibleCompanies.length,

                      // تظل GridView ولكن بعمود واحد
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 175,
                          ),

                      itemBuilder: (context, index) {
                        final company = visibleCompanies[index];

                        return _buildCompanyCard(context, company);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String title,
    required CompanyFilter filter,
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
        backgroundColor: const Color(0xffE8F0FC),
        selectedColor: const Color(0xff0A2954),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xff53657E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> company) {
    final int offers = company["offers"];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE4EAF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F7FC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xffEDF0F5)),
                        ),
                        child: Image.asset(
                          company["image"],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              color: Color(0xff0A2954),
                              size: 30,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company["name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xff0A2954),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${company["productsCount"]} منتج متاح",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 90),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: offers > 0
                          ? const Color(0xffE4FAEF)
                          : const Color(0xffEDF3FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          offers > 0 ? Icons.access_time : Icons.info_outline,
                          size: 14,
                          color: offers > 0
                              ? const Color(0xff26A76F)
                              : const Color(0xff60758F),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          offers > 0 ? "$offers عروض فعالة" : "لا توجد عروض",
                          style: TextStyle(
                            color: offers > 0
                                ? const Color(0xff26A76F)
                                : const Color(0xff60758F),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: () {
                // الانتقال إلى أدوية هذه الشركة
                // مثال:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompanyProductsScreen(
                      company: company,
                      cartItems: sharedCartItems,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff062B57),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "عرض الأدوية",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_left, size: 21),
                ],
              ),
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
          Icon(Icons.business_outlined, size: 65, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "لا توجد شركات مطابقة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "جرّبي تغيير كلمة البحث أو الفلتر",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
