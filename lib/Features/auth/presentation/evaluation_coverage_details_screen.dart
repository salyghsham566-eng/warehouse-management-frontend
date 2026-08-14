import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_state.dart';

import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';

class EvaluationCoverageDetailsScreen
    extends StatelessWidget {
  final String regionId;
  final int month;
  final int year;

  const EvaluationCoverageDetailsScreen({
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
            const Color(
          0xFFF6F8FC,
        ),

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
            'تفاصيل تغطية الصيدليات',
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
            EvaluationCoverageDetailsBloc,
            EvaluationCoverageDetailsState>(
          builder: (context, state) {
            if (state
                is EvaluationCoverageDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is EvaluationCoverageDetailsFailure) {
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
                        color:
                            AppColors.danger,
                        size: 48,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        state.message,
                        textAlign:
                            TextAlign.center,
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<
                                  EvaluationCoverageDetailsBloc>()
                              .add(
                                LoadEvaluationCoverageDetailsEvent(
                                  regionId:
                                      regionId,
                                  month:
                                      month,
                                  year:
                                      year,
                                ),
                              );
                        },

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

            if (state
                is EvaluationCoverageDetailsSuccess) {
              return _CoverageContent(
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

class _CoverageContent
    extends StatelessWidget {
  final EvaluationCoverageDetailsModel
      details;

  const _CoverageContent({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        28,
      ),

      children: [
        // ================================================
        // Header
        // ================================================

        Container(
          padding:
              const EdgeInsets.all(
            18,
          ),

          decoration: BoxDecoration(
            gradient:
                const LinearGradient(
              begin:
                  Alignment.topRight,

              end:
                  Alignment.bottomLeft,

              colors: [
                Color(0xFF166534),
                Color(0xFF27AE60),
              ],
            ),

            borderRadius:
                BorderRadius.circular(
              20,
            ),
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
                  Icons.storefront_outlined,
                  color:
                      Colors.white,
                  size: 28,
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
                      'تغطية الصيدليات',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900,
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
                          FontWeight.w900,
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

        // ================================================
        // Summary
        // ================================================

        Row(
          children: [
            Expanded(
              child:
                  _CountCard(
                title:
                    'مغطاة',

                value:
                    details
                        .coveredCount,

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

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child:
                  _CountCard(
                title:
                    'غير مغطاة',

                value:
                    details
                        .uncoveredCount,

                icon:
                    Icons
                        .highlight_off_outlined,

                color:
                    const Color(
                  0xFFEB5757,
                ),

                softColor:
                    const Color(
                  0xFFFFEEEE,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 12,
        ),

        // ================================================
        // Percentage
        // ================================================

        Container(
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
                0xFFDDF3E6,
              ),
            ),
          ),

          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'نسبة التغطية',
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
                    '${details.percentage.toStringAsFixed(1)}%',

                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFF27AE60,
                      ),
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),

                child:
                    LinearProgressIndicator(
                  value:
                      (details.percentage /
                              100)
                          .clamp(
                            0.0,
                            1.0,
                          ),

                  minHeight:
                      9,

                  backgroundColor:
                      const Color(
                    0xFFEAF8F0,
                  ),

                  valueColor:
                      const AlwaysStoppedAnimation<
                          Color>(
                    Color(
                      0xFF27AE60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        const Text(
          'الصيدليات المغطاة',
          style: TextStyle(
            color:
                AppColors.textPrimary,
            fontSize: 17,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        if (details
            .coveredPharmacies
            .isEmpty)
          const _EmptyMessage(
            text:
                'لا توجد صيدليات مغطاة',
          )
        else
          ...details.coveredPharmacies
              .map(
            (pharmacy) =>
                _PharmacyCard(
              pharmacy:
                  pharmacy,

              covered:
                  true,
            ),
          ),

        const SizedBox(
          height: 20,
        ),

        const Text(
          'الصيدليات غير المغطاة',
          style: TextStyle(
            color:
                AppColors.textPrimary,
            fontSize: 17,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        if (details
            .uncoveredPharmacies
            .isEmpty)
          const _EmptyMessage(
            text:
                'جميع الصيدليات مغطاة',
          )
        else
          ...details
              .uncoveredPharmacies
              .map(
            (pharmacy) =>
                _PharmacyCard(
              pharmacy:
                  pharmacy,

              covered:
                  false,
            ),
          ),
      ],
    );
  }
}

// ==========================================================
// Count Card
// ==========================================================

class _CountCard
    extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  final Color color;
  final Color softColor;

  const _CountCard({
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
          const EdgeInsets.all(
        15,
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
            '$value',

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
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Pharmacy Card
// ==========================================================

class _PharmacyCard
    extends StatelessWidget {
  final EvaluationCoveragePharmacyModel
      pharmacy;

  final bool covered;

  const _PharmacyCard({
    required this.pharmacy,
    required this.covered,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        covered
            ? const Color(
                0xFF27AE60,
              )
            : const Color(
                0xFFEB5757,
              );

    final Color soft =
        covered
            ? const Color(
                0xFFEAF8F0,
              )
            : const Color(
                0xFFFFEEEE,
              );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 9,
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
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color:
                  soft,

              borderRadius:
                  BorderRadius.circular(
                11,
              ),
            ),

            child: Icon(
              covered
                  ? Icons
                      .check_rounded
                  : Icons.close_rounded,

              color:
                  color,
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
              ],
            ),
          ),

          if (covered)
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFEAF3FF,
                ),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: Text(
                '${pharmacy.salesCount} عملية بيع',

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF2F80ED,
                  ),
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyMessage
    extends StatelessWidget {
  final String text;

  const _EmptyMessage({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          14,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFE5EAF1,
          ),
        ),
      ),

      child: Center(
        child: Text(
          text,

          style:
              const TextStyle(
            color:
                AppColors
                    .textSecondary,
          ),
        ),
      ),
    );
  }
}

String _number(double value) {
  if (value ==
      value.truncateToDouble()) {
    return value
        .toInt()
        .toString();
  }

  return value.toStringAsFixed(1);
}