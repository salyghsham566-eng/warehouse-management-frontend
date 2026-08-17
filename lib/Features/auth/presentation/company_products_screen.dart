import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/OrdersScreen.dart';

import 'package:project_2/Features/auth/bloc/current_order_cart_bloc.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_event.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_utils.dart';

import 'package:project_2/Features/auth/presentation/drug_details_screen.dart';
import 'package:project_2/Core/widgets/app_image.dart';
enum ProductFilter {
  all,
  offers,
  nooffers,
  expiry,
}

class CompanyProductsScreen
    extends StatefulWidget {
  final Map<String, dynamic> company;

  final Map<
      String,
      Map<String, dynamic>> cartItems;

  final bool returnToExistingOrder;

  const CompanyProductsScreen({
    super.key,
    required this.cartItems,
    required this.company,
    this.returnToExistingOrder = false,
  });

  @override
  State<CompanyProductsScreen>
      createState() =>
          _CompanyProductsScreenState();
}

class _CompanyProductsScreenState
    extends State<CompanyProductsScreen> {
  final TextEditingController searchController =
      TextEditingController();

  ProductFilter selectedFilter =
      ProductFilter.all;

  // =========================================================
  // الكميات التي يختارها المستخدم قبل الضغط على إضافة للسلة
  // =========================================================

  final Map<String, int> productQuantities = {};

  // =========================================================
  // Product Key
  // =========================================================
void _syncProductQuantitiesFromCart() {
  productQuantities.clear();

  final String currentCompanyId =
      (widget.company["id"] ?? widget.company["name"] ?? "").toString();

  for (final cartItem in widget.cartItems.values) {
    final dynamic rawProduct = cartItem["product"];

    if (rawProduct is! Map) {
      continue;
    }

    final Map<String, dynamic> product =
        Map<String, dynamic>.from(rawProduct);

    final String productCompanyId =
        (product["companyId"] ?? product["company_id"] ?? product["company"] ?? "")
            .toString();

    if (productCompanyId.isNotEmpty &&
        currentCompanyId.isNotEmpty &&
        productCompanyId != currentCompanyId) {
      continue;
    }

    final String source = getCurrentOrderItemSource(product);

    if (source != "normal") {
      continue;
    }

    final int quantity = cartValueToInt(cartItem["paidQuantity"]);

    if (quantity > 0) {
      productQuantities[_getProductKey(product)] = quantity;
    }
  }
}

  @override
  void initState() {
    super.initState();
    _syncProductQuantitiesFromCart();
  }

  String _getProductKey(
    Map<String, dynamic> product,
  ) {
    final String companyKey =
        (
          widget.company["id"] ??
          widget.company["name"] ??
          ""
        ).toString();

    final String productKey =
        (
          product["id"] ??
          product["product_id"] ??
          product["name"] ??
          ""
        ).toString();

    return "$companyKey-$productKey";
  }

  // =========================================================
  // Build Normal Order Item
  // =========================================================
List<Map<String, dynamic>> _prepareOrderItems() {
  return widget.cartItems.values.map(
    (cartItem) {
      final dynamic rawProduct =
          cartItem["product"];

      if (rawProduct is! Map) {
        return <String, dynamic>{};
      }

      final Map<String, dynamic> product =
          Map<String, dynamic>.from(
        rawProduct,
      );

      return {
        ...product,

        "cartKey":
            cartItem["cartKey"],

        "quantity":
            cartItem["paidQuantity"] ??
            1,

        "freeQuantity":
            cartItem["freeQuantity"] ??
            0,

        "totalQuantity":
            cartItem["totalQuantity"] ??
            cartItem["paidQuantity"] ??
            1,

        "offerSource":
            cartItem["offerSource"] ??
            product["offerSource"],

        "company":
            product["company"] ??
            widget.company["name"]
                ?.toString() ??
            "",

        "companyId":
            product["companyId"] ??
            widget.company["id"],

        "discountPercent":
            product["discountPercent"] ??
            0,

        "offerId":
            product["offerId"] ??
            product["offer_id"],

        "promotionBasketId":
            product["promotionBasketId"] ??
            product[
                "promotion_basket_id"],
      };
    },
  ).where(
    (item) => item.isNotEmpty,
  ).toList();
}
  Map<String, dynamic> _buildOrderItem(
    Map<String, dynamic> product,
    int paidQuantity,
  ) {
    return {
      ...product,

      "product_id":
          product["product_id"] ??
          product["id"],

      "companyId":
          widget.company["id"],

      "company":
          widget.company["name"]
                  ?.toString() ??
              "",

      "quantity":
          paidQuantity,

      "discountPercent":
          product["discountPercent"] ??
          0,

      // لأنه دخل من شاشة المنتجات العادية
      "cartSource":
          "normal",
    };
  }

  // =========================================================
  // Current Product Quantity
  // =========================================================

  int _getProductQuantity(
    Map<String, dynamic> product,
  ) {
    final String productKey = _getProductKey(product);

    final int? localQuantity = productQuantities[productKey];

    if (localQuantity != null && localQuantity > 0) {
      return localQuantity;
    }

    final Map<String, dynamic> probeItem = _buildOrderItem(
      product,
      1,
    );

    final String cartKey = buildCurrentOrderCartKey(probeItem);
    final Map<String, dynamic>? sharedItem = widget.cartItems[cartKey];

    if (sharedItem != null) {
      final int quantity = cartValueToInt(sharedItem["paidQuantity"]);

      if (quantity > 0) {
        return quantity;
      }
    }

    return 1;
  }

  // =========================================================
  // Helpers
  // =========================================================

  int _asInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  double _asDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? "",
        ) ??
        0;
  }

  double? _asNullableDouble(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  // =========================================================
  // Basic Offer
  //
  // مثال:
  // كل 10 حبات + 2 مجاني
  // =========================================================

  Map<String, int>? _getBasicOffer(
    Map<String, dynamic> product,
  ) {
    final dynamic offerData =
        product["basicOffer"];

    if (offerData is! Map) {
      return null;
    }

    final int buyQuantity =
        _asInt(
      offerData["buyQuantity"],
    );

    final int freeQuantity =
        _asInt(
      offerData["freeQuantity"],
    );

    if (buyQuantity <= 0 ||
        freeQuantity <= 0) {
      return null;
    }

    return {
      "buyQuantity":
          buyQuantity,

      "freeQuantity":
          freeQuantity,
    };
  }

  // =========================================================
  // هل المنتج عليه عرض؟
  // =========================================================

  bool _hasAnyOffer(
    Map<String, dynamic> product,
  ) {
    final bool hasOldPrice =
        product["oldPrice"] != null;

    final bool hasBasicOffer =
        _getBasicOffer(
          product,
        ) !=
        null;

    final double discountPercent =
        _asDouble(
      product["discountPercent"],
    );

    return hasOldPrice ||
        hasBasicOffer ||
        discountPercent > 0;
  }

  // =========================================================
  // Free Quantity
  // =========================================================

  int _getFreeQuantityForPaidQuantity(
    Map<String, dynamic> product,
    int paidQuantity,
  ) {
    final Map<String, int>? offerData =
        _getBasicOffer(
      product,
    );

    if (offerData == null) {
      return 0;
    }

    final int buyQuantity =
        offerData["buyQuantity"]!;

    final int freePerOffer =
        offerData["freeQuantity"]!;

    if (buyQuantity <= 0 ||
        freePerOffer <= 0 ||
        paidQuantity <= 0) {
      return 0;
    }

    return (paidQuantity ~/ buyQuantity) *
        freePerOffer;
  }

  // =========================================================
  // Build Cart Item
  // =========================================================

  Map<String, dynamic> _buildCartItem(
    Map<String, dynamic> product,
    int paidQuantity,
  ) {
    final Map<String, dynamic> item =
        _buildOrderItem(
      product,
      paidQuantity,
    );

    final int freeQuantity =
        _getFreeQuantityForPaidQuantity(
      product,
      paidQuantity,
    );

    item["freeQuantity"] =
        freeQuantity;

    item["totalQuantity"] =
        paidQuantity +
        freeQuantity;

    if (freeQuantity > 0) {
      item["offerSource"] =
          "عرض صنف أساسي";
    }

    return normalizeCurrentOrderCartItem(
      item,
    );
  }

  // =========================================================
  // Set Quantity
  // =========================================================

  void _setProductQuantity(
    Map<String, dynamic> product,
    int paidQuantity,
  ) {
    if (paidQuantity < 1) {
      return;
    }

    final String productKey =
        _getProductKey(
      product,
    );

    setState(() {
      productQuantities[productKey] =
          paidQuantity;
    });
  }

  // =========================================================
  // Increase
  // =========================================================

  void _increaseQuantity(
    Map<String, dynamic> product,
  ) {
    final int currentQuantity =
        _getProductQuantity(
      product,
    );

    _setProductQuantity(
      product,
      currentQuantity + 1,
    );
  }

  // =========================================================
  // Decrease
  // =========================================================

  void _decreaseQuantity(
    Map<String, dynamic> product,
  ) {
    final int currentQuantity =
        _getProductQuantity(
      product,
    );

    if (currentQuantity <= 1) {
      return;
    }

    _setProductQuantity(
      product,
      currentQuantity - 1,
    );
  }

  // =========================================================
  // Product Details
  // =========================================================

  Future<void> _openProductDetails(
    Map<String, dynamic> product,
  ) async {
    final int? selectedQuantity =
        await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DrugDetailsScreen(
          product:
              product,

          companyName:
              widget.company["name"]
                      ?.toString() ??
                  "",

          initialQuantity:
              _getProductQuantity(
            product,
          ),
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (selectedQuantity == null ||
        selectedQuantity <= 0) {
      return;
    }

    _addProductToCart(
      product,
      selectedQuantity,
    );
  }

  // =========================================================
  // All Products
  // =========================================================

  List<Map<String, dynamic>> get allProducts {
    final dynamic productsData =
        widget.company["products"];

    if (productsData == null) {
      return [];
    }

    if (productsData is List) {
      return productsData
          .map(
            (product) {
              if (product
                  is Map<String, dynamic>) {
                return product;
              }

              if (product is Map) {
                return Map<String, dynamic>.from(
                  product,
                );
              }

              return <String, dynamic>{};
            },
          )
          .where(
            (product) =>
                product.isNotEmpty,
          )
          .toList();
    }

    return [];
  }

  // =========================================================
  // Filtered Products
  // =========================================================

  List<Map<String, dynamic>>
      get filteredProducts {
    final String searchText =
        searchController.text
            .trim()
            .toLowerCase();

    List<Map<String, dynamic>> result =
        allProducts.where(
      (
        Map<String, dynamic> product,
      ) {
        final String productName =
            product["name"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        final String scientificName =
            product["scientificName"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        return productName.contains(
              searchText,
            ) ||
            scientificName.contains(
              searchText,
            );
      },
    ).toList();

    switch (selectedFilter) {
      case ProductFilter.offers:
        result =
            result.where(
          (
            Map<String, dynamic> product,
          ) {
            return _hasAnyOffer(
              product,
            );
          },
        ).toList();

        break;

      case ProductFilter.nooffers:
        result =
            result.where(
          (
            Map<String, dynamic> product,
          ) {
            return !_hasAnyOffer(
              product,
            );
          },
        ).toList();

        break;

      case ProductFilter.expiry:
        result.sort(
          (
            Map<String, dynamic> first,
            Map<String, dynamic> second,
          ) {
            final DateTime firstDate =
                _parseExpiry(
              first["expiry"]
                      ?.toString() ??
                  "",
            );

            final DateTime secondDate =
                _parseExpiry(
              second["expiry"]
                      ?.toString() ??
                  "",
            );

            return firstDate.compareTo(
              secondDate,
            );
          },
        );

        break;

      case ProductFilter.all:
        break;
    }

    return result;
  }

  // =========================================================
  // Expiry
  // =========================================================

  DateTime _parseExpiry(
    String expiry,
  ) {
    try {
      final List<String> parts =
          expiry.split("/");

      if (parts.length < 2) {
        return DateTime(
          2100,
        );
      }

      final int month =
          int.parse(
        parts[0],
      );

      final int year =
          int.parse(
        parts[1],
      );

      return DateTime(
        year,
        month,
      );
    } catch (_) {
      return DateTime(
        2100,
      );
    }
  }

  void _saveItemToSharedCart(
    Map<String, dynamic> rawItem,
  ) {
    final Map<String, dynamic> item =
        normalizeCurrentOrderCartItem(
      Map<String, dynamic>.from(rawItem),
    );

    final String cartKey = item["cartKey"]?.toString() ?? "";

    if (cartKey.isEmpty) {
      return;
    }

    final int paidQuantity = cartValueToInt(item["quantity"]);
    final int freeQuantity = cartValueToInt(item["freeQuantity"]);

    widget.cartItems[cartKey] = {
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

  // =========================================================
  // Add Product To Current Shared Order
  // =========================================================

  void _addProductToCart(
    Map<String, dynamic> product,
    int selectedQuantity,
  ) {
    final String productKey =
        _getProductKey(
      product,
    );

    final int paidQuantity =
        selectedQuantity;

    final Map<String, dynamic> cartItem =
        _buildCartItem(
      product,
      paidQuantity,
    );

    final int freeQuantity =
        cartValueToInt(
      cartItem["freeQuantity"],
    );

    // =====================================================
    // الإضافة إلى الطلبية المشتركة
    // =====================================================

    context
        .read<CurrentOrderCartBloc>()
        .add(
          AddOrUpdateCurrentOrderItemEvent(
            item:
                cartItem,
          ),
        );

    _saveItemToSharedCart(cartItem);

    setState(() {
      productQuantities[productKey] =
          paidQuantity;
    });

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    if (freeQuantity > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          duration:
              const Duration(
            seconds: 2,
          ),

          content:
              Text(
            "تمت إضافة $paidQuantity من "
            "${product["name"] ?? "الصنف"} "
            "+ $freeQuantity مجاناً",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          duration:
              const Duration(
            seconds: 1,
          ),

          content:
              Text(
            "تمت إضافة $selectedQuantity من "
            "${product["name"] ?? "الصنف"} إلى السلة",
          ),
        ),
      );
    }
  }

  // =========================================================
  // Dispose
  // =========================================================

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // -------------------------------------------------------
    // نراقب تغير السلة حتى يتحدث Badge مباشرة
    // -------------------------------------------------------

    final int cartCount = widget.cartItems.values.fold<int>(
      0,
      (sum, item) =>
          sum + cartValueToInt(item["totalQuantity"] ?? item["paidQuantity"]),
    );

    final List<Map<String, dynamic>>
        products =
        filteredProducts;

    return Directionality(
      textDirection:
          TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
            const Color(
          0xffF5F7FC,
        ),

        appBar: AppBar(
          backgroundColor:
              Colors.white,

          surfaceTintColor:
              Colors.white,

          elevation:
              0,

          leading:
              IconButton(
            onPressed:
                () {
              Navigator.pop(
                context,
              );
            },

            icon:
                const Icon(
              Icons.arrow_back,

              color:
                  Color(
                0xff0A2954,
              ),
            ),
          ),

          title:
              const Text(
            "إدارة الطلبات",

            style:
                TextStyle(
              color:
                  Color(
                0xff0A2954,
              ),

              fontSize:
                  18,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          centerTitle:
              true,

          actions: [
            Stack(
              clipBehavior:
                  Clip.none,

              children: [
                IconButton(
                  onPressed: () async {
  final items =
      _prepareOrderItems();

  if (items.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "السلة فارغة، أضيفي دواء أولاً",
        ),
      ),
    );

    return;
  }

  // =====================================================
  // نحن جايين من طلبية موجودة
  //
  // ما منفتح OrderCartScreen جديد
  // منرجع للطلبية الأصلية
  // =====================================================

  if (widget.returnToExistingOrder) {
    Navigator.pop(
      context,
      true,
    );

    return;
  }

  // =====================================================
  // المسار القديم الطبيعي
  // =====================================================

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          OrderCartScreen(
        items: items,
        cartItems:
            widget.cartItems,
      ),
    ),
  );

  if (mounted) {
    _syncProductQuantitiesFromCart();

    setState(() {});
  }
},

                  icon:
                      const Icon(
                    Icons
                        .shopping_cart_outlined,

                    color:
                        Color(
                      0xff0A2954,
                    ),
                  ),
                ),

                if (cartCount > 0)
                  Positioned(
                    top:
                        3,

                    right:
                        3,

                    child:
                        Container(
                      width:
                          17,

                      height:
                          17,

                      alignment:
                          Alignment.center,

                      decoration:
                          const BoxDecoration(
                        color:
                            Color(
                          0xff22B573,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          Text(
                        "$cartCount",

                        style:
                            const TextStyle(
                          color:
                              Colors.white,

                          fontSize:
                              10,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(
              width:
                  4,
            ),
          ],
        ),

        body:
            Column(
          children: [
            _buildCompanyHeader(),

            _buildSearchField(),

            _buildFilters(),

            const SizedBox(
              height:
                  8,
            ),

            Expanded(
              child:
                  products.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(
                            12,
                            4,
                            12,
                            20,
                          ),

                          itemCount:
                              products.length,

                          separatorBuilder:
                              (
                            context,
                            index,
                          ) =>
                                  const SizedBox(
                            height:
                                10,
                          ),

                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            return _buildProductCard(
                              products[index],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Company Header
  // =========================================================

  Widget _buildCompanyHeader() {
    final String companyName =
        widget.company["name"]
                ?.toString() ??
            "";

    final int productsCount =
        allProducts.length;

    return Container(
      width:
          double.infinity,

      color:
          Colors.white,

      padding:
          const EdgeInsets.only(
        left:
            16,

        right:
            16,

        bottom:
            12,
      ),

      child:
          Column(
        children: [
          Text(
            companyName,

            style:
                const TextStyle(
              color:
                  Color(
                0xff34465F,
              ),

              fontSize:
                  14,

              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height:
                3,
          ),

          Text(
            "$productsCount منتج متاح",

            style:
                TextStyle(
              color:
                  Colors.grey.shade600,

              fontSize:
                  12,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Search
  // =========================================================

  Widget _buildSearchField() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        8,
      ),

      child:
          TextField(
        controller:
            searchController,

        onChanged:
            (_) {
          setState(
            () {},
          );
        },

        decoration:
            InputDecoration(
          hintText:
              "بحث عن دواء",

          hintStyle:
              TextStyle(
            color:
                Colors.grey.shade500,

            fontSize:
                13,
          ),

          prefixIcon:
              const Icon(
            Icons.search,

            color:
                Color(
              0xff60758F,
            ),

            size:
                21,
          ),

          suffixIcon:
              searchController
                      .text
                      .isNotEmpty
                  ? IconButton(
                      onPressed:
                          () {
                        searchController
                            .clear();

                        setState(
                          () {},
                        );
                      },

                      icon:
                          const Icon(
                        Icons.close,

                        size:
                            19,
                      ),
                    )
                  : null,

          filled:
              true,

          fillColor:
              Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical:
                11,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              11,
            ),

            borderSide:
                const BorderSide(
              color:
                  Color(
                0xffDDE3EC,
              ),
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              11,
            ),

            borderSide:
                const BorderSide(
              color:
                  Color(
                0xff0A2954,
              ),

              width:
                  1.3,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Filters
  // =========================================================

  Widget _buildFilters() {
    return SizedBox(
      height:
          42,

      child:
          ListView(
        scrollDirection:
            Axis.horizontal,

        padding:
            const EdgeInsets.symmetric(
          horizontal:
              12,
        ),

        children: [
          _buildFilterChip(
            title:
                "الكل",

            filter:
                ProductFilter.all,
          ),

          _buildFilterChip(
            title:
                "عليها عروض",

            filter:
                ProductFilter.offers,
          ),

          _buildFilterChip(
            title:
                "بدون عروض",

            filter:
                ProductFilter.nooffers,
          ),

          _buildFilterChip(
            title:
                "حسب تاريخ الانتهاء",

            filter:
                ProductFilter.expiry,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Filter Chip
  // =========================================================

  Widget _buildFilterChip({
    required String title,
    required ProductFilter filter,
  }) {
    final bool isSelected =
        selectedFilter ==
        filter;

    return Padding(
      padding:
          const EdgeInsets.only(
        left:
            8,
      ),

      child:
          ChoiceChip(
        selected:
            isSelected,

        showCheckmark:
            false,

        onSelected:
            (_) {
          setState(
            () {
              selectedFilter =
                  filter;
            },
          );
        },

        label:
            Text(
          title,
        ),

        backgroundColor:
            Colors.white,

        selectedColor:
            const Color(
          0xff062B57,
        ),

        side:
            BorderSide(
          color:
              isSelected
                  ? const Color(
                      0xff062B57,
                    )
                  : const Color(
                      0xffD9E0EA,
                    ),
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        labelStyle:
            TextStyle(
          color:
              isSelected
                  ? Colors.white
                  : const Color(
                      0xff53657E,
                    ),

          fontSize:
              12,

          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  // =========================================================
  // Product Card
  // =========================================================

  Widget _buildProductCard(
    Map<String, dynamic> product,
  ) {
    final double price =
        _asDouble(
      product["price"],
    );

    final double? oldPrice =
        _asNullableDouble(
      product["oldPrice"],
    );

    final bool hasPriceOffer =
        oldPrice != null;

    final Map<String, int>? basicOffer =
        _getBasicOffer(
      product,
    );

    final bool hasBasicOffer =
        basicOffer != null;

    final double discountPercent =
        _asDouble(
      product["discountPercent"],
    );

    final bool hasOffer =
        hasPriceOffer ||
        hasBasicOffer ||
        discountPercent > 0;

    final int quantity =
        _getProductQuantity(
      product,
    );

    return InkWell(
      onTap:
          () {
        _openProductDetails(
          product,
        );
      },

      borderRadius:
          BorderRadius.circular(
        13,
      ),

      child:
          Container(
        padding:
            const EdgeInsets.all(
          11,
        ),

        decoration:
            BoxDecoration(
          color:
              Colors.white,

          borderRadius:
              BorderRadius.circular(
            13,
          ),

          border:
              Border.all(
            color:
                const Color(
              0xffE7EBF2,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withOpacity(
                0.035,
              ),

              blurRadius:
                  8,

              offset:
                  const Offset(
                0,
                3,
              ),
            ),
          ],
        ),

        child:
            Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _buildProductImage(
              product,
            ),

            const SizedBox(
              width:
                  11,
            ),

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // =========================================
                  // Name
                  // =========================================

                  Row(
                    children: [
                      Expanded(
                        child:
                            Text(
                          product["name"]
                                  ?.toString() ??
                              "",

                          maxLines:
                              1,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xff1A2F4D,
                            ),

                            fontSize:
                                14,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      if (hasOffer)
                        Container(
                          margin:
                              const EdgeInsets.only(
                            right:
                                6,
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                7,

                            vertical:
                                3,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xffDFF7EA,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              6,
                            ),
                          ),

                          child:
                              const Text(
                            "عرض خاص",

                            style:
                                TextStyle(
                              color:
                                  Color(
                                0xff15965D,
                              ),

                              fontSize:
                                  9,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        3,
                  ),

                  // =========================================
                  // Scientific Name
                  // =========================================

                  Text(
                    product["scientificName"]
                            ?.toString() ??
                        "",

                    maxLines:
                        1,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        TextStyle(
                      color:
                          Colors.grey.shade600,

                      fontSize:
                          11,

                      fontStyle:
                          FontStyle.italic,
                    ),
                  ),

                  const SizedBox(
                    height:
                        5,
                  ),

                  // =========================================
                  // Description
                  // =========================================

                  Text(
                    product["description"]
                            ?.toString() ??
                        "",

                    maxLines:
                        2,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xff5D6B7E,
                      ),

                      fontSize:
                          11,
                    ),
                  ),

                  const SizedBox(
                    height:
                        5,
                  ),

                  // =========================================
                  // Basic Offer
                  // =========================================

                  if (basicOffer != null)
                    Container(
                      margin:
                          const EdgeInsets.only(
                        bottom:
                            6,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            8,

                        vertical:
                            4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xffFFF2E3,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          7,
                        ),
                      ),

                      child:
                          Text(
                        "عرض: كل ${basicOffer["buyQuantity"]} حبات "
                        "+ ${basicOffer["freeQuantity"]} مجاني",

                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xffE78324,
                          ),

                          fontSize:
                              10,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                  // =========================================
                  // Discount %
                  // =========================================

                  if (discountPercent > 0)
                    Container(
                      margin:
                          const EdgeInsets.only(
                        bottom:
                            6,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            8,

                        vertical:
                            4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xffDFF7EA,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          7,
                        ),
                      ),

                      child:
                          Text(
                        "خصم ${discountPercent.toStringAsFixed(0)}%",

                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xff15965D,
                          ),

                          fontSize:
                              10,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                  // =========================================
                  // Expiry
                  // =========================================

                  Row(
                    children: [
                      const Icon(
                        Icons.event_outlined,

                        size:
                            15,

                        color:
                            Color(
                          0xff60758F,
                        ),
                      ),

                      const SizedBox(
                        width:
                            4,
                      ),

                      Expanded(
                        child:
                            Text(
                          "تاريخ الانتهاء: ${product["expiry"] ?? "-"}",

                          maxLines:
                              1,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xff5D6B7E,
                            ),

                            fontSize:
                                11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        6,
                  ),

                  // =========================================
                  // Price
                  // =========================================

                  Row(
                    children: [
                      if (hasPriceOffer) ...[
                        Text(
                          oldPrice.toStringAsFixed(
                            2,
                          ),

                          style:
                              TextStyle(
                            color:
                                Colors.grey.shade500,

                            fontSize:
                                11,

                            decoration:
                                TextDecoration.lineThrough,
                          ),
                        ),

                        const SizedBox(
                          width:
                              7,
                        ),
                      ],

                      Text(
                        "${price.toStringAsFixed(2)} ر.س",

                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xff169967,
                          ),

                          fontSize:
                              12,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              width:
                  8,
            ),

            // ===============================================
            // Quantity + Add
            // ===============================================

            Padding(
              padding:
                  const EdgeInsets.only(
                top:
                    32,
              ),

              child:
                  Column(
                children: [
                  // =========================================
                  // Quantity Selector
                  // =========================================

                  Container(
                    height:
                        32,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xffF3F6FA,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),

                      border:
                          Border.all(
                        color:
                            const Color(
                          0xffDCE3EC,
                        ),
                      ),
                    ),

                    child:
                        Row(
                      mainAxisSize:
                          MainAxisSize.min,

                      textDirection:
                          TextDirection.ltr,

                      children: [
                        // -----------------------------------
                        // Minus
                        // -----------------------------------

                        InkWell(
                          onTap:
                              quantity > 1
                                  ? () {
                                      _decreaseQuantity(
                                        product,
                                      );
                                    }
                                  : null,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          child:
                              SizedBox(
                            width:
                                27,

                            height:
                                32,

                            child:
                                Icon(
                              Icons.remove,

                              size:
                                  16,

                              color:
                                  quantity > 1
                                      ? const Color(
                                          0xff0A2954,
                                        )
                                      : Colors
                                          .grey
                                          .shade400,
                            ),
                          ),
                        ),

                        // -----------------------------------
                        // Quantity
                        // -----------------------------------

                        SizedBox(
                          width:
                              25,

                          child:
                              Text(
                            "$quantity",

                            textAlign:
                                TextAlign.center,

                            style:
                                const TextStyle(
                              color:
                                  Color(
                                0xff0A2954,
                              ),

                              fontSize:
                                  13,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        // -----------------------------------
                        // Plus
                        // -----------------------------------

                        InkWell(
                          onTap:
                              () {
                            _increaseQuantity(
                              product,
                            );
                          },

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          child:
                              const SizedBox(
                            width:
                                27,

                            height:
                                32,

                            child:
                                Icon(
                              Icons.add,

                              size:
                                  16,

                              color:
                                  Color(
                                0xff0A2954,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                        7,
                  ),

                  // =========================================
                  // Add To Cart
                  // =========================================

                  InkWell(
                    onTap:
                        () {
                      _addProductToCart(
                        product,
                        quantity,
                      );
                    },

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    child:
                        Container(
                      width:
                          38,

                      height:
                          38,

                      decoration:
                          const BoxDecoration(
                        color:
                            Color(
                          0xff0A2954,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child:
                          const Icon(
                        Icons.add_shopping_cart,

                        color:
                            Colors.white,

                        size:
                            19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Product Image
  // =========================================================

  Widget _buildProductImage(
    Map<String, dynamic> product,
  ) {
    final String image =
        product["image"]
                ?.toString() ??
            "";

    return Container(
      width:
          72,

      height:
          85,

      padding:
          const EdgeInsets.all(
        6,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xffF1F6F7,
        ),

        borderRadius:
            BorderRadius.circular(
          10,
        ),
      ),

      child: AppImage(
  image: image,
  fit: BoxFit.contain,
  fallbackIcon:
      Icons.medication_outlined,
  fallbackColor:
      const Color(0xff4F8B8A),
  fallbackSize: 36,
),
    );
  }

  // =========================================================
  // Empty State
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child:
          Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            Icons.medication_outlined,

            size:
                65,

            color:
                Colors.grey.shade400,
          ),

          const SizedBox(
            height:
                12,
          ),

          const Text(
            "لا توجد أدوية مطابقة",

            style:
                TextStyle(
              color:
                  Color(
                0xff0A2954,
              ),

              fontSize:
                  17,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height:
                5,
          ),

          Text(
            "غيّري كلمة البحث أو الفلتر",

            style:
                TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}