import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/used_offers_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/used_offers_history_event.dart';
import 'package:project_2/Features/auth/bloc/used_offers_history_state.dart';

import 'package:project_2/Features/auth/data/models/used_offer_history_model.dart';

// =========================================================
// Page
// =========================================================

class UsedOffersHistoryPage
    extends StatelessWidget {
  const UsedOffersHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        UsedOffersHistoryBloc>(
      create: (_) =>
          sl<UsedOffersHistoryBloc>()
            ..add(
              LoadUsedOffersHistoryEvent(),
            ),

      child:
          const UsedOffersHistoryScreen(),
    );
  }
}

// =========================================================
// Screen
// =========================================================

class UsedOffersHistoryScreen
    extends StatelessWidget {
  const UsedOffersHistoryScreen({
    super.key,
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
            'تاريخ العروض المستخدمة',

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
            UsedOffersHistoryBloc,
            UsedOffersHistoryState>(
          builder:
              (context, state) {
            if (state
                    is UsedOffersHistoryInitial ||
                state
                    is UsedOffersHistoryLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is UsedOffersHistoryFailure) {
              return _HistoryError(
                message:
                    state.message,

                onRetry: () {
                  context
                      .read<
                        UsedOffersHistoryBloc
                      >()
                      .add(
                        LoadUsedOffersHistoryEvent(),
                      );
                },
              );
            }

            if (state
                is UsedOffersHistorySuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<
                        UsedOffersHistoryBloc
                      >()
                      .add(
                        LoadUsedOffersHistoryEvent(),
                      );
                },

                child:
                    _HistoryContent(
                  offers:
                      state.offers,
                ),
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

class _HistoryContent
    extends StatelessWidget {
  final List<UsedOfferHistoryModel>
      offers;

  const _HistoryContent({
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.fromLTRB(
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
                  0xFF173F5F,
                ),

                Color(
                  0xFF20639B,
                ),
              ],
            ),

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          child:
              Row(
            children: [
              Container(
                width:
                    49,

                height:
                    49,

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
                      .history_rounded,

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

              const Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      'العروض المستخدمة سابقاً',

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            16,

                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    SizedBox(
                      height:
                          4,
                    ),

                    Text(
                      'العروض والسلال التي تم استخدامها ضمن طلبياتك السابقة',

                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFFDCE8F5,
                        ),

                        fontSize:
                            11,

                        height:
                            1.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      9,

                  vertical:
                      5,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withOpacity(
                    0.13,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                child:
                    Text(
                  '${offers.length}',

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
        ),

        const SizedBox(
          height:
              21,
        ),

        const Row(
          children: [
            Icon(
              Icons
                  .local_offer_outlined,

              color:
                  AppColors.primary,

              size:
                  20,
            ),

            SizedBox(
              width:
                  7,
            ),

            Text(
              'سجل الاستخدام',

              style:
                  TextStyle(
                color:
                    AppColors.textPrimary,

                fontSize:
                    16,

                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(
          height:
              12,
        ),

        if (offers.isEmpty)
          const _EmptyHistory()
        else
          ...offers.map(
            (offer) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom:
                    11,
              ),

              child:
                  _UsedOfferCard(
                offer:
                    offer,
              ),
            ),
          ),
      ],
    );
  }
}

// =========================================================
// Card
// =========================================================

class _UsedOfferCard
    extends StatelessWidget {
  final UsedOfferHistoryModel offer;

  const _UsedOfferCard({
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          double.infinity,

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

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),

            blurRadius:
                10,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          // =================================================
          // Offer name
          // =================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              Container(
                width:
                    44,

                height:
                    44,

                decoration:
                    BoxDecoration(
                  color:
                      offer.isBasket
                          ? const Color(
                              0xFFF2ECFF,
                            )
                          : AppColors
                              .successSoft,

                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child:
                    Icon(
                  offer.isBasket
                      ? Icons
                          .shopping_basket_outlined
                      : Icons
                          .sell_outlined,

                  color:
                      offer.isBasket
                          ? const Color(
                              0xFF7A5AF8,
                            )
                          : AppColors.success,

                  size:
                      22,
                ),
              ),

              const SizedBox(
                width:
                    11,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      offer.offerName,

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
                      height:
                          4,
                    ),

                    Text(
                      offer.isBasket
                          ? 'سلة ترويجية'
                          : 'عرض',

                      style:
                          TextStyle(
                        color:
                            offer.isBasket
                                ? const Color(
                                    0xFF7A5AF8,
                                  )
                                : AppColors
                                    .success,

                        fontSize:
                            10,

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
                      const EdgeInsets.symmetric(
                    horizontal:
                        9,

                    vertical:
                        5,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors
                            .successSoft,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child:
                      Text(
                    offer.discountText,

                    style:
                        const TextStyle(
                      color:
                          AppColors.success,

                      fontSize:
                          10,

                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(
            height:
                14,
          ),

          // =================================================
          // Order
          // =================================================

          _HistoryInfoRow(
            icon:
                Icons
                    .receipt_long_outlined,

            title:
                'رقم الطلبية',

            value:
                offer.orderNumber,
          ),

          const SizedBox(
            height:
                8,
          ),

          // =================================================
          // Pharmacy
          // =================================================

          _HistoryInfoRow(
            icon:
                Icons
                    .local_pharmacy_outlined,

            title:
                'الصيدلية',

            value:
                offer.pharmacyName,
          ),

          const SizedBox(
            height:
                8,
          ),

          // =================================================
          // Date
          // =================================================

          _HistoryInfoRow(
            icon:
                Icons
                    .calendar_today_outlined,

            title:
                'تاريخ الاستخدام',

            value:
                _formatDate(
              offer.usedAt,
            ),
          ),

          if (offer.discountAmount >
              0) ...[
            const SizedBox(
              height:
                  13,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    11,

                vertical:
                    10,
              ),

              decoration:
                  BoxDecoration(
                color:
                    AppColors
                        .successSoft,

                borderRadius:
                    BorderRadius.circular(
                  11,
                ),
              ),

              child:
                  Row(
                children: [
                  const Icon(
                    Icons
                        .savings_outlined,

                    size:
                        17,

                    color:
                        AppColors.success,
                  ),

                  const SizedBox(
                    width:
                        7,
                  ),

                  const Expanded(
                    child:
                        Text(
                      'قيمة التوفير',

                      style:
                          TextStyle(
                        color:
                            AppColors.success,

                        fontSize:
                            11,

                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),

                  Text(
                    '${offer.discountAmount.toStringAsFixed(0)} ل.س',

                    style:
                        const TextStyle(
                      color:
                          AppColors.success,

                      fontSize:
                          12,

                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =========================================================
// Info Row
// =========================================================

class _HistoryInfoRow
    extends StatelessWidget {
  final IconData icon;

  final String title;

  final String value;

  const _HistoryInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,

          size:
              16,

          color:
              AppColors.textSecondary,
        ),

        const SizedBox(
          width:
              7,
        ),

        Text(
          '$title: ',

          style:
              const TextStyle(
            color:
                AppColors.textSecondary,

            fontSize:
                10.5,
          ),
        ),

        Expanded(
          child:
              Text(
            value.isEmpty
                ? '-'
                : value,

            style:
                const TextStyle(
              color:
                  AppColors.textPrimary,

              fontSize:
                  10.5,

              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================
// Empty
// =========================================================

class _EmptyHistory
    extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical:
            30,

        horizontal:
            20,
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
          const Column(
        children: [
          Icon(
            Icons
                .history_toggle_off_rounded,

            size:
                42,

            color:
                AppColors.textSecondary,
          ),

          SizedBox(
            height:
                10,
          ),

          Text(
            'لم تستخدم أي عروض في طلبيات سابقة حتى الآن.',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              color:
                  AppColors.textSecondary,

              fontSize:
                  12,
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

class _HistoryError
    extends StatelessWidget {
  final String message;

  final VoidCallback onRetry;

  const _HistoryError({
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
                  .error_outline_rounded,

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

            TextButton.icon(
              onPressed:
                  onRetry,

              icon:
                  const Icon(
                Icons.refresh_rounded,
              ),

              label:
                  const Text(
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