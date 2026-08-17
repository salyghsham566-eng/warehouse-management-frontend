import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/widgets/app_image.dart';
import 'package:project_2/Features/auth/bloc/offers_bloc.dart';
import 'package:project_2/Features/auth/bloc/offers_event.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_utils.dart';
import 'package:project_2/Features/auth/presentation/ChooseCompanyScreen.dart';
import 'package:project_2/Features/auth/presentation/choose_pharmacy_screen.dart';
import 'package:project_2/Features/auth/presentation/order_review_screen.dart';
import 'package:project_2/Features/auth/presentation/representative_offers_screen.dart';

class OrderCartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Map<String, Map<String, dynamic>>? cartItems;

  const OrderCartScreen({super.key, required this.items, this.cartItems});

  @override
  State<OrderCartScreen> createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> {
  final TextEditingController noteController = TextEditingController();

  // الصيدلية المرتبطة بالطلبية
  Map<String, dynamic>? selectedPharmacy;

  // جميع عناصر الطلبية: منتجات عادية + عروض + سلال ترويجية
  late List<Map<String, dynamic>> orderItems;

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "") ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  int _getFreeQuantity(Map<String, dynamic> item) {
    final dynamic offer = item["basicOffer"];

    if (offer is! Map) {
      return _toInt(item["freeQuantity"]);
    }

    final int buyQuantity = _toInt(offer["buyQuantity"]);
    final int freeQuantity = _toInt(offer["freeQuantity"]);
    final int quantity = _toInt(item["quantity"]);

    if (buyQuantity <= 0 || freeQuantity <= 0 || quantity <= 0) {
      return 0;
    }

    return (quantity ~/ buyQuantity) * freeQuantity;
  }

  Map<String, dynamic> _normalizeOrderItem(
    Map<String, dynamic> rawItem,
  ) {
    final Map<String, dynamic> item =
        normalizeCurrentOrderCartItem(
      Map<String, dynamic>.from(rawItem),
    );

    final String source =
        item["offerSource"]?.toString().trim() ?? "";

    if (source.isEmpty) {
      final String basketId =
          (item["promotionBasketId"] ?? item["promotion_basket_id"] ?? "")
              .toString();
      final String offerId =
          (item["offerId"] ?? item["offer_id"] ?? "").toString();

      if (basketId.isNotEmpty) {
        item["offerSource"] = "سلة ترويجية";
      } else if (offerId.isNotEmpty) {
        item["offerSource"] = "عرض ترويجي";
      } else if (_getFreeQuantity(item) > 0) {
        item["offerSource"] = "عرض صنف أساسي";
      }
    }

    return item;
  }

  Map<String, dynamic> _sharedCartEntry(
    Map<String, dynamic> rawItem,
  ) {
    final Map<String, dynamic> item = _normalizeOrderItem(rawItem);
    final int paidQuantity = _toInt(item["quantity"]);
    final int freeQuantity = _getFreeQuantity(item);
    final String cartKey = item["cartKey"]?.toString() ??
        buildCurrentOrderCartKey(item);

    item["cartKey"] = cartKey;
    item["freeQuantity"] = freeQuantity;
    item["totalQuantity"] = paidQuantity + freeQuantity;

    return {
      "product": Map<String, dynamic>.from(item)
        ..remove("cartKey")
        ..remove("quantity")
        ..remove("freeQuantity")
        ..remove("totalQuantity"),
      "cartKey": cartKey,
      "paidQuantity": paidQuantity,
      "freeQuantity": freeQuantity,
      "totalQuantity": paidQuantity + freeQuantity,
      "offerSource": item["offerSource"],
    };
  }

  // نحضر نسخة مشتركة من نفس الطلبية قبل فتح الشركات أو العروض.
  // نفس الـMap يمر بين كل الواجهات، لذلك أي إضافة ترجع لنفس الطلبية.
  Map<String, Map<String, dynamic>> _prepareSharedCartForCurrentOrder() {
    final Map<String, Map<String, dynamic>> sharedCart =
        widget.cartItems ?? <String, Map<String, dynamic>>{};

    sharedCart.clear();

    for (final rawItem in orderItems) {
      final Map<String, dynamic> entry = _sharedCartEntry(rawItem);
      final String cartKey = entry["cartKey"]?.toString() ?? "";

      if (cartKey.isNotEmpty) {
        sharedCart[cartKey] = entry;
      }
    }

    return sharedCart;
  }

  void _syncOrderItemsFromSharedCart(
    Map<String, Map<String, dynamic>> sharedCart,
  ) {
    final List<Map<String, dynamic>> updatedItems = [];

    for (final cartItem in sharedCart.values) {
      final dynamic rawProduct = cartItem["product"];

      if (rawProduct is! Map) {
        continue;
      }

      final Map<String, dynamic> product =
          Map<String, dynamic>.from(rawProduct);

      final Map<String, dynamic> item = _normalizeOrderItem({
        ...product,
        "cartKey": cartItem["cartKey"],
        "quantity": cartItem["paidQuantity"] ?? 1,
        "freeQuantity": cartItem["freeQuantity"] ?? 0,
        "totalQuantity": cartItem["totalQuantity"] ??
            cartItem["paidQuantity"] ??
            1,
        "offerSource": cartItem["offerSource"] ?? product["offerSource"],
        "discountPercent": product["discountPercent"] ?? 0,
      });

      updatedItems.add(item);
    }

    setState(() {
      orderItems = updatedItems;
    });
  }

  Future<void> _openCompaniesForCurrentOrder() async {
    final Map<String, Map<String, dynamic>> sharedCart =
        _prepareSharedCartForCurrentOrder();

    final int oldCount = sharedCart.length;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseCompanyPage(
          cartItems: sharedCart,
          returnToExistingOrder: true,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    _syncOrderItemsFromSharedCart(sharedCart);

    if (sharedCart.length > oldCount) {
      _showMessage("تمت إضافة الأصناف إلى الطلبية الحالية");
    }
  }

  Future<void> _openOffersAndDiscounts() async {
    final Map<String, Map<String, dynamic>> sharedCart =
        _prepareSharedCartForCurrentOrder();

    final int oldCount = sharedCart.length;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<OffersBloc>(
            create: (_) => sl<OffersBloc>()..add(LoadOffersEvent()),
            child: RepresentativeOffersScreen(
              selectForOrder: true,
              cartItems: sharedCart,
            ),
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    _syncOrderItemsFromSharedCart(sharedCart);

    if (sharedCart.length > oldCount) {
      _showMessage("تمت إضافة العروض والسلال إلى نفس الطلبية");
    }
  }

  double _getItemSubtotal(Map<String, dynamic> item) {
    final double price = _toDouble(item["price"]);
    final int quantity = _toInt(item["quantity"]);

    return price * quantity;
  }

  double _getItemDiscount(Map<String, dynamic> item) {
    final double subtotal = _getItemSubtotal(item);
    final double discountPercent = _toDouble(item["discountPercent"]);

    return subtotal * (discountPercent / 100);
  }

  double _getItemTotal(Map<String, dynamic> item) {
    return _getItemSubtotal(item) - _getItemDiscount(item);
  }

  double get subtotal {
    return orderItems.fold<double>(0, (sum, item) {
      return sum + _getItemSubtotal(item);
    });
  }

  double get totalDiscount {
    return orderItems.fold<double>(0, (sum, item) {
      return sum + _getItemDiscount(item);
    });
  }

  double get finalTotal {
    return subtotal - totalDiscount;
  }

  int get totalPaidQuantity {
    return orderItems.fold<int>(0, (sum, item) {
      return sum + _toInt(item["quantity"]);
    });
  }

  int get totalFreeQuantity {
    return orderItems.fold<int>(0, (sum, item) {
      return sum + _getFreeQuantity(item);
    });
  }

  void _syncCartItem(int index) {
    final Map<String, dynamic> item = _normalizeOrderItem(orderItems[index]);
    orderItems[index] = item;

    if (widget.cartItems == null) {
      return;
    }

    final Map<String, dynamic> entry = _sharedCartEntry(item);
    final String cartKey = entry["cartKey"]?.toString() ?? "";

    if (cartKey.isNotEmpty) {
      widget.cartItems![cartKey] = entry;
    }
  }

  void _increaseQuantity(int index) {
  if (isCurrentOrderFreeOnlyItem(orderItems[index])) {
    return;
  }

  setState(() {
    final int currentQuantity = _toInt(
      orderItems[index]["quantity"],
    );

    orderItems[index]["quantity"] =
        currentQuantity + 1;

    _syncCartItem(index);
  });
}
 void _decreaseQuantity(int index) {
  if (isCurrentOrderFreeOnlyItem(orderItems[index])) {
    return;
  }

  final int currentQuantity =
      _toInt(orderItems[index]["quantity"]);

  if (currentQuantity <= 1) {
    return;
  }

  setState(() {
    orderItems[index]["quantity"] =
        currentQuantity - 1;

    _syncCartItem(index);
  });
}

  void _deleteItem(int index) {
    setState(() {
      final String cartKey = orderItems[index]["cartKey"]?.toString() ?? "";

      if (cartKey.isNotEmpty) {
        widget.cartItems?.remove(cartKey);
      }

      orderItems.removeAt(index);
    });
  }

  Future<void> _changePharmacy() async {
    final Map<String, dynamic>? pharmacy =
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChoosePharmacyPage();
            },
          ),
        );

    if (!mounted || pharmacy == null) {
      return;
    }

    setState(() {
      selectedPharmacy = Map<String, dynamic>.from(pharmacy);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم ربط الطلبية مع ${pharmacy["name"]}")),
    );
  }

  Future<void> _previewOrder() async {
    if (orderItems.isEmpty) {
      _showMessage("لا توجد أصناف داخل الطلبية");
      return;
    }

    if (selectedPharmacy == null) {
      _showMessage("اختاري الصيدلية أولاً");
      return;
    }

    final Map<String, dynamic>? result =
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) => OrderReviewScreen(
              pharmacy: Map<String, dynamic>.from(selectedPharmacy!),

              // إرسال نسخة من أصناف السلة إلى المراجعة
              cartItems: orderItems
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList(),

              // إرسال الملاحظة المكتوبة في السلة
              initialNote: noteController.text,

              // تنفذ فقط بعد نجاح إرسال الطلبية
              onOrderSent: () {
                if (!mounted) {
                  return;
                }

                setState(() {
                  orderItems.clear();
                  widget.cartItems?.clear();
                  noteController.clear();
                  selectedPharmacy = null;
                });
              },
            ),
          ),
        );

    // في حال تم إرسال الطلبية وانتقلنا إلى شاشة النجاح
    // لن ترجع بيانات إلى السلة.
    if (!mounted || result == null) {
      return;
    }

    final dynamic returnedItems = result["items"];

    setState(() {
      // تحديث أصناف السلة بالكميات والحذف الذي حصل بالمراجعة
      if (returnedItems is List) {
        orderItems = returnedItems
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      // إعادة الملاحظة المعدلة من المراجعة إلى السلة
      noteController.text = result["note"]?.toString() ?? "";

      // مزامنة التعديلات مع السلة الأصلية في صفحات الأدوية
      if (widget.cartItems != null) {
        widget.cartItems!.clear();

        for (int index = 0; index < orderItems.length; index++) {
          _syncCartItem(index);
        }
      }
    });
  }

  void _sendOrder() {
    if (orderItems.isEmpty) {
      _showMessage("لا يمكن إرسال طلبية فارغة");
      return;
    }

    if (selectedPharmacy == null) {
      _showMessage("يجب اختيار الصيدلية أولاً");
      return;
    }

    final Map<String, dynamic> order = {
      "pharmacyId": selectedPharmacy!["id"],
      "pharmacy": selectedPharmacy,
      "items": orderItems,
      "note": noteController.text.trim(),
      "subtotal": subtotal,
      "discount": totalDiscount,
      "total": finalTotal,
      "status": "جديدة",
      "createdAt": DateTime.now().toIso8601String(),
    };

    debugPrint("ORDER: $order");

    _showMessage(
      "تم إرسال الطلبية إلى "
      "${selectedPharmacy!["name"]}",
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    orderItems = widget.items
        .map(
          (item) => _normalizeOrderItem(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    if (widget.cartItems != null) {
      widget.cartItems!.clear();

      for (final item in orderItems) {
        final Map<String, dynamic> entry = _sharedCartEntry(item);
        final String cartKey = entry["cartKey"]?.toString() ?? "";

        if (cartKey.isNotEmpty) {
          widget.cartItems![cartKey] = entry;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "سلة الطلبية",
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

        body: orderItems.isEmpty
            ? _buildEmptyCart()
            : ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                children: [
                  _buildPharmacyCard(),

                  const SizedBox(height: 12),

                  ...List.generate(orderItems.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildOrderItem(orderItems[index], index),
                    );
                  }),

                  _buildNoteCard(),

                  const SizedBox(height: 12),

                  _buildOrderSummary(),

                  const SizedBox(height: 90),
                ],
              ),

        bottomNavigationBar: _buildBottomButtons(),
      ),
    );
  }

  Widget _buildPharmacyCard() {
    if (selectedPharmacy == null) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xffEEF3FF),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xffDCE5F6)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.local_pharmacy_outlined,
              color: Color(0xff0A2954),
              size: 35,
            ),

            const SizedBox(height: 8),

            const Text(
              "لم يتم اختيار صيدلية",
              style: TextStyle(
                color: Color(0xff0A2954),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: _changePharmacy,
              child: const Text("اختيار الصيدلية"),
            ),
          ],
        ),
      );
    }

    final double dueAmount = _toDouble(selectedPharmacy!["dueAmount"]);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffEEF3FF),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffDCE5F6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xff0A2954),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "صيدلية العميل المختارة",
                  style: TextStyle(color: Color(0xff6C7A91), fontSize: 11),
                ),

                const SizedBox(height: 4),

                Text(
                  "${selectedPharmacy!["name"]} - "
                  "${selectedPharmacy!["branch"]}",
                  style: const TextStyle(
                    color: Color(0xff1A2F4D),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  selectedPharmacy!["address"]?.toString() ?? "",
                  style: const TextStyle(
                    color: Color(0xff60758F),
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _changePharmacy,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff0A2954),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 31),
                      ),
                      child: const Text(
                        "تغيير الصيدلية",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),

                    const Spacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "الرصيد المستحق",
                          style: TextStyle(
                            color: Color(0xff6C7A91),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "${dueAmount.toStringAsFixed(2)} ر.س",
                          style: TextStyle(
                            color: dueAmount > 0
                                ? const Color(0xffD83A3A)
                                : const Color(0xff169967),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item, int index) {
    final bool freeOnly =
    isCurrentOrderFreeOnlyItem(item);
    final int quantity = _toInt(item["quantity"]);

    final int freeQuantity = _getFreeQuantity(item);

    final double price = _toDouble(item["price"]);

    final double discount = _toDouble(item["discountPercent"]);

    final dynamic offer = item["basicOffer"];

    final String offerSource =
        item["offerSource"]?.toString().trim() ?? "";

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5EAF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              Container(
                width: 67,
                height: 76,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F6F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppImage(
  image: item["image"]?.toString(),
  fit: BoxFit.contain,
  fallbackIcon:
      Icons.medication_outlined,
  fallbackColor:
      const Color(0xff4F8B8A),
  fallbackSize: 38,
),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"].toString(),
                      style: const TextStyle(
                        color: Color(0xff1A2F4D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "شركة ${item["company"]}",
                      style: const TextStyle(
                        color: Color(0xff60758F),
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      item["scientificName"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff60758F),
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "تاريخ الانتهاء: "
                      "${item["expiry"]}",
                      style: const TextStyle(
                        color: Color(0xff53657E),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  _deleteItem(index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xff7D8796),
                  size: 20,
                ),
              ),
            ],
          ),

          const Divider(height: 22, color: Color(0xffE8ECF2)),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "سعر الوحدة",
                      style: TextStyle(color: Color(0xff7D8796), fontSize: 10),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${price.toStringAsFixed(2)} ر.س",
                      style: const TextStyle(
                        color: Color(0xff1A2F4D),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              if (discount > 0)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "الخصم",
                        style: TextStyle(
                          color: Color(0xff7D8796),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${discount.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Color(0xff169967),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffEEF3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                     onPressed: freeOnly
    ? null
    : () {
        _decreaseQuantity(index);
      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 36,
                      ),
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xff0A2954),
                        size: 19,
                      ),
                    ),

                    SizedBox(
                      width: 28,
                      child: Text(
                        "$quantity",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff0A2954),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                     onPressed: freeOnly
    ? null
    : () {
        _increaseQuantity(index);
      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 36,
                      ),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xff0A2954),
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (offerSource.isNotEmpty) ...[
            const SizedBox(height: 11),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xffF2ECFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: Color(0xff7A5AF8),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      offerSource,
                      style: const TextStyle(
                        color: Color(0xff6D50D3),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
if (freeOnly && freeQuantity > 0) ...[
  const SizedBox(height: 11),

  Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: const Color(0xffE8F8EF),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      "صنف مجاني ضمن السلة — الكمية المجانية: $freeQuantity",
      style: const TextStyle(
        color: Color(0xff169967),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
],
          if (offer is Map && freeQuantity > 0) ...[
            const SizedBox(height: 11),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xffE8F8EF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "عرض صنف أساسي "
                "${offer["buyQuantity"]}"
                "+${offer["freeQuantity"]} — "
                "الكمية المجانية: $freeQuantity",
                style: const TextStyle(
                  color: Color(0xff169967),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          const SizedBox(height: 11),

          Row(
            children: [
              const Text(
                "إجمالي الصنف",
                style: TextStyle(color: Color(0xff53657E), fontSize: 11),
              ),

              const Spacer(),

              Text(
                "${_getItemTotal(item).toStringAsFixed(2)} ر.س",
                style: const TextStyle(
                  color: Color(0xff0A2954),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE5EAF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ملاحظة المندوب أو الإدارة",
            style: TextStyle(
              color: Color(0xff1A2F4D),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "اكتب أي ملاحظة تخص الطلبية...",
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              filled: true,
              fillColor: const Color(0xffF6F8FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE5EAF1)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            title: "عدد الأصناف",
            value: "${orderItems.length} صنف",
          ),

          _buildSummaryRow(
            title: "إجمالي الكميات المدفوعة",
            value: "$totalPaidQuantity عبوة",
          ),

          if (totalFreeQuantity > 0)
            _buildSummaryRow(
              title: "الكمية المجانية",
              value: "$totalFreeQuantity عبوة",
              valueColor: const Color(0xff169967),
            ),

          const Divider(height: 22),

          _buildSummaryRow(
            title: "المجموع قبل الخصم",
            value: "${subtotal.toStringAsFixed(2)} ر.س",
          ),

          _buildSummaryRow(
            title: "قيمة الخصم",
            value: "- ${totalDiscount.toStringAsFixed(2)} ر.س",
            valueColor: const Color(0xff169967),
          ),

          const Divider(height: 22),

          _buildSummaryRow(
            title: "الإجمالي النهائي",
            value: "${finalTotal.toStringAsFixed(2)} ر.س",
            isBold: true,
            valueColor: const Color(0xff0A2954),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xff53657E),
              fontSize: isBold ? 13 : 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xff1A2F4D),
              fontSize: isBold ? 15 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xffE3E8F0))),
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
                height: 44,
                child: OutlinedButton(
                  onPressed:
      _openCompaniesForCurrentOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff0A2954),
                    side: const BorderSide(color: Color(0xffAEB8C7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    "إضافة أصناف",
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _openOffersAndDiscounts,
                  icon: const Icon(
                    Icons.local_offer_outlined,
                    size: 16,
                  ),
                  label: const Text(
                    "العروض",
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff7A5AF8),
                    side: const BorderSide(color: Color(0xffB7A7F8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _previewOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff57D5A0),
                    foregroundColor: const Color(0xff0A4D38),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    "مراجعة الطلبية",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          const Text(
            "سلة الطلبية فارغة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "أضيفي الأدوية أولاً",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("العودة إلى الأدوية"),
          ),
        ],
      ),
    );
  }
}
