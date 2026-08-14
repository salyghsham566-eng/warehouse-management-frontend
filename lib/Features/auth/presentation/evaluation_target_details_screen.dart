import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_target_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_target_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_target_details_state.dart';

import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';

class EvaluationTargetDetailsScreen
    extends StatelessWidget {
  final String regionId;
  final int month;
  final int year;

  const EvaluationTargetDetailsScreen({
    super.key,
    required this.regionId,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
            'تفاصيل نقاط التارغت',
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
            EvaluationTargetDetailsBloc,
            EvaluationTargetDetailsState>(
          builder: (context, state) {
            if (state
                is EvaluationTargetDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is EvaluationTargetDetailsFailure) {
              return _ErrorView(
                message:
                    state.message,
                onRetry: () {
                  context
                      .read<
                          EvaluationTargetDetailsBloc>()
                      .add(
                        LoadEvaluationTargetDetailsEvent(
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
                is EvaluationTargetDetailsSuccess) {
              return _TargetDetailsContent(
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

class _TargetDetailsContent
    extends StatelessWidget {
  final EvaluationTargetDetailsModel
      details;

  const _TargetDetailsContent({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<
                EvaluationTargetDetailsBloc>()
            .add(
              LoadEvaluationTargetDetailsEvent(
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
          // HEADER
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
                  Color(0xFF12355B),
                  Color(0xFF2F80ED),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFF12355B,
                  ).withOpacity(
                    0.16,
                  ),
                  blurRadius: 16,
                  offset:
                      const Offset(
                    0,
                    7,
                  ),
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
                      0.15,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),

                  child: const Icon(
                    Icons
                        .track_changes_outlined,
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
                        'نقاط التارغت',
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
                        height: 5,
                      ),

                      Text(
                        details.regionName,
                        style:
                            TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.80,
                          ),
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        '${_arabicMonth(details.month)} ${details.year}',
                        style:
                            TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.72,
                          ),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .end,

                  children: [
                    Text(
                      _formatNumber(
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
                      'من ${_formatNumber(details.maxScore)} نقطة',
                      style:
                          TextStyle(
                        color:
                            Colors.white
                                .withOpacity(
                          0.78,
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
            height: 22,
          ),

          // ==================================================
          // SUMMARY TITLE
          // ==================================================

          const Text(
            'ملخص التارغت',
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          // ==================================================
          // REQUIRED + ACHIEVED
          // ==================================================

          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title:
                      'التارغت المطلوب',

                  value:
                      _formatMoney(
                    details.requiredTarget,
                  ),

                  icon:
                      Icons.flag_outlined,

                  color:
                      const Color(
                    0xFFF2994A,
                  ),

                  softColor:
                      const Color(
                    0xFFFFF3E5,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: _SummaryCard(
                  title:
                      'التارغت المحقق',

                  value:
                      _formatMoney(
                    details.achievedTarget,
                  ),

                  icon:
                      Icons
                          .check_circle_outline,

                  color:
                      const Color(
                    0xFF27AE60,
                  ),

                  softColor:
                      const Color(
                    0xFFEAF8F0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          // ==================================================
          // PERCENTAGE
          // ==================================================

          _PercentageCard(
            percentage:
                details.percentage,
          ),

          const SizedBox(
            height: 24,
          ),

          // ==================================================
          // PHARMACIES TITLE
          // ==================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الصيدليات المحتسبة',
                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textPrimary,
                    fontSize: 18,
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
                  horizontal: 11,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEAF3FF,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons
                          .storefront_outlined,
                      size: 14,
                      color:
                          Color(
                        0xFF2F80ED,
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      '${details.pharmacies.length} صيدلية',
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF2F80ED,
                        ),
                        fontSize: 11,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 6,
          ),

          const Text(
            'الصيدليات التي دخلت مبيعاتها ضمن احتساب التارغت الحالي',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          if (details.pharmacies.isEmpty)
            const _EmptyPharmacies()
          else
            ...details.pharmacies
                .asMap()
                .entries
                .map(
                  (entry) =>
                      _PharmacyRow(
                    index:
                        entry.key + 1,
                    pharmacy:
                        entry.value,
                  ),
                ),

          const SizedBox(
            height: 8,
          ),

          // ==================================================
          // INFO
          // ==================================================

          const _CalculationInfo(),
        ],
      ),
    );
  }
}

// ==========================================================
// SUMMARY CARD
// ==========================================================

class _SummaryCard
    extends StatelessWidget {
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

        border: Border.all(
          color:
              softColor,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),
            blurRadius: 10,
            offset:
                const Offset(
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
              size: 22,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            title,
            style:
                const TextStyle(
              fontSize: 11,
              color:
                  AppColors
                      .textSecondary,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          FittedBox(
            fit:
                BoxFit.scaleDown,
            alignment:
                Alignment.centerRight,

            child: Text(
              value,
              style:
                  TextStyle(
                fontSize: 18,
                color:
                    color,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// PERCENTAGE CARD
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

    const color =
        Color(0xFF00A6A6);

    const softColor =
        Color(0xFFE6F7F7);

    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border: Border.all(
          color:
              softColor,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),
            blurRadius: 10,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                    BoxDecoration(
                  color:
                      softColor,

                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),

                child: const Icon(
                  Icons
                      .trending_up_rounded,
                  color:
                      color,
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
                      'نسبة تحقيق التارغت',
                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textPrimary,
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    SizedBox(
                      height: 3,
                    ),

                    Text(
                      'النسبة بين المحقق والمطلوب',
                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${percentage.toStringAsFixed(1)}%',
                style:
                    const TextStyle(
                  color:
                      color,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          Stack(
            children: [
              Container(
                height: 9,

                decoration:
                    BoxDecoration(
                  color:
                      softColor,

                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),
              ),

              FractionallySizedBox(
                widthFactor:
                    progress,

                child: Container(
                  height: 9,

                  decoration:
                      BoxDecoration(
                    color:
                        color,

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
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
// PHARMACY ROW
// ==========================================================

class _PharmacyRow
    extends StatelessWidget {
  final int index;

  final EvaluationTargetPharmacyModel
      pharmacy;

  const _PharmacyRow({
    required this.index,
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    final bool even =
        index.isEven;

    final Color color =
        even
            ? const Color(
                0xFF00A6A6,
              )
            : const Color(
                0xFF2F80ED,
              );

    final Color soft =
        even
            ? const Color(
                0xFFE6F7F7,
              )
            : const Color(
                0xFFEAF3FF,
              );

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

        border: Border.all(
          color:
              const Color(
            0xFFE5EAF1,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.018,
            ),
            blurRadius: 8,
            offset:
                const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            alignment:
                Alignment.center,

            decoration:
                BoxDecoration(
              color:
                  soft,

              borderRadius:
                  BorderRadius.circular(
                11,
              ),
            ),

            child: Text(
              '$index',
              style:
                  TextStyle(
                color:
                    color,
                fontWeight:
                    FontWeight.w900,
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
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                const Text(
                  'مبيعات محتسبة ضمن التارغت',
                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 10,
              vertical: 7,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFEAF8F0,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                10,
              ),
            ),

            child: Text(
              _formatMoney(
                pharmacy.salesAmount,
              ),

              style:
                  const TextStyle(
                color:
                    Color(
                  0xFF219653,
                ),
                fontSize: 12,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY
// ==========================================================

class _EmptyPharmacies
    extends StatelessWidget {
  const _EmptyPharmacies();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFE5EAF1,
          ),
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons
                .storefront_outlined,
            size: 40,
            color:
                Color(
              0xFF98A2B3,
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Text(
            'لا توجد صيدليات محتسبة حالياً',
            style: TextStyle(
              color:
                  AppColors
                      .textSecondary,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// INFO
// ==========================================================

class _CalculationInfo
    extends StatelessWidget {
  const _CalculationInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFF0F7FF),
            Color(0xFFF3FBF8),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFDDEAF5,
          ),
        ),
      ),

      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            Icons
                .auto_graph_rounded,
            color:
                Color(
              0xFF1F6F8B,
            ),
            size: 21,
          ),

          SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              'يتم احتساب التارغت والمبيعات تلقائياً من العمليات المسجلة، ولا يمكن تعديل هذه القيم يدوياً.',
              style: TextStyle(
                color:
                    AppColors
                        .textSecondary,
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// ERROR
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
            Container(
              width: 64,
              height: 64,

              decoration:
                  const BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    Color(
                  0xFFFFEEEE,
                ),
              ),

              child:
                  const Icon(
                Icons.error_outline,
                color:
                    AppColors.danger,
                size: 32,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                color:
                    AppColors
                        .textSecondary,
              ),
            ),

            const SizedBox(
              height: 16,
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
// HELPERS
// ==========================================================

String _arabicMonth(int month) {
  const months =
      <int, String>{
    1: 'يناير',
    2: 'فبراير',
    3: 'مارس',
    4: 'أبريل',
    5: 'مايو',
    6: 'يونيو',
    7: 'يوليو',
    8: 'أغسطس',
    9: 'سبتمبر',
    10: 'أكتوبر',
    11: 'نوفمبر',
    12: 'ديسمبر',
  };

  return months[month] ?? '';
}

String _formatNumber(
  double value,
) {
  if (value ==
      value.truncateToDouble()) {
    return value
        .toInt()
        .toString();
  }

  return value
      .toStringAsFixed(1);
}

String _formatMoney(
  double value,
) {
  final text =
      value.toStringAsFixed(0);

  final buffer =
      StringBuffer();

  for (int i = 0;
      i < text.length;
      i++) {
    final position =
        text.length - i;

    buffer.write(
      text[i],
    );

    if (position > 1 &&
        position % 3 == 1) {
      buffer.write(',');
    }
  }

  return '${buffer.toString()} ر.س';
}