import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/promotional_basket_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/promotional_basket_details_event.dart';
import 'package:project_2/Features/auth/bloc/promotional_basket_details_state.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_utils.dart';

import 'package:project_2/Features/auth/data/models/promotional_basket_details_model.dart';

import 'package:project_2/OrdersScreen.dart';

// =========================================================
// Page
// =========================================================

class PromotionalBasketDetailsPage
    extends StatelessWidget {
  final String basketId;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const PromotionalBasketDetailsPage({
    super.key,
    required this.basketId,
    this.selectForOrder = false,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        PromotionalBasketDetailsBloc>(
      create: (_) =>
          sl<
              PromotionalBasketDetailsBloc>()
            ..add(
              LoadPromotionalBasketDetailsEvent(
                basketId:
                    basketId,
              ),
            ),

      child:
          PromotionalBasketDetailsScreen(
            selectForOrder: selectForOrder,
            cartItems: cartItems,
          ),
    );
  }
}

// =========================================================
// Screen
// =========================================================

class PromotionalBasketDetailsScreen
    extends StatelessWidget {
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const PromotionalBasketDetailsScreen({
    super.key,
    this.selectForOrder = false,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
            AppColors.background,

        appBar: AppBar(
          backgroundColor:
              Colors.white,

          surfaceTintColor:
              Colors.white,

          elevation:
              0,

          centerTitle:
              true,

          foregroundColor:
              AppColors.primary,

          title:
              const Text(
            'تفاصيل السلة الترويجية',

            style:
                TextStyle(
              color:
                  AppColors.textPrimary,

              fontSize:
                  18,

              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            PromotionalBasketDetailsBloc,
            PromotionalBasketDetailsState>(
          builder:
              (context, state) {
            if (state
                    is PromotionalBasketDetailsInitial ||
                state
                    is PromotionalBasketDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is PromotionalBasketDetailsFailure) {
              return _ErrorView(
                message:
                    state.message,

                onRetry: () {
                  Navigator.pop(
                    context,
                  );
                },
              );
            }

            if (state
                is PromotionalBasketDetailsSuccess) {
              return _BasketContent(
                basket: state.basket,
                selectForOrder: selectForOrder,
                cartItems: cartItems,
              );
            }

            return const SizedBox
                .shrink();
          },
        ),
      ),
    );
  }
}

// =========================================================
// Content
// =========================================================

class _BasketContent extends StatelessWidget {
  final PromotionalBasketDetailsModel basket;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _BasketContent({
    required this.basket,
    required this.selectForOrder,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              ListView(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              25,
            ),

            children: [
              _HeaderCard(
                basket:
                    basket,
              ),

              if (basket.supervisorNotes.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          basket.supervisorNotes,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height:
                    20,
              ),

              Row(
                children: [
                  const Expanded(
                    child:
                        Text(
                      'أصناف السلة',

                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textPrimary,

                        fontSize:
                            17,

                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                  ),

                  Text(
                    basket.totalFreeQuantity > 0
                        ? '${basket.totalPaidQuantity} مدفوعة • ${basket.totalFreeQuantity} مجانية'
                        : '${basket.items.length} أصناف',

                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .textSecondary,

                      fontSize:
                          11,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height:
                    11,
              ),

              ...basket.items.map(
                (item) =>
                    Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        10,
                  ),

                  child:
                      _ProductCard(
                    item:
                        item,
                  ),
                ),
              ),

              const SizedBox(
                height:
                    8,
              ),

              _SummaryCard(
                basket:
                    basket,
              ),
            ],
          ),
        ),

        _BottomButton(
          basket:
              basket,
          selectForOrder: selectForOrder,
          cartItems: cartItems,
        ),
      ],
    );
  }
}

// =========================================================
// Header
// =========================================================

class _HeaderCard
    extends StatelessWidget {
  final PromotionalBasketDetailsModel
      basket;

  const _HeaderCard({
    required this.basket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        17,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topRight,

          end:
              Alignment.bottomLeft,

          colors: [
            Color(
              0xFF002A55,
            ),
            Color(
              0xFF174A7E,
            ),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Row(
            children: [
              Container(
                width:
                    50,

                height:
                    50,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withOpacity(
                    0.13,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .shopping_basket_outlined,

                  color:
                      Colors.white,

                  size:
                      27,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      basket.title,

                      style:
                          const TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            17,

                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    const SizedBox(
                      height:
                          4,
                    ),

                    Text(
                      'مرسلة من ${basket.sentBy}',

                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFFDCE8F5,
                        ),

                        fontSize:
                            11,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      10,

                  vertical:
                      6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withOpacity(
                    0.14,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Text(
                  basket.discountText,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize:
                        11,

                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),
              ),
            ],
          ),

          if (basket.description
              .isNotEmpty) ...[
            const SizedBox(
              height:
                  15,
            ),

            Text(
              basket.description,

              style:
                  const TextStyle(
                color:
                    Color(
                  0xFFE5EEF7,
                ),

                fontSize:
                    12,

                height:
                    1.6,
              ),
            ),
          ],

          if (basket.validFrom.isNotEmpty ||
              basket.validTo.isNotEmpty) ...[
            const SizedBox(
              height:
                  14,
            ),

            Row(
              children: [
                const Icon(
                  Icons
                      .calendar_month_outlined,

                  color:
                      Color(
                    0xFFDCE8F5,
                  ),

                  size:
                      17,
                ),

                const SizedBox(
                  width:
                      7,
                ),

                Text(
                  '${_formatDate(basket.validFrom)} - ${_formatDate(basket.validTo)}',

                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFFDCE8F5,
                    ),

                    fontSize:
                        11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// =========================================================
// Product
// =========================================================

class _ProductCard extends StatelessWidget {
  final PromotionalBasketItemModel item;

  const _ProductCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool freeOnly = item.isFree;

    final double subtotal =
        freeOnly ? 0 : item.price * item.quantity;

    final double discount =
        freeOnly ? 0 : subtotal * (item.discountPercent / 100);

    final double total = subtotal - discount;

    final int shownQuantity =
        freeOnly ? item.freeQuantity : item.quantity;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: freeOnly
                      ? AppColors.successSoft
                      : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  freeOnly
                      ? Icons.card_giftcard_rounded
                      : Icons.medication_outlined,
                  color: freeOnly
                      ? AppColors.success
                      : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (item.companyName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          item.companyName,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  freeOnly
                      ? 'مجاني'
                      : '${item.discountPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  title: 'السعر',
                  value: freeOnly ? 'مجاني' : _money(item.price),
                ),
              ),
              Expanded(
                child: _InfoItem(
                  title: freeOnly ? 'الكمية المجانية' : 'الكمية',
                  value: '$shownQuantity',
                ),
              ),
              Expanded(
                child: _InfoItem(
                  title: freeOnly ? 'الإجمالي' : 'بعد الحسم',
                  value: freeOnly ? _money(0) : _money(total),
                ),
              ),
            ],
          ),
          if (!freeOnly && item.freeQuantity > 0) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'يتضمن ${item.freeQuantity} قطعة مجانية ضمن السلة',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =========================================================
// Info
// =========================================================

class _InfoItem
    extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,

          style:
              const TextStyle(
            color:
                AppColors.textSecondary,

            fontSize:
                9.5,
          ),
        ),

        const SizedBox(
          height:
              4,
        ),

        Text(
          value,

          textAlign:
              TextAlign.center,

          style:
              const TextStyle(
            color:
                AppColors.textPrimary,

            fontSize:
                11,

            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// =========================================================
// Summary
// =========================================================

class _SummaryCard extends StatelessWidget {
  final PromotionalBasketDetailsModel basket;

  const _SummaryCard({
    required this.basket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _SummaryRow(
            title: 'الكمية المدفوعة',
            value: '${basket.totalPaidQuantity}',
          ),
          if (basket.totalFreeQuantity > 0) ...[
            const SizedBox(height: 9),
            _SummaryRow(
              title: 'الكمية المجانية',
              value: '${basket.totalFreeQuantity}',
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: 9),
          _SummaryRow(
            title: 'الإجمالي قبل الحسم',
            value: _money(basket.subtotal),
          ),
          const SizedBox(height: 9),
          _SummaryRow(
            title: 'قيمة الحسم',
            value: '- ${_money(basket.totalDiscount)}',
            valueColor: AppColors.success,
          ),
          if (basket.invoiceDiscountPercent > 0) ...[
            const SizedBox(height: 9),
            _SummaryRow(
              title: 'حسم الفاتورة',
              value: '${basket.invoiceDiscountPercent.toStringAsFixed(0)}%',
              valueColor: AppColors.success,
            ),
          ],
          const Divider(height: 22),
          _SummaryRow(
            title: 'إجمالي أصناف السلة بعد الحسم',
            value: _money(basket.finalTotal),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow
    extends StatelessWidget {
  final String title;

  final String value;

  final Color? valueColor;

  final bool bold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              Text(
            title,

            style:
                TextStyle(
              color:
                  AppColors
                      .textSecondary,

              fontSize:
                  12,

              fontWeight:
                  bold
                      ? FontWeight
                          .w800
                      : FontWeight
                          .w500,
            ),
          ),
        ),

        Text(
          value,

          style:
              TextStyle(
            color:
                valueColor ??
                    AppColors
                        .textPrimary,

            fontSize:
                bold
                    ? 15
                    : 12,

            fontWeight:
                bold
                    ? FontWeight
                        .w900
                    : FontWeight
                        .w700,
          ),
        ),
      ],
    );
  }
}

// =========================================================
// Add To Order
// =========================================================

class _BottomButton
    extends StatelessWidget {
  final PromotionalBasketDetailsModel basket;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _BottomButton({
    required this.basket,
    required this.selectForOrder,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:
          false,

      child:
          Container(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          12,
        ),

        decoration:
            const BoxDecoration(
          color:
              Colors.white,

          border:
              Border(
            top:
                BorderSide(
              color:
                  AppColors.border,
            ),
          ),
        ),

        child:
            SizedBox(
          width:
              double.infinity,

          height:
              50,

          child:
              ElevatedButton.icon(
            onPressed: () {
  _addBasketToOrder(
    context,
    basket,
    selectForOrder,
    cartItems,
  );
},

            icon:
                const Icon(
              Icons
                  .add_shopping_cart_rounded,
            ),

            label:
                const Text(
              'إضافة السلة إلى طلبية',
            ),

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,

              foregroundColor:
                  Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// Add Basket To Current Order Flow
// =========================================================

void _addBasketItemToSharedCart(
  Map<String, Map<String, dynamic>> sharedCart,
  Map<String, dynamic> rawItem,
) {
  Map<String, dynamic> item = normalizeCurrentOrderCartItem(
    Map<String, dynamic>.from(rawItem),
  );

  final String cartKey = item['cartKey']?.toString() ?? '';

  if (cartKey.isEmpty) {
    return;
  }

  final Map<String, dynamic>? existing = sharedCart[cartKey];

  int paidQuantity = cartValueToInt(item['quantity']);
  int freeQuantity = cartValueToInt(item['freeQuantity']);

  if (existing != null) {
    paidQuantity += cartValueToInt(existing['paidQuantity']);
    freeQuantity += cartValueToInt(existing['freeQuantity']);
  }

  item['quantity'] = paidQuantity;
  item['freeQuantity'] = freeQuantity;
  item['isFree'] = paidQuantity <= 0 && freeQuantity > 0;
  item = normalizeCurrentOrderCartItem(item);

  paidQuantity = cartValueToInt(item['quantity']);
  freeQuantity = cartValueToInt(item['freeQuantity']);

  sharedCart[cartKey] = {
    'product': Map<String, dynamic>.from(item)
      ..remove('cartKey')
      ..remove('quantity')
      ..remove('freeQuantity')
      ..remove('totalQuantity'),
    'cartKey': cartKey,
    'paidQuantity': paidQuantity,
    'freeQuantity': freeQuantity,
    'totalQuantity': paidQuantity + freeQuantity,
    'offerSource': item['offerSource'],
  };
}

void _addBasketToOrder(
  BuildContext context,
  PromotionalBasketDetailsModel basket,
  bool selectForOrder,
  Map<String, Map<String, dynamic>>? cartItems,
) {
  final List<Map<String, dynamic>> orderItems =
      basket.items
          .map(
            (item) => item.toCartItem(
              promotionalBasketId: basket.id,
              promotionalBasketName: basket.title,
            ),
          )
          .toList();

  // إذا كانت السلة لا تسمح صراحة بدمج العرض الأساسي، لا نمرر basicOffer
  // من أي بيانات جانبية إلى عناصر السلة.
  if (!basket.combineWithBasicOffer) {
    for (final item in orderItems) {
      item.remove('basicOffer');
      item.remove('basic_offer');
    }
  }

  if (selectForOrder) {
    if (cartItems != null) {
      for (final item in orderItems) {
        _addBasketItemToSharedCart(
          cartItems,
          item,
        );
      }

      Navigator.pop(
        context,
        true,
      );
    } else {
      Navigator.pop(
        context,
        orderItems,
      );
    }

    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderCartScreen(
        items: orderItems,
      ),
    ),
  );
}

// =========================================================
// Error
// =========================================================

class _ErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons
                  .error_outline,

              color:
                  AppColors.danger,

              size:
                  45,
            ),

            const SizedBox(
              height:
                  12,
            ),

            Text(
              message,

              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height:
                  12,
            ),

            TextButton(
              onPressed:
                  onRetry,

              child:
                  const Text(
                'رجوع',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// Helpers
// =========================================================

String _formatDate(
  String value,
) {
  final DateTime? date =
      DateTime.tryParse(
    value,
  );

  if (date == null) {
    return value.isEmpty
        ? '-'
        : value;
  }

  final String day =
      date.day
          .toString()
          .padLeft(
            2,
            '0',
          );

  final String month =
      date.month
          .toString()
          .padLeft(
            2,
            '0',
          );

  return '$day/$month/${date.year}';
}

String _money(
  double value,
) {
  return '${value.toStringAsFixed(0)} ل.س';
}