import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_archive_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_archive_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_archive_state.dart';

import 'package:project_2/Features/auth/data/models/evaluation_archive_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_work_plans_state.dart';

class EvaluationArchiveScreen
    extends StatefulWidget {
  final String initialRegionId;

  final List<EvaluationRegionModel>
      regions;

  const EvaluationArchiveScreen({
    super.key,
    required this.initialRegionId,
    required this.regions,
  });

  @override
  State<EvaluationArchiveScreen>
      createState() =>
          _EvaluationArchiveScreenState();
}

class _EvaluationArchiveScreenState
    extends State<EvaluationArchiveScreen> {
  String _selectedRegionId = 'all';

  String _selectedMonthKey = 'all';

  // =========================================================
  // Previous 12 months
  // =========================================================

  List<DateTime> get _months {
    final DateTime now =
        DateTime.now();

    return List.generate(
      12,
      (index) => DateTime(
        now.year,
        now.month - (index + 1),
        1,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final bool regionExists =
        widget.initialRegionId == 'all' ||
            widget.regions.any(
              (region) =>
                  region.id ==
                  widget.initialRegionId,
            );

    _selectedRegionId =
        regionExists
            ? widget.initialRegionId
            : 'all';

    _loadArchive();
  }

  // =========================================================
  // Load
  // =========================================================

  void _loadArchive() {
    int? month;
    int? year;

    if (_selectedMonthKey != 'all') {
      final List<String> values =
          _selectedMonthKey.split('-');

      if (values.length == 2) {
        year =
            int.tryParse(
          values[0],
        );

        month =
            int.tryParse(
          values[1],
        );
      }
    }

    context
        .read<EvaluationArchiveBloc>()
        .add(
          LoadEvaluationArchiveEvent(
            regionId:
                _selectedRegionId,
            month:
                month,
            year:
                year,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final List<EvaluationRegionModel>
        availableRegions = [
      const EvaluationRegionModel(
        id: 'all',
        name: 'جميع المناطق',
      ),
      ...widget.regions.where(
        (region) =>
            region.id != 'all',
      ),
    ];

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

          elevation:
              0,

          centerTitle:
              true,

          foregroundColor:
              AppColors.primary,

          title:
              const Text(
            'أرشيف التقييمات',

            style:
                TextStyle(
              color:
                  AppColors
                      .textPrimary,

              fontSize:
                  19,

              fontWeight:
                  FontWeight
                      .w800,
            ),
          ),
        ),

        body: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),

          children: [
            // =================================================
            // Header
            // =================================================

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
                  const Row(
                children: [
                  Icon(
                    Icons
                        .history_rounded,

                    color:
                        Colors.white,

                    size:
                        31,
                  ),

                  SizedBox(
                    width:
                        13,
                  ),

                  Expanded(
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          'التقييمات السابقة',

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

                        SizedBox(
                          height:
                              4,
                        ),

                        Text(
                          'استعراض تقييمات الأشهر السابقة للمراجعة فقط',

                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFFD8E6F3,
                            ),

                            fontSize:
                                12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _ReadOnlyBadge(),
                ],
              ),
            ),

            const SizedBox(
              height:
                  20,
            ),

            // =================================================
            // Filters Title
            // =================================================

            const Text(
              'تصفية النتائج',

              style:
                  TextStyle(
                color:
                    AppColors
                        .textPrimary,

                fontSize:
                    17,

                fontWeight:
                    FontWeight
                        .w800,
              ),
            ),

            const SizedBox(
              height:
                  10,
            ),

            // =================================================
            // Filters
            // =================================================

            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                border:
                    Border.all(
                  color:
                      const Color(
                    0xFFE1E7EF,
                  ),
                ),
              ),

              child:
                  Column(
                children: [
                  // ===========================================
                  // Month
                  // ===========================================

                  DropdownButtonFormField<
                      String>(
                    value:
                        _selectedMonthKey,

                    decoration:
                        InputDecoration(
                      labelText:
                          'الشهر',

                      prefixIcon:
                          const Icon(
                        Icons
                            .calendar_month_outlined,

                        color:
                            AppColors
                                .primary,
                      ),

                      filled:
                          true,

                      fillColor:
                          const Color(
                        0xFFF8FAFC,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),

                    items: [
                      const DropdownMenuItem<
                          String>(
                        value:
                            'all',

                        child:
                            Text(
                          'كل الأشهر السابقة',
                        ),
                      ),

                      ..._months.map(
                        (date) {
                          final String key =
                              '${date.year}-${date.month}';

                          return DropdownMenuItem<
                              String>(
                            value:
                                key,

                            child:
                                Text(
                              '${_arabicMonth(date.month)} ${date.year}',
                            ),
                          );
                        },
                      ),
                    ],

                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setState(
                        () {
                          _selectedMonthKey =
                              value;
                        },
                      );

                      _loadArchive();
                    },
                  ),

                  const SizedBox(
                    height:
                        12,
                  ),

                  // ===========================================
                  // Region
                  // ===========================================

                  DropdownButtonFormField<
                      String>(
                    value:
                        _selectedRegionId,

                    decoration:
                        InputDecoration(
                      labelText:
                          'المنطقة',

                      prefixIcon:
                          const Icon(
                        Icons
                            .location_on_outlined,

                        color:
                            AppColors
                                .primary,
                      ),

                      filled:
                          true,

                      fillColor:
                          const Color(
                        0xFFF8FAFC,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),

                    items:
                        availableRegions
                            .map(
                      (region) {
                        return DropdownMenuItem<
                            String>(
                          value:
                              region.id,

                          child:
                              Text(
                            region.name,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setState(
                        () {
                          _selectedRegionId =
                              value;
                        },
                      );

                      _loadArchive();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height:
                  20,
            ),

            // =================================================
            // Results
            // =================================================

            BlocBuilder<
                EvaluationArchiveBloc,
                EvaluationArchiveState>(
              builder:
                  (context, state) {
                if (state
                        is EvaluationArchiveLoading ||
                    state
                        is EvaluationArchiveInitial) {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical:
                          50,
                    ),

                    child:
                        Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  );
                }

                if (state
                    is EvaluationArchiveFailure) {
                  return _ArchiveError(
                    message:
                        state.message,

                    onRetry:
                        _loadArchive,
                  );
                }

                if (state
                    is EvaluationArchiveSuccess) {
                  if (state
                      .evaluations
                      .isEmpty) {
                    return const _ArchiveEmpty();
                  }

                  return Column(
                    children: [
                      for (
                        int index = 0;
                        index <
                            state
                                .evaluations
                                .length;
                        index++
                      ) ...[
                        _ArchiveEvaluationCard(
                          evaluation:
                              state
                                  .evaluations[
                              index],
                        ),

                        if (index !=
                            state
                                    .evaluations
                                    .length -
                                1)
                          const SizedBox(
                            height:
                                14,
                          ),
                      ],
                    ],
                  );
                }

                return const SizedBox
                    .shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// Archive Evaluation Card
// =========================================================

class _ArchiveEvaluationCard
    extends StatelessWidget {
  final EvaluationArchiveModel
      evaluation;

  const _ArchiveEvaluationCard({
    required this.evaluation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFFE1E7EF,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),

            blurRadius:
                12,

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
          // Period
          // =================================================

          Row(
            children: [
              Container(
                width:
                    44,

                height:
                    44,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEAF3FF,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    13,
                  ),
                ),

                child:
                    const Icon(
                  Icons
                      .calendar_month_outlined,

                  color:
                      Color(
                    0xFF2F80ED,
                  ),
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
                      '${_arabicMonth(evaluation.month)} ${evaluation.year}',

                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .textPrimary,

                        fontSize:
                            16,

                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    const SizedBox(
                      height:
                          3,
                    ),

                    Text(
                      evaluation
                          .regionName,

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
              ),

              const _ReadOnlyBadge(),
            ],
          ),

          const SizedBox(
            height:
                16,
          ),

          // =================================================
          // Final Score
          // =================================================

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  14,

              vertical:
                  13,
            ),

            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(
                    0xFFF0F7FF,
                  ),
                  Color(
                    0xFFF3FBFA,
                  ),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child:
                Row(
              children: [
                const Expanded(
                  child:
                      Text(
                    'النتيجة النهائية',

                    style:
                        TextStyle(
                      color:
                          AppColors
                              .textPrimary,

                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),
                ),

                Text(
                  '${_formatScore(evaluation.finalScore)} / ${_formatScore(evaluation.finalMaxScore)}',

                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .primary,

                    fontSize:
                        20,

                    fontWeight:
                        FontWeight
                            .w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height:
                16,
          ),

          const Text(
            'نقاط البنود',

            style:
                TextStyle(
              color:
                  AppColors
                      .textPrimary,

              fontSize:
                  14,

              fontWeight:
                  FontWeight
                      .w800,
            ),
          ),

          const SizedBox(
            height:
                9,
          ),

          _ArchiveScoreRow(
            title:
                'نقاط التارغت',

            score:
                evaluation
                    .targetScore
                    .score,

            maxScore:
                evaluation
                    .targetScore
                    .maxScore,
          ),

          _ArchiveScoreRow(
            title:
                'تغطية الصيدليات',

            score:
                evaluation
                    .coverageScore
                    .score,

            maxScore:
                evaluation
                    .coverageScore
                    .maxScore,
          ),

          _ArchiveScoreRow(
            title:
                'الصيدليات المكررة',

            score:
                evaluation
                    .repeatedScore
                    .score,

            maxScore:
                evaluation
                    .repeatedScore
                    .maxScore,
          ),

          _ArchiveScoreRow(
            title:
                'المباعة مرة واحدة',

            score:
                evaluation
                    .oneTimeScore
                    .score,

            maxScore:
                evaluation
                    .oneTimeScore
                    .maxScore,
          ),

          const SizedBox(
            height:
                15,
          ),

          const Divider(
            height:
                1,
          ),

          const SizedBox(
            height:
                15,
          ),

          // =================================================
          // UC-211 inside archive
          // =================================================

          Row(
            children: [
              const Expanded(
                child:
                    Text(
                  'تقييم خطط العمل',

                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textPrimary,

                    fontSize:
                        14,

                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),
              ),

              Text(
                '${evaluation.workPlanEvaluations.length} خطة',

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
                10,
          ),

          if (evaluation
              .workPlanEvaluations
              .isEmpty)
            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                12,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF8FAFC,
                ),

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child:
                  const Text(
                'لا يوجد تقييم لخطط العمل في هذا الشهر.',

                style:
                    TextStyle(
                  color:
                      AppColors
                          .textSecondary,

                  fontSize:
                      11,
                ),
              ),
            )
          else
            Column(
              children: [
                for (
                  int index = 0;
                  index <
                      evaluation
                          .workPlanEvaluations
                          .length;
                  index++
                ) ...[
                  _ArchivedWorkPlanCard(
                    plan:
                        evaluation
                                .workPlanEvaluations[
                            index],
                  ),

                  if (index !=
                      evaluation
                              .workPlanEvaluations
                              .length -
                          1)
                    const SizedBox(
                      height:
                          8,
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

// =========================================================
// Score Row
// =========================================================

class _ArchiveScoreRow
    extends StatelessWidget {
  final String title;
  final double score;
  final double maxScore;

  const _ArchiveScoreRow({
    required this.title,
    required this.score,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            6,
      ),

      child:
          Row(
        children: [
          Expanded(
            child:
                Text(
              title,

              style:
                  const TextStyle(
                color:
                    AppColors
                        .textSecondary,

                fontSize:
                    12,

                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ),

          Text(
            '${_formatScore(score)} / ${_formatScore(maxScore)}',

            style:
                const TextStyle(
              color:
                  AppColors
                      .textPrimary,

              fontSize:
                  12,

              fontWeight:
                  FontWeight
                      .w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Archived Work Plan
// =========================================================

class _ArchivedWorkPlanCard
    extends StatelessWidget {
  final EvaluationWorkPlanModel plan;

  const _ArchivedWorkPlanCard({
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final Color ratingColor =
        _ratingColor(
      plan.rating,
    );

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        12,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF8FAFC,
        ),

        borderRadius:
            BorderRadius.circular(
          13,
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
              Expanded(
                child:
                    Text(
                  plan.planName,

                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .textPrimary,

                    fontSize:
                        12,

                    fontWeight:
                        FontWeight
                            .w800,
                  ),
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
                      ratingColor
                          .withOpacity(
                    0.10,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child:
                    Text(
                  plan.rating,

                  style:
                      TextStyle(
                    color:
                        ratingColor,

                    fontSize:
                        10,

                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                7,
          ),

          Text(
            'الفترة: ${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}',

            style:
                const TextStyle(
              color:
                  AppColors
                      .textSecondary,

              fontSize:
                  10,
            ),
          ),

          const SizedBox(
            height:
                7,
          ),

          Row(
            children: [
              const Expanded(
                child:
                    Text(
                  'نسبة الإنجاز',

                  style:
                      TextStyle(
                    color:
                        AppColors
                            .textSecondary,

                    fontSize:
                        10,
                  ),
                ),
              ),

              Text(
                '${plan.completionPercentage.toStringAsFixed(0)}%',

                style:
                    const TextStyle(
                  color:
                      AppColors
                          .primary,

                  fontSize:
                      11,

                  fontWeight:
                      FontWeight
                          .w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Read Only
// =========================================================

class _ReadOnlyBadge
    extends StatelessWidget {
  const _ReadOnlyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            8,

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
          const Text(
        'للمراجعة فقط',

        style:
            TextStyle(
          color:
              Color(
            0xFF667085,
          ),

          fontSize:
              9,

          fontWeight:
              FontWeight
                  .w700,
        ),
      ),
    );
  }
}

// =========================================================
// Empty
// =========================================================

class _ArchiveEmpty
    extends StatelessWidget {
  const _ArchiveEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        25,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
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
                AppColors
                    .textSecondary,
          ),

          SizedBox(
            height:
                10,
          ),

          Text(
            'لا توجد تقييمات سابقة مطابقة للفلاتر المحددة.',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              color:
                  AppColors
                      .textSecondary,

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

class _ArchiveError
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ArchiveError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        20,
      ),

      child:
          Column(
        children: [
          const Icon(
            Icons
                .error_outline,

            size:
                40,

            color:
                AppColors
                    .danger,
          ),

          const SizedBox(
            height:
                10,
          ),

          Text(
            message,

            textAlign:
                TextAlign.center,
          ),

          const SizedBox(
            height:
                10,
          ),

          TextButton.icon(
            onPressed:
                onRetry,

            icon:
                const Icon(
              Icons
                  .refresh,
            ),

            label:
                const Text(
              'إعادة المحاولة',
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Helpers
// =========================================================

String _arabicMonth(
  int month,
) {
  const Map<int, String> months = {
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
      .toStringAsFixed(
    1,
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

Color _ratingColor(
  String rating,
) {
  switch (rating.trim()) {
    case 'ممتاز':
      return const Color(
        0xFF14804A,
      );

    case 'جيد جداً':
    case 'جيد جدا':
      return const Color(
        0xFF2F80ED,
      );

    case 'جيد':
      return const Color(
        0xFFB26A1B,
      );

    case 'سيء':
      return const Color(
        0xFFD92D20,
      );

    default:
      return AppColors
          .textSecondary;
  }
}