import 'package:flutter/material.dart';
import 'package:project_2/InventoryPdfScreen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      const Text(
                        'نظرة عامة على المخزون',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff102A43),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xffDCE8FF),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => InventoryPdfScreen(
   
    ),
  ),
);
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Color(0xff274C77),
                        ),
                        label: const Text(
                          "عرض الجرد PDF",
                          style: TextStyle(
                            color: Color(0xff274C77),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// Alert Card
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 220,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xffFDE7E5),
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xffF5B5B0),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'تنبيهات النفاذ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '12',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Title
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xff7A5A13),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'الأصناف القابلة للنفاد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff102A43),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _lowStockCard(
                    company: "شركة فارماكير العالمية",
                    item: "أموكسيسيلين - 500 ملجم",
                    expiry: "12/03/2025",
                    quantity: "5 قطع فقط",
                    image: "assets/images/med1.png",
                  ),

                  _lowStockCard(
                    company: "مختبرات الخليج الطبية",
                    item: "شرائح اختبار الجلوكوز",
                    expiry: "26/05/2025",
                    quantity: "8 علب فقط",
                    image: "assets/images/med2.png",
                  ),

                  _lowStockCard(
                    company: "شركة الأدوية المتحدة",
                    item: "فيتولين بخاخ للفم",
                    expiry: "25/08/2025",
                    quantity: "15 قطعة",
                    image: "assets/images/med3.png",
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "أصناف قريبة الانتهاء",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff102A43),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _expiryCard(
                          title: "باراسيتامول شراب",
                          quantity: "240 وحدة",
                          date: "15-09-2026",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _expiryCard(
                          title: "أوميجا 3 كبسول",
                          quantity: "120 علبة",
                          date: "22-11-2025",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lowStockCard({
    required String company,
    required String item,
    required String expiry,
    required String quantity,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(12),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFDEAEA),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                        textAlign: TextAlign.right,
                    quantity,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  company,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xff3E4C59),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff102A43),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    Text(
                      expiry,
                      style: const TextStyle(
                        color: Color(0xff616E7C),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "تاريخ الانتهاء:",
                      style: TextStyle(
                        color: Color(0xff616E7C),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    Text(
                      "طلب توريد",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: .85,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _expiryCard({
    required String title,
    required String quantity,
    required String date,
  }) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffFFF1D6),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Text(
              "تنتهي خلال 3 أشهر",
              style: TextStyle(
                color: Color(0xffD9822B),
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "الكمية: $quantity",
            style: const TextStyle(
              color: Color(0xff616E7C),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.access_time_outlined,
                color: Colors.red,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}