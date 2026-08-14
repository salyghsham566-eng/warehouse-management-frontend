import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_bloc.dart' show EvaluationRepeatedPharmaciesDetailsBloc;
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_state.dart';

import 'package:project_2/Features/auth/bloc/evaluation_target_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_target_details_event.dart';

import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/presentation/evaluation_coverage_details_screen.dart';
import 'package:project_2/Features/auth/presentation/evaluation_one_time_pharmacies_details_screen.dart';
import 'package:project_2/Features/auth/presentation/evaluation_repeated_pharmacies_details_screen.dart';
import 'package:project_2/Features/auth/presentation/evaluation_target_details_screen.dart';


class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,

          title: const Text(
            'تقييمي',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            EvaluationBloc,
            EvaluationState>(
          builder: (context, state) {
            if (state is EvaluationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EvaluationFailure) {
              return _EvaluationError(
                message: state.message,
                onRetry: () {
                  context
                      .read<EvaluationBloc>()
                      .add(
                        LoadCurrentEvaluationEvent(),
                      );
                },
              );
            }

            if (state is EvaluationSuccess) {
              return _EvaluationContent(
                evaluation: state.evaluation,
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

class _EvaluationContent extends StatelessWidget {
  final EvaluationOverviewModel evaluation;

  const _EvaluationContent({
    required this.evaluation,
  });

  @override
  Widget build(BuildContext context) {
    final availableRegions = [
      const EvaluationRegionModel(
        id: 'all',
        name: 'جميع المناطق',
      ),
      ...evaluation.regions.where(
        (region) => region.id != 'all',
      ),
    ];

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<EvaluationBloc>()
            .add(
              LoadCurrentEvaluationEvent(
                regionId:
                    evaluation.regionId,
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
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,

                colors: [
                  Color(0xFF12355B),
                  Color(0xFF1F5C8F),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFF12355B)
                          .withOpacity(0.16),
                  blurRadius: 16,
                  offset:
                      const Offset(0, 7),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white
                            .withOpacity(0.14),

                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: const Icon(
                    Icons
                        .workspace_premium_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        'التقييم الشهري الحالي',
                        style: TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.82,
                          ),
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        '${_arabicMonth(evaluation.month)} ${evaluation.year}',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        evaluation.regionName,
                        style: TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.75,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ==================================================
          // Region
          // ==================================================

          const Text(
            'نطاق التقييم',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15),

              border: Border.all(
                color:
                    const Color(0xFFE1E7EF),
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black
                          .withOpacity(0.025),
                  blurRadius: 10,
                  offset:
                      const Offset(0, 3),
                ),
              ],
            ),

            child:
                DropdownButtonHideUnderline(
              child:
                  DropdownButton<String>(
                value: evaluation.regionId,
                isExpanded: true,

                icon: const Icon(
                  Icons
                      .keyboard_arrow_down_rounded,
                  color:
                      AppColors.primary,
                ),

                items:
                    availableRegions
                        .map(
                  (region) {
                    return DropdownMenuItem<
                        String>(
                      value: region.id,

                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,

                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFEAF3FF,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                9,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .location_on_outlined,
                              size: 17,
                              color:
                                  Color(
                                0xFF2F80ED,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Text(
                            region.name,

                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .textPrimary,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),

                onChanged:
                    (regionId) {
                  if (regionId == null ||
                      regionId ==
                          evaluation
                              .regionId) {
                    return;
                  }

                  context
                      .read<
                        EvaluationBloc
                      >()
                      .add(
                        LoadCurrentEvaluationEvent(
                          regionId:
                              regionId,
                        ),
                      );
                },
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ==================================================
          // Title
          // ==================================================
// ==================================================
// UC-210 - Final Evaluation
// ==================================================

_FinalEvaluationCard(
  evaluation: evaluation,
),

const SizedBox(height: 24),

// ==================================================
// Evaluation Points Title
// ==================================================

Row(
  children: [
    const Expanded(
      child: Text(
        'نقاط التقييم',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(20),
      ),

      child: const Text(
        'من 100 نقطة',
        style: TextStyle(
          color: Color(0xFF667085),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 12),

          const SizedBox(height: 12),

          // ==================================================
          // Target
          // ==================================================

          _EvaluationScoreCard(
            icon:
                Icons.track_changes_outlined,

            title:
                'نقاط التارغت',

            subtitle:
                'تحقيق الهدف البيعي الشهري',

            score:
                evaluation.targetScore,

            maxScore: 35,

            color:
                const Color(0xFF2F80ED),

            softColor:
                const Color(0xFFEAF3FF),

            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider<
                        EvaluationTargetDetailsBloc>(
                      create: (_) =>
                          sl<
                              EvaluationTargetDetailsBloc>()
                            ..add(
                              LoadEvaluationTargetDetailsEvent(
                                regionId:
                                    evaluation
                                        .regionId,
                                month:
                                    evaluation
                                        .month,
                                year:
                                    evaluation
                                        .year,
                              ),
                            ),

                      child:
                          EvaluationTargetDetailsScreen(
                        regionId:
                            evaluation.regionId,
                        month:
                            evaluation.month,
                        year:
                            evaluation.year,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ==================================================
          // Coverage
          // ==================================================

          _EvaluationScoreCard(
  icon:
      Icons.storefront_outlined,

  title:
      'تغطية الصيدليات',

  subtitle:
      'الصيدليات المشمولة بالتغطية',

  score:
      evaluation.coverageScore,

  maxScore: 35,

  color:
      const Color(0xFF27AE60),

  softColor:
      const Color(0xFFEAF8F0),

  onTap: () {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              EvaluationCoverageDetailsBloc>(
            create: (_) =>
                sl<
                    EvaluationCoverageDetailsBloc>()
                  ..add(
                    LoadEvaluationCoverageDetailsEvent(
                      regionId:
                          evaluation.regionId,
                      month:
                          evaluation.month,
                      year:
                          evaluation.year,
                    ),
                  ),

            child:
                EvaluationCoverageDetailsScreen(
              regionId:
                  evaluation.regionId,
              month:
                  evaluation.month,
              year:
                  evaluation.year,
            ),
          );
        },
      ),
    );
  },
),

          const SizedBox(height: 12),

          // ==================================================
          // Repeated
          // ==================================================

         _EvaluationScoreCard(
  icon:
      Icons.repeat_rounded,

  title:
      'الصيدليات المكررة',

  subtitle:
      'تم البيع لها مرتين أو أكثر',

  score:
      evaluation.repeatedScore,

  maxScore: 20,

  color:
      const Color(0xFFF2994A),

  softColor:
      const Color(0xFFFFF3E5),

  onTap: () {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              EvaluationRepeatedPharmaciesDetailsBloc>(
            create: (_) =>
                sl<
                    EvaluationRepeatedPharmaciesDetailsBloc>()
                  ..add(
                    LoadEvaluationRepeatedPharmaciesDetailsEvent(
                      regionId:
                          evaluation.regionId,
                      month:
                          evaluation.month,
                      year:
                          evaluation.year,
                    ),
                  ),

            child:
                EvaluationRepeatedPharmaciesDetailsScreen(
              regionId:
                  evaluation.regionId,
              month:
                  evaluation.month,
              year:
                  evaluation.year,
            ),
          );
        },
      ),
    );
  },
),

          const SizedBox(height: 12),

          // ==================================================
          // One time
          // ==================================================

          _EvaluationScoreCard(
  icon:
      Icons.looks_one_outlined,

  title:
      'المباعة مرة واحدة',

  subtitle:
      'تم البيع لها مرة واحدة خلال الشهر',

  score:
      evaluation.oneTimeScore,

  maxScore: 10,

  color:
      const Color(0xFF00A6A6),

  softColor:
      const Color(0xFFE6F7F7),

  onTap: () {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              EvaluationOneTimePharmaciesDetailsBloc>(
            create: (_) =>
                sl<
                    EvaluationOneTimePharmaciesDetailsBloc>()
                  ..add(
                    LoadEvaluationOneTimePharmaciesDetailsEvent(
                      regionId:
                          evaluation.regionId,
                      month:
                          evaluation.month,
                      year:
                          evaluation.year,
                    ),
                  ),

            child:
                EvaluationOneTimePharmaciesDetailsScreen(
              regionId:
                  evaluation.regionId,
              month:
                  evaluation.month,
              year:
                  evaluation.year,
            ),
          );
        },
      ),
    );
  },
),

          const SizedBox(height: 18),

          const _AutomaticCalculationInfo(),
        ],
      ),
    );
  }
}

// ==========================================================
// Evaluation Card
// ==========================================================

class _EvaluationScoreCard
    extends StatelessWidget {
  final IconData icon;

  final String title;
  final String subtitle;

  final EvaluationScoreModel score;

  final double maxScore;

  final Color color;
  final Color softColor;

  final VoidCallback? onTap;

  const _EvaluationScoreCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.maxScore,
    required this.color,
    required this.softColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        maxScore <= 0
            ? 0
            : (score.score / maxScore)
                .clamp(
                  0.0,
                  1.0,
                );

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        child: Container(
          padding:
              const EdgeInsets.all(
            16,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            border: Border.all(
              color:
                  softColor.withOpacity(
                0.9,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black
                        .withOpacity(
                  0.025,
                ),
                blurRadius: 12,
                offset:
                    const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,

                    decoration:
                        BoxDecoration(
                      color: softColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                        15,
                      ),
                    ),

                    child: Icon(
                      icon,
                      color: color,
                      size: 25,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          title,

                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w800,
                            color:
                                AppColors
                                    .textPrimary,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          subtitle,

                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                AppColors
                                    .textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                        children: [
                          Text(
                            _formatScore(
                              score.score,
                            ),

                            style:
                                TextStyle(
                              color: color,
                              fontSize: 23,
                              fontWeight:
                                  FontWeight
                                      .w900,
                            ),
                          ),

                          Text(
                            ' / ${_formatScore(maxScore)}',

                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .textSecondary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      const Text(
                        'نقطة',
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

                  if (onTap != null) ...[
                    const SizedBox(
                      width: 5,
                    ),

                    Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      size: 13,
                      color:
                          color.withOpacity(
                        0.7,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              Stack(
                children: [
                  Container(
                    height: 8,

                    decoration:
                        BoxDecoration(
                      color: softColor,

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
                      height: 8,

                      decoration:
                          BoxDecoration(
                        color: color,

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

              const SizedBox(
                height: 7,
              ),

              Row(
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% من نقاط البند',

                    style:
                        TextStyle(
                      fontSize: 10,
                      color:
                          color.withOpacity(
                        0.85,
                      ),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Automatic calculation
// ==========================================================

class _AutomaticCalculationInfo
    extends StatelessWidget {
  const _AutomaticCalculationInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFF0F7FF),
            Color(0xFFF5FBFA),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          16,
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
            Icons.autorenew_rounded,
            color:
                Color(0xFF1F6F8B),
            size: 22,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'يتم تحديث نقاط التقييم تلقائياً بعد كل عملية بيع، ولا يمكن تعديلها يدوياً.',
              style: TextStyle(
                fontSize: 12,
                height: 1.6,
                color:
                    AppColors
                        .textSecondary,
              ),
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

class _EvaluationError
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _EvaluationError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),

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

              child: const Icon(
                Icons.error_outline,
                size: 32,
                color:
                    AppColors.danger,
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
              onPressed: onRetry,

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

String _arabicMonth(
  int month,
) {
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

String _formatScore(
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
}// ==========================================================
// UC-210 - Final Evaluation
// ==========================================================

class _FinalEvaluationCard
    extends StatelessWidget {
  final EvaluationOverviewModel evaluation;

  const _FinalEvaluationCard({
    required this.evaluation,
  });

  @override
  Widget build(BuildContext context) {
    final double score =
        evaluation.finalScore;

    final double maxScore =
        evaluation.finalMaxScore;

    final double percentage =
        evaluation.finalPercentage;

    final double progress =
        (percentage / 100).clamp(
      0.0,
      1.0,
    );

    return Container(
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
            Color(0xFF173F5F),
            Color(0xFF20639B),
            Color(0xFF00A6A6),
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
              0xFF173F5F,
            ).withOpacity(
              0.18,
            ),

            blurRadius: 18,

            offset:
                const Offset(
              0,
              7,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
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
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .emoji_events_outlined,

                  color:
                      Colors.white,

                  size: 29,
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      'التقييم النهائي',

                      style:
                          TextStyle(
                        color:
                            Colors.white
                                .withOpacity(
                          0.82,
                        ),

                        fontSize:
                            13,

                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    const Text(
                      'مجموع نقاط التقييم',

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            17,

                        fontWeight:
                            FontWeight
                                .w900,
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
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children: [
                      Text(
                        _formatScore(
                          score,
                        ),

                        style:
                            const TextStyle(
                          color:
                              Colors.white,

                          fontSize:
                              30,

                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),

                      Text(
                        ' / ${_formatScore(maxScore)}',

                        style:
                            TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(
                            0.75,
                          ),

                          fontSize:
                              13,

                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'نقطة',

                    style:
                        TextStyle(
                      color:
                          Colors.white
                              .withOpacity(
                        0.70,
                      ),

                      fontSize:
                          10,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // Progress
          Stack(
            children: [
              Container(
                height:
                    10,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withOpacity(
                    0.18,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              FractionallySizedBox(
                widthFactor:
                    progress,

                child:
                    Container(
                  height:
                      10,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
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
                  '${percentage.toStringAsFixed(1)}% من التقييم الكلي',

                  style:
                      TextStyle(
                    color:
                        Colors.white
                            .withOpacity(
                      0.84,
                    ),

                    fontSize:
                        11,

                    fontWeight:
                        FontWeight
                            .w600,
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
                      5,
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
                    const Row(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    Icon(
                      Icons
                          .autorenew_rounded,

                      color:
                          Colors.white,

                      size:
                          13,
                    ),

                    SizedBox(
                      width:
                          4,
                    ),

                    Text(
                      'محسوب تلقائياً',

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            10,

                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          // Breakdown
          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  10,
              vertical:
                  11,
            ),

            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withOpacity(
                0.10,
              ),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child:
                Row(
              children: [
                Expanded(
                  child:
                      _FinalMiniScore(
                    title:
                        'التارغت',

                    score:
                        evaluation
                            .targetScore
                            .score,

                    max:
                        35,
                  ),
                ),

                _VerticalDivider(),

                Expanded(
                  child:
                      _FinalMiniScore(
                    title:
                        'التغطية',

                    score:
                        evaluation
                            .coverageScore
                            .score,

                    max:
                        35,
                  ),
                ),

                _VerticalDivider(),

                Expanded(
                  child:
                      _FinalMiniScore(
                    title:
                        'المكررة',

                    score:
                        evaluation
                            .repeatedScore
                            .score,

                    max:
                        20,
                  ),
                ),

                _VerticalDivider(),

                Expanded(
                  child:
                      _FinalMiniScore(
                    title:
                        'مرة',

                    score:
                        evaluation
                            .oneTimeScore
                            .score,

                    max:
                        10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}class _FinalMiniScore
    extends StatelessWidget {
  final String title;

  final double score;
  final double max;

  const _FinalMiniScore({
    required this.title,
    required this.score,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _formatScore(
            score,
          ),

          style:
              const TextStyle(
            color:
                Colors.white,

            fontSize:
                15,

            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 2,
        ),

        Text(
          '$title / ${_formatScore(max)}',

          textAlign:
              TextAlign.center,

          style:
              TextStyle(
            color:
                Colors.white
                    .withOpacity(
              0.70,
            ),

            fontSize:
                8,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider
    extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          1,

      height:
          30,

      color:
          Colors.white.withOpacity(
        0.16,
      ),
    );
  }
}