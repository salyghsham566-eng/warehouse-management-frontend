import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/offers_bloc.dart';
import 'package:project_2/Features/auth/bloc/offers_event.dart';
import 'package:project_2/Features/auth/bloc/offers_state.dart';

import 'package:project_2/Features/auth/data/models/offers_overview_model.dart';

import 'package:project_2/Features/auth/presentation/active_offer_details_screen.dart';
import 'package:project_2/Features/auth/presentation/promotional_basket_details_screen.dart';
import 'package:project_2/Features/auth/presentation/used_offers_history_screen.dart';

// =========================================================
// Representative Offers Screen
// =========================================================

class RepresentativeOffersScreen extends StatelessWidget {
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const RepresentativeOffersScreen({
    super.key,
    this.selectForOrder = false,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,

          title: Text(
            selectForOrder
                ? 'اختيار عرض للطلبية'
                : 'العروض والحسومات',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<OffersBloc, OffersState>(
          builder: (context, state) {
            // =================================================
            // Loading
            // =================================================

            if (state is OffersInitial ||
                state is OffersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // =================================================
            // Error
            // =================================================

            if (state is OffersFailure) {
              return _OffersError(
                message: state.message,
                onRetry: () {
                  context
                      .read<OffersBloc>()
                      .add(
                        LoadOffersEvent(),
                      );
                },
              );
            }

            // =================================================
            // Success
            // =================================================

            if (state is OffersSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<OffersBloc>()
                      .add(
                        LoadOffersEvent(),
                      );
                },

                child: _OffersContent(
                  data: state.data,
                  selectForOrder: selectForOrder,
                  cartItems: cartItems,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// =========================================================
// Main Content
// =========================================================

class _OffersContent extends StatelessWidget {
  final OffersOverviewModel data;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _OffersContent({
    required this.data,
    required this.selectForOrder,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        30,
      ),

      children: [
        // ===================================================
        // Header
        // ===================================================

        Container(
          padding: const EdgeInsets.all(
            18,
          ),

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(
                  0xFF002A55,
                ),
                Color(
                  0xFF174A7E,
                ),
              ],
            ),

            borderRadius: BorderRadius.circular(
              22,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,

                decoration: const BoxDecoration(
                  color: Color(
                    0x26FFFFFF,
                  ),

                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),

                child: const Icon(
                  Icons.local_offer_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      selectForOrder
                          ? 'اختاري عرضاً للطلبية الحالية'
                          : 'العروض المتاحة لك',

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      selectForOrder
                          ? 'يمكنك اختيار عرض أو سلة ترويجية وإضافتها إلى نفس الطلبية'
                          : 'تابع العروض الفعالة والسلال الترويجية المرسلة من المشرف',

                      style: const TextStyle(
                        color: Color(
                          0xFFDCE8F5,
                        ),
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        // ===================================================
        // Used Offers History
        //
        // لما نكون داخل اختيار عرض للطلبية
        // ما في داعي نظهر سجل التاريخ
        // ===================================================

        if (!selectForOrder) ...[
          _UsedOffersHistoryButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const UsedOffersHistoryPage(),
                ),
              );
            },
          ),

          const SizedBox(
            height: 24,
          ),
        ],

        // ===================================================
        // Active Offers
        // ===================================================

        _SectionTitle(
          title: 'العروض الفعالة',
          count: data.activeOffers.length,
          icon: Icons.campaign_outlined,
        ),

        const SizedBox(
          height: 12,
        ),

        if (data.activeOffers.isEmpty)
          const _EmptySection(
            text:
                'لا توجد عروض فعالة حالياً.',
          )
        else
          ...data.activeOffers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),

              child: _ActiveOfferCard(
                offer: offer,
                selectForOrder:
                    selectForOrder,
                cartItems: cartItems,
              ),
            ),
          ),

        const SizedBox(
          height: 14,
        ),

        // ===================================================
        // Promotional Baskets
        // ===================================================

        _SectionTitle(
          title: 'السلال الترويجية',
          count:
              data.promotionalBaskets.length,
          icon:
              Icons.shopping_basket_outlined,
        ),

        const SizedBox(
          height: 5,
        ),

        const Text(
          'السلال المرسلة إليك من المشرف',
          style: TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 11.5,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        if (data.promotionalBaskets.isEmpty)
          const _EmptySection(
            text:
                'لا توجد سلال ترويجية مرسلة حالياً.',
          )
        else
          ...data.promotionalBaskets.map(
            (basket) => Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),

              child:
                  _PromotionalBasketCard(
                basket: basket,
                selectForOrder:
                    selectForOrder,
                cartItems: cartItems,
              ),
            ),
          ),
      ],
    );
  }
}

// =========================================================
// Section Title
// =========================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 37,
          height: 37,

          decoration: BoxDecoration(
            color:
                AppColors.primarySoft,

            borderRadius:
                BorderRadius.circular(
              11,
            ),
          ),

          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Text(
            title,

            style: const TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),

          decoration: BoxDecoration(
            color:
                AppColors.primarySoft,

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          child: Text(
            count.toString(),

            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================
// Used Offers History Button
// =========================================================

class _UsedOffersHistoryButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _UsedOffersHistoryButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(
            15,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              17,
            ),

            border: Border.all(
              color: AppColors.border,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEAF3FF,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child: const Icon(
                  Icons.history_rounded,
                  color: Color(
                    0xFF2F80ED,
                  ),
                  size: 23,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      'تاريخ العروض المستخدمة',
                      style: TextStyle(
                        color: AppColors
                            .textPrimary,
                        fontSize: 13.5,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      'العروض والسلال المستخدمة ضمن الطلبيات السابقة',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// Active Offer Card
// =========================================================

class _ActiveOfferCard
    extends StatelessWidget {
  final RepresentativeOfferModel offer;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _ActiveOfferCard({
    required this.offer,
    required this.selectForOrder,
    required this.cartItems,
  });

  // =========================================================
  // Open Active Offer Details
  // =========================================================

  Future<void> _openOffer(
    BuildContext context,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveOfferDetailsPage(
          offerId: offer.id,
          selectForOrder: selectForOrder,
          cartItems: cartItems,
        ),
      ),
    );

    if (!context.mounted || result != true) {
      return;
    }

    if (selectForOrder) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تمت إضافة العرض إلى الطلبية، يمكنك اختيار عرض أو سلة أخرى',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          18,
        ),

        onTap: () {
          _openOffer(
            context,
          );
        },

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(
            16,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            border: Border.all(
              color: AppColors.border,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.025,
                ),

                blurRadius: 12,

                offset: const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =================================================
              // Header
              // =================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Container(
                    width: 45,
                    height: 45,

                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .successSoft,

                      borderRadius:
                          BorderRadius
                              .circular(
                        13,
                      ),
                    ),

                    child: const Icon(
                      Icons.sell_outlined,
                      color:
                          AppColors.success,
                      size: 22,
                    ),
                  ),

                  const SizedBox(
                    width: 11,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          offer.title,

                          style:
                              const TextStyle(
                            color: AppColors
                                .textPrimary,

                            fontSize:
                                14.5,

                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        const Text(
                          'عرض فعال',

                          style:
                              TextStyle(
                            color:
                                AppColors
                                    .success,

                            fontSize:
                                10.5,

                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (offer
                      .discountText
                      .isNotEmpty)
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal:
                            9,

                        vertical:
                            6,
                      ),

                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .successSoft,

                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),
                      ),

                      child: Text(
                        offer.discountText,

                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .success,

                          fontSize:
                              10.5,

                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),
                    ),
                ],
              ),

              // =================================================
              // Description
              // =================================================

              if (offer
                  .description
                  .isNotEmpty) ...[
                const SizedBox(
                  height: 13,
                ),

                Text(
                  offer.description,

                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,

                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],

              // =================================================
              // Validity
              // =================================================

              if (offer.validFrom
                      .isNotEmpty ||
                  offer.validTo
                      .isNotEmpty) ...[
                const SizedBox(
                  height: 14,
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 11,
                    vertical: 9,
                  ),

                  decoration:
                      BoxDecoration(
                    color: const Color(
                      0xFFF8FAFC,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      11,
                    ),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 15,
                        color: AppColors
                            .textSecondary,
                      ),

                      const SizedBox(
                        width: 7,
                      ),

                      Expanded(
                        child: Text(
                          'الفترة: ${_formatDate(offer.validFrom)} - ${_formatDate(offer.validTo)}',

                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,

                            fontSize:
                                10.5,

                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height: 13,
              ),

              // =================================================
              // Button
              // =================================================

              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(
                  onPressed: () {
                    _openOffer(
                      context,
                    );
                  },

                  icon: Icon(
                    selectForOrder
                        ? Icons
                            .add_shopping_cart_rounded
                        : Icons
                            .visibility_outlined,
                    size: 18,
                  ),

                  label: Text(
                    selectForOrder
                        ? 'اختيار واستخدام العرض'
                        : 'عرض واستخدام العرض',
                  ),

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        AppColors.primary,

                    side:
                        const BorderSide(
                      color:
                          AppColors
                              .primary,
                    ),

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
        ),
      ),
    );
  }
}

// =========================================================
// Promotional Basket Card
// =========================================================

class _PromotionalBasketCard
    extends StatelessWidget {
  final PromotionalBasketModel basket;
  final bool selectForOrder;
  final Map<String, Map<String, dynamic>>? cartItems;

  const _PromotionalBasketCard({
    required this.basket,
    required this.selectForOrder,
    required this.cartItems,
  });

  // =========================================================
  // Open Basket Details
  // =========================================================

  Future<void> _openBasket(
    BuildContext context,
  ) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PromotionalBasketDetailsPage(
          basketId: basket.id,
          selectForOrder: selectForOrder,
          cartItems: cartItems,
        ),
      ),
    );

    if (!context.mounted || result != true) {
      return;
    }

    if (selectForOrder) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تمت إضافة السلة إلى الطلبية، يمكنك اختيار عرض أو سلة أخرى',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color: AppColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
              0.025,
            ),

            blurRadius: 12,

            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // =================================================
          // Basket Header
          // =================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                width: 46,
                height: 46,

                decoration:
                    BoxDecoration(
                  color: const Color(
                    0xFFF2ECFF,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),

                child: const Icon(
                  Icons
                      .shopping_basket_outlined,

                  color: Color(
                    0xFF7A5AF8,
                  ),

                  size: 23,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      basket.title,

                      style:
                          const TextStyle(
                        color: AppColors
                            .textPrimary,

                        fontSize: 14.5,

                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      'مرسلة من ${basket.sentBy}',

                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,

                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // =================================================
          // Description
          // =================================================

          if (basket
              .description
              .isNotEmpty) ...[
            const SizedBox(
              height: 12,
            ),

            Text(
              basket.description,

              style: const TextStyle(
                color: AppColors
                    .textSecondary,

                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],

          const SizedBox(
            height: 14,
          ),

          // =================================================
          // Basket Info
          // =================================================

          Row(
            children: [
              Expanded(
                child: _BasketInfo(
                  icon: Icons
                      .inventory_2_outlined,

                  title: 'عدد الأصناف',

                  value:
                      '${basket.productsCount}',
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: _BasketInfo(
                  icon:
                      Icons.percent_rounded,

                  title: 'العرض',

                  value: basket
                          .discountText
                          .isEmpty
                      ? '-'
                      : basket
                          .discountText,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          // =================================================
          // Basket Button
          // =================================================

          SizedBox(
            width: double.infinity,

            child: OutlinedButton.icon(
              onPressed: () {
                _openBasket(
                  context,
                );
              },

              icon: Icon(
                selectForOrder
                    ? Icons
                        .add_shopping_cart_rounded
                    : Icons
                        .visibility_outlined,
                size: 18,
              ),

              label: Text(
                selectForOrder
                    ? 'عرض واختيار السلة'
                    : 'عرض السلة',
              ),

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    AppColors.primary,

                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 12,
                ),

                side:
                    const BorderSide(
                  color:
                      AppColors.primary,
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
// Basket Info
// =========================================================

class _BasketInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _BasketInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        10,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFF8FAFC,
        ),

        borderRadius:
            BorderRadius.circular(
          11,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: AppColors.primary,
              ),

              const SizedBox(
                width: 5,
              ),

              Text(
                title,

                style:
                    const TextStyle(
                  color: AppColors
                      .textSecondary,

                  fontSize: 9.5,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            value,
            maxLines: 1,

            overflow:
                TextOverflow.ellipsis,

            style: const TextStyle(
              color:
                  AppColors.textPrimary,

              fontSize: 11,

              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Empty Section
// =========================================================

class _EmptySection extends StatelessWidget {
  final String text;

  const _EmptySection({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color:
                AppColors.textSecondary,
            size: 20,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                color: AppColors
                    .textSecondary,

                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Error
// =========================================================

class _OffersError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OffersError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons
                  .error_outline_rounded,

              size: 45,

              color: AppColors.danger,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,

              textAlign:
                  TextAlign.center,

              style: const TextStyle(
                color: AppColors
                    .textSecondary,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextButton.icon(
              onPressed: onRetry,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// Date Helper
// =========================================================

String _formatDate(
  String value,
) {
  if (value.trim().isEmpty) {
    return '-';
  }

  final DateTime? date =
      DateTime.tryParse(
    value,
  );

  if (date == null) {
    return value;
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