import 'package:flutter/material.dart';

class InventoryPdfScreen extends StatelessWidget {
  const InventoryPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          
          title: const Text(
            "جرد المستودع",
            style: TextStyle(
              color: Color(0xFF102A43),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "الشركة الطبية المتحدة\nفرع المستودعات المركزية\nتاريخ التقرير: ٢٤ مايو ٢٠٢٤",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.6,
                              ),
                            ),
                          ),
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: const Color(0xFF102A43),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),

                      /// LIST
                      Expanded(
                        child: ListView.separated(
                          itemCount: 3,
                          separatorBuilder: (_, __) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Divider(height: 1),
                          ),
                          itemBuilder: (context, index) {
                            final items = [
                              _buildProductCard(
                                "معقم جراحي فائق الجودة",
                                "SKU-992-B",
                                "متوفر",
                                Colors.green,
                              ),
                              _buildProductCard(
                                "قفازات لاتكس طبية (١٠٠)",
                                "SKU-441-A",
                                "متوفر",
                                Colors.green,
                              ),
                              _buildProductCard(
                                "جهاز قياس ضغط الدم رقمي",
                                "SKU-202-K",
                                "منخفض",
                                Colors.red,
                              ),
                            ];
                            return items[index];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      "مشاركة",
                      Icons.share,
                      const Color(0xFFE2E8F0),
                      const Color(0xFF102A43),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      "تنزيل التقرير",
                      Icons.download,
                      const Color(0xFF061E3C),
                      Colors.white,
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

  /// PRODUCT CARD (PROFESSIONAL)
  Widget _buildProductCard(
    String name,
    String sku,
    String status,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sku,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// STATUS BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.shade200),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color.shade700,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
  ) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: textColor),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 2,
      ),
    );
  }
}