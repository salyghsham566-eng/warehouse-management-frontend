import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_state.dart';

import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';

class EvaluationOneTimePharmaciesDetailsScreen
    extends StatelessWidget {
  final String regionId;
  final int month;
  final int year;

  const EvaluationOneTimePharmaciesDetailsScreen({
    super.key,
    required this.regionId,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
            const Color(0xFFF6F8FC),

        appBar: AppBar(
          backgroundColor:
              Colors.white,
          surfaceTintColor:
              Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor:
              AppColors.primary,

          title: const Text(
            'المباعة مرة واحدة',
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 19,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            EvaluationOneTimePharmaciesDetailsBloc,
            EvaluationOneTimePharmaciesDetailsState>(
          builder: (context, state) {
            if (state
                is EvaluationOneTimePharmaciesDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is EvaluationOneTimePharmaciesDetailsFailure) {
              return _ErrorView(
                message:
                    state.message,

                onRetry: () {
                  context
                      .read<
                          EvaluationOneTimePharmaciesDetailsBloc>()
                      .add(
                        LoadEvaluationOneTimePharmaciesDetailsEvent(
                          regionId:
                              regionId,
                          month:
                              month,
                          year:
                              year,
                        ),
                      );
                },
              );
            }

            if (state
                is EvaluationOneTimePharmaciesDetailsSuccess) {
              return _Content(
                details:
                    state.details,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ==========================================================
// Content
// ==========================================================

class _Content extends StatelessWidget {
  final EvaluationOneTimePharmaciesDetailsModel
      details;

  const _Content({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<
                EvaluationOneTimePharmaciesDetailsBloc>()
            .add(
              LoadEvaluationOneTimePharmaciesDetailsEvent(
                regionId:
                    details.regionId,
                month:
                    details.month,
                year:
                    details.year,
              ),
            );
      },

      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          28,
        ),

        children: [
          // ==================================================
          // Header
          // ==================================================

          Container(
            padding:
                const EdgeInsets.all(18),

            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                begin:
                    Alignment.topRight,
                end:
                    Alignment.bottomLeft,

                colors: [
                  Color(0xFF087F8C),
                  Color(0xFF00A6A6),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFF00A6A6,
                  ).withOpacity(0.18),
                  blurRadius: 16,
                  offset:
                      const Offset(0, 6),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white
                            .withOpacity(
                      0.16,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child: const Icon(
                    Icons.looks_one_outlined,
                    color:
                        Colors.white,
                    size: 29,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Text(
                        'المباعة مرة واحدة',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        details.regionName,
                        style:
                            TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.8,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Text(
                      _number(
                        details.score,
                      ),

                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 27,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    Text(
                      'من ${_number(details.maxScore)}',

                      style:
                          TextStyle(
                        color:
                            Colors.white
                                .withOpacity(
                          0.75,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // ==================================================
          // Summary
          // ==================================================

          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title:
                      'مرة واحدة',

                  value:
                      '${details.oneTimeCount}',

                  icon:
                      Icons.looks_one_outlined,

                  color:
                      const Color(
                    0xFF00A6A6,
                  ),

                  softColor:
                      const Color(
                    0xFFE6F7F7,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: _SummaryCard(
                  title:
                      'إجمالي المباعة',

                  value:
                      '${details.totalSoldPharmacies}',

                  icon:
                      Icons.storefront_outlined,

                  color:
                      const Color(
                    0xFF2F80ED,
                  ),

                  softColor:
                      const Color(
                    0xFFEAF3FF,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          // ==================================================
          // Percentage
          // ==================================================

          _PercentageCard(
            percentage:
                details.percentage,
          ),

          const SizedBox(
            height: 16,
          ),

          // ==================================================
          // Important UC-209 Info
          // ==================================================

          const _AutomaticMoveInfo(),

          const SizedBox(
            height: 24,
          ),

          // ==================================================
          // List title
          // ==================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الصيدليات المباعة مرة واحدة',
                  style:
                      TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFE6F7F7,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  '${details.pharmacies.length}',

                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF00A6A6,
                    ),
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'هذه الصيدليات لديها عملية بيع واحدة فقط خلال الشهر الحالي.',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          if (details.pharmacies.isEmpty)
            const _EmptyView()
          else
            ...details.pharmacies.map(
              (pharmacy) =>
                  _PharmacyCard(
                pharmacy:
                    pharmacy,
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// Summary Card
// ==========================================================

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  final Color color;
  final Color softColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.softColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border:
            Border.all(
          color:
              softColor,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color:
                  softColor,

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              icon,
              color:
                  color,
            ),
          ),

          const SizedBox(
            height: 9,
          ),

          Text(
            value,

            style:
                TextStyle(
              color:
                  color,
              fontSize: 24,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          Text(
            title,

            style:
                const TextStyle(
              color:
                  AppColors
                      .textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Percentage
// ==========================================================

class _PercentageCard
    extends StatelessWidget {
  final double percentage;

  const _PercentageCard({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        (percentage / 100)
            .clamp(
              0.0,
              1.0,
            );

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFD7F1F1,
          ),
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons
                    .pie_chart_outline_rounded,
                color:
                    Color(
                  0xFF00A6A6,
                ),
              ),

              const SizedBox(
                width: 9,
              ),

              const Expanded(
                child: Text(
                  'نسبة المباعة مرة واحدة',
                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textPrimary,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${percentage.toStringAsFixed(1)}%',

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF00A6A6,
                  ),
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            child:
                LinearProgressIndicator(
              value:
                  progress,

              minHeight:
                  9,

              backgroundColor:
                  const Color(
                0xFFE6F7F7,
              ),

              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                Color(
                  0xFF00A6A6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Automatic Move Info
// ==========================================================

class _AutomaticMoveInfo
    extends StatelessWidget {
  const _AutomaticMoveInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFEAF8F0),
            Color(0xFFE6F7F7),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFD5EDE5,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                const BoxDecoration(
              color:
                  Colors.white,
              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons
                  .swap_horiz_rounded,
              color:
                  Color(
                0xFF27AE60,
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'تحديث تلقائي',
                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textPrimary,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'عند تسجيل عملية بيع ثانية للصيدلية خلال نفس الشهر، تنتقل تلقائياً من هذه القائمة إلى قائمة الصيدليات المكررة.',
                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textSecondary,
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Pharmacy
// ==========================================================

class _PharmacyCard
    extends StatelessWidget {
  final EvaluationOneTimePharmacyModel
      pharmacy;

  const _PharmacyCard({
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE5EAF1,
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFE6F7F7,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: const Icon(
              Icons.looks_one_outlined,
              color:
                  Color(
                0xFF00A6A6,
              ),
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
                  pharmacy
                      .pharmacyName,

                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .textPrimary,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                if (pharmacy
                    .regionName
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    pharmacy
                        .regionName,

                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],

                if (pharmacy
                        .lastSaleDate !=
                    null) ...[
                  const SizedBox(
                    height: 4,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 11,
                        color:
                            AppColors
                                .textSecondary,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Text(
                        'آخر بيع: ${pharmacy.lastSaleDate}',

                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFFFF3E5,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    9,
                  ),
                ),

                child:
                    const Text(
                  'عملية واحدة',
                  style:
                      TextStyle(
                    color:
                        Color(
                      0xFFF2994A,
                    ),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                _formatMoney(
                  pharmacy.salesAmount,
                ),

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF27AE60,
                  ),
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Empty
// ==========================================================

class _EmptyView
    extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        25,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE5EAF1,
          ),
        ),
      ),

      child:
          const Column(
        children: [
          Icon(
            Icons.looks_one_outlined,
            size: 38,
            color:
                Color(
              0xFF98A2B3,
            ),
          ),

          SizedBox(
            height: 9,
          ),

          Text(
            'لا توجد صيدليات مباعة مرة واحدة حالياً',
            style: TextStyle(
              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Error
// ==========================================================

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
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color:
                  AppColors.danger,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 14,
            ),

            ElevatedButton.icon(
              onPressed:
                  onRetry,

              icon:
                  const Icon(
                Icons.refresh,
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

// ==========================================================
// Helpers
// ==========================================================

String _number(double value) {
  if (value ==
      value.truncateToDouble()) {
    return value
        .toInt()
        .toString();
  }

  return value.toStringAsFixed(1);
}

String _formatMoney(
  double value,
) {
  return '${value.toStringAsFixed(0)} ر.س';
}