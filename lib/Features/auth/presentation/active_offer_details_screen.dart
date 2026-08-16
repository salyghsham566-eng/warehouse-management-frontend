import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/active_offer_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/active_offer_details_event.dart';
import 'package:project_2/Features/auth/bloc/active_offer_details_state.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_utils.dart';

import 'package:project_2/Features/auth/data/models/active_offer_details_model.dart';

import 'package:project_2/OrdersScreen.dart';

class ActiveOfferDetailsPage
    extends StatelessWidget {
  final String offerId;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const ActiveOfferDetailsPage({
    super.key,
    required this.offerId,
    this.selectForOrder = false,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        ActiveOfferDetailsBloc>(
      create: (_) =>
          sl<ActiveOfferDetailsBloc>()
            ..add(
              LoadActiveOfferDetailsEvent(
                offerId: offerId,
              ),
            ),

      child:
          ActiveOfferDetailsScreen(
            selectForOrder: selectForOrder,
            cartItems: cartItems,
          ),
    );
  }
}

class ActiveOfferDetailsScreen
    extends StatelessWidget {
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const ActiveOfferDetailsScreen({
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

          elevation: 0,

          centerTitle:
              true,

          foregroundColor:
              AppColors.primary,

          title:
              const Text(
            'تفاصيل العرض',

            style:
                TextStyle(
              color:
                  AppColors.textPrimary,

              fontSize: 18,

              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            ActiveOfferDetailsBloc,
            ActiveOfferDetailsState>(
          builder:
              (context, state) {
            if (state
                    is ActiveOfferDetailsInitial ||
                state
                    is ActiveOfferDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is ActiveOfferDetailsFailure) {
              return Center(
                child:
                    Text(
                  state.message,
                ),
              );
            }

            if (state
                is ActiveOfferDetailsSuccess) {
              return _OfferContent(
                offer:
                    state.offer,
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

class _OfferContent
    extends StatelessWidget {
  final ActiveOfferDetailsModel offer;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _OfferContent({
    required this.offer,
    this.selectForOrder = false,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.all(
        16,
      ),

      children: [
        // ===================================================
        // Header
        // ===================================================

        Container(
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
                    width: 48,
                    height: 48,

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white
                              .withOpacity(
                        0.13,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),

                    child:
                        const Icon(
                      Icons
                          .local_offer_outlined,

                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child:
                        Text(
                      offer.title,

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
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
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
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),

                    child:
                        Text(
                      offer.discountText,

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

              const SizedBox(
                height: 13,
              ),

              Text(
                offer.description,

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFFE5EEF7,
                  ),

                  fontSize: 12,

                  height: 1.6,
                ),
              ),

              const SizedBox(
                height: 13,
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

                    size: 17,
                  ),

                  const SizedBox(
                    width: 7,
                  ),

                  Text(
                    '${_formatDate(offer.validFrom)} - ${_formatDate(offer.validTo)}',

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
          ),
        ),

        const SizedBox(
          height: 22,
        ),

        const Text(
          'الأصناف المشمولة بالعرض',

          style:
              TextStyle(
            color:
                AppColors.textPrimary,

            fontSize: 17,

            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        if (offer.products.isEmpty)
          const Text(
            'لا توجد أصناف ضمن العرض.',
          )
        else
          ...offer.products.map(
            (product) =>
                Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 11,
              ),

              child:
                  _OfferProductCard(
                product:
                    product,

                offer:
                    offer,
                selectForOrder: selectForOrder,
                cartItems: cartItems,
              ),
            ),
          ),
      ],
    );
  }
}

class _OfferProductCard
    extends StatelessWidget {
  final ActiveOfferProductModel product;
  final bool selectForOrder;
  final ActiveOfferDetailsModel offer;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _OfferProductCard({
    required this.product,
    required this.offer,
    required this.selectForOrder,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border:
            Border.all(
          color:
              AppColors.border,
        ),
      ),

      child:
          Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration:
                    BoxDecoration(
                  color:
                      AppColors
                          .primarySoft,

                  borderRadius:
                      BorderRadius
                          .circular(
                    13,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .medication_outlined,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      product.productName,

                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .textPrimary,

                        fontSize:
                            13.5,

                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      product.companyName,

                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .textSecondary,

                        fontSize:
                            10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          Row(
            children: [
              Expanded(
                child:
                    Text(
                  'السعر: ${product.price.toStringAsFixed(0)} ل.س',

                  style:
                      const TextStyle(
                    fontSize:
                        11,

                    color:
                        AppColors
                            .textSecondary,
                  ),
                ),
              ),

              Text(
                offer.isBuyGetFree
                    ? 'اشترِ ${offer.buyQuantity} وخذ ${offer.freeQuantity} مجاناً'
                    : 'خصم ${offer.discountPercent.toStringAsFixed(0)}%',

                style:
                    const TextStyle(
                  color:
                      AppColors.success,

                  fontSize: 11,

                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          SizedBox(
            width:
                double.infinity,

            child:
                ElevatedButton.icon(
              onPressed: () {
                _useOffer(
                  context,
                  offer,
                  product,
                  selectForOrder,
                  cartItems,
                );
              },

              icon:
                  const Icon(
                Icons
                    .add_shopping_cart_rounded,

                size: 18,
              ),

              label:
                  const Text(
                'استخدام العرض',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,

                foregroundColor:
                    Colors.white,

                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// استخدام العرض فعلياً
// =========================================================

void _addOfferItemToSharedCart(
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

  if (existing != null) {
    final int oldQuantity = cartValueToInt(existing['paidQuantity']);
    final int addedQuantity = cartValueToInt(item['quantity']);

    item['quantity'] = oldQuantity + addedQuantity;
    item = normalizeCurrentOrderCartItem(item);
  }

  final int paidQuantity = cartValueToInt(item['quantity']);
  final int freeQuantity = cartValueToInt(item['freeQuantity']);

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

void _useOffer(
  BuildContext context,
  ActiveOfferDetailsModel offer,
  ActiveOfferProductModel product,
  bool selectForOrder,
  Map<String, Map<String, dynamic>>? cartItems,
) {
  int quantity =
      product.minimumQuantity > 0
          ? product.minimumQuantity
          : 1;

  Map<String, dynamic>? basicOffer;

  double discountPercent = 0;

  if (offer.isBuyGetFree) {
    quantity =
        offer.buyQuantity > 0
            ? offer.buyQuantity
            : quantity;

    basicOffer = {
      'buyQuantity':
          offer.buyQuantity,

      'freeQuantity':
          offer.freeQuantity,
    };
  }

  if (offer.isPercentageDiscount) {
    discountPercent =
        offer.discountPercent;
  }

  final Map<String, dynamic> item = {
    'id':
        product.productId,

    'product_id':
        product.productId,

    'name':
        product.productName,

    'companyId':
        product.companyId,

    'company':
        product.companyName,

    'price':
        product.price,

    'quantity':
        quantity,

    'discountPercent':
        discountPercent,

    if (basicOffer != null)
      'basicOffer':
          basicOffer,

    'offerId':
        offer.id,

    'offerSource':
        offer.title,
  };

  // =====================================================
  // جايين من الطلبية الحالية
  // ممنوع نفتح OrderCartScreen جديد
  // =====================================================

  if (selectForOrder) {
    if (cartItems != null) {
      _addOfferItemToSharedCart(
        cartItems,
        item,
      );

      Navigator.pop(
        context,
        true,
      );
    } else {
      Navigator.pop(
        context,
        item,
      );
    }

    return;
  }

  // =====================================================
  // فقط إذا فتحنا العروض من القسم العادي
  // =====================================================

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          OrderCartScreen(
        items: [
          item,
        ],
      ),
    ),
  );
}

String _formatDate(
  String value,
) {
  final DateTime? date =
      DateTime.tryParse(
    value,
  );

  if (date == null) {
    return value;
  }

  final day =
      date.day
          .toString()
          .padLeft(
            2,
            '0',
          );

  final month =
      date.month
          .toString()
          .padLeft(
            2,
            '0',
          );

  return '$day/$month/${date.year}';
}