import 'package:flutter/material.dart';

class DrugDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String companyName;
  final int initialQuantity;

  const DrugDetailsScreen({
    super.key,
    required this.product,
    required this.companyName,
    this.initialQuantity = 1,
  });

  @override
  State<DrugDetailsScreen> createState() => _DrugDetailsScreenState();
}

class _DrugDetailsScreenState extends State<DrugDetailsScreen> {
  late int quantity;

  @override
  void initState() {
    super.initState();

    quantity = widget.initialQuantity > 0 ? widget.initialQuantity : 1;
  }

  double _numberValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "") ?? 0;
  }

  double get price {
    return _numberValue(widget.product["price"]);
  }

  double? get oldPrice {
    final value = widget.product["oldPrice"];

    if (value == null) {
      return null;
    }

    return _numberValue(value);
  }

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  Map<String, int>? get basicOffer {
    final dynamic offerData = widget.product["basicOffer"];

    if (offerData is! Map) {
      return null;
    }

    final int buyQuantity = _asInt(offerData["buyQuantity"]);
    final int freeQuantity = _asInt(offerData["freeQuantity"]);

    if (buyQuantity <= 0 || freeQuantity <= 0) {
      return null;
    }

    return {"buyQuantity": buyQuantity, "freeQuantity": freeQuantity};
  }

  bool get hasPriceOffer {
    return oldPrice != null && oldPrice! > price;
  }

  bool get hasBasicOffer {
    return basicOffer != null;
  }

  bool get hasOffer {
    return hasPriceOffer || hasBasicOffer;
  }

  int get discountPercentage {
    if (!hasPriceOffer || oldPrice == 0) {
      return 0;
    }

    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  int get freeQuantity {
    final offer = basicOffer;

    if (offer == null) {
      return 0;
    }

    final int buyQuantity = offer["buyQuantity"]!;
    final int freePerOffer = offer["freeQuantity"]!;

    return (quantity ~/ buyQuantity) * freePerOffer;
  }

  String get offerText {
    if (hasPriceOffer) {
      return "عرض خاص - خصم $discountPercentage%";
    }

    final offer = basicOffer;

    if (offer != null) {
      return "عرض: كل ${offer["buyQuantity"]} + ${offer["freeQuantity"]} مجاني";
    }

    return "";
  }

  double get totalPrice {
    return price * quantity;
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity <= 1) {
      return;
    }

    setState(() {
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String productName = widget.product["name"]?.toString() ?? "";

    final String scientificName =
        widget.product["scientificName"]?.toString() ?? "";

    final String description =
        widget.product["description"]?.toString() ??
        "لا يوجد وصف متوفر لهذا الدواء";

    final String expiry = widget.product["expiry"]?.toString() ?? "غير محدد";

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
            "تفاصيل الدواء",
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
            icon: const Icon(Icons.arrow_back, color: Color(0xff0A2954)),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
          children: [
            _buildProductImage(),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffE4E9F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasOffer)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffDFF7EA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          offerText,
                          style: const TextStyle(
                            color: Color(0xff15965D),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (hasOffer) const SizedBox(height: 10),

                  Text(
                    productName,
                    style: const TextStyle(
                      color: Color(0xff172D4D),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    scientificName,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.business_outlined,
                        size: 18,
                        color: Color(0xff60758F),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.companyName,
                          style: const TextStyle(
                            color: Color(0xff60758F),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildSection(
              title: "وصف الدواء",
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xff53657E),
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildSection(
              title: "معلومات الدواء",
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.event_outlined,
                    title: "تاريخ الانتهاء",
                    value: expiry,
                  ),

                  const Divider(height: 24, color: Color(0xffE8ECF2)),

                  _buildInfoRow(
                    icon: Icons.inventory_2_outlined,
                    title: "حالة التوفر",
                    value: "متوفر",
                    valueColor: const Color(0xff169967),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildPriceSection(),

            const SizedBox(height: 12),

            _buildQuantitySection(),
          ],
        ),

        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE4E9F0)),
      ),
      child: Image.asset(
        widget.product["image"]?.toString() ?? "",
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.medication_outlined,
            color: Color(0xff4F8B8A),
            size: 90,
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffE4E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 11),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xffF2F5F9),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 19, color: const Color(0xff60758F)),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Color(0xff53657E), fontSize: 13),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xff1A2F4D),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return _buildSection(
      title: hasOffer ? "العرض المتوفر" : "السعر",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (hasPriceOffer) ...[
                Text(
                  "${oldPrice!.toStringAsFixed(2)} ر.س",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Text(
                "${price.toStringAsFixed(2)} ر.س",
                style: const TextStyle(
                  color: Color(0xff169967),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              if (hasPriceOffer)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF2E3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "وفّرت ${(oldPrice! - price).toStringAsFixed(2)} ر.س",
                    style: const TextStyle(
                      color: Color(0xffE78324),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          if (hasBasicOffer) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xffFFF2E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                freeQuantity > 0
                    ? "حسب الكمية الحالية: $quantity مدفوع + $freeQuantity مجاني"
                    : offerText,
                style: const TextStyle(
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

  Widget _buildQuantitySection() {
    return _buildSection(
      title: "الكمية المطلوبة",
      child: Row(
        children: [
          Text(
            "اختاري عدد عبوات الدواء",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          const Spacer(),

          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffF3F6FA),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xffDCE3EC)),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuantityButton(
                  icon: Icons.remove,
                  onTap: quantity > 1 ? _decreaseQuantity : null,
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "$quantity",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff0A2954),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _buildQuantityButton(icon: Icons.add, onTap: _increaseQuantity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Icon(
          icon,
          size: 19,
          color: onTap == null ? Colors.grey.shade400 : const Color(0xff0A2954),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xffE5EAF1))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, quantity);
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 21),
                  label: const Text(
                    "إضافة إلى السلة",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0A2954),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الإجمالي",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  "${totalPrice.toStringAsFixed(2)} ر.س",
                  style: const TextStyle(
                    color: Color(0xff169967),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
