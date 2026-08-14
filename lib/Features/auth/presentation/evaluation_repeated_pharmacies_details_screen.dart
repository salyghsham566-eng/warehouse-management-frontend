import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_state.dart';

import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';

class EvaluationRepeatedPharmaciesDetailsScreen
    extends StatelessWidget {
  final String regionId;
  final int month;
  final int year;

  const EvaluationRepeatedPharmaciesDetailsScreen({
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
            'الصيدليات المكررة',
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
            EvaluationRepeatedPharmaciesDetailsBloc,
            EvaluationRepeatedPharmaciesDetailsState>(
          builder: (context, state) {
            if (state
                is EvaluationRepeatedPharmaciesDetailsLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is EvaluationRepeatedPharmaciesDetailsFailure) {
              return _ErrorView(
                message:
                    state.message,

                onRetry: () {
                  context
                      .read<
                          EvaluationRepeatedPharmaciesDetailsBloc>()
                      .add(
                        LoadEvaluationRepeatedPharmaciesDetailsEvent(
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
                is EvaluationRepeatedPharmaciesDetailsSuccess) {
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

class _Content
    extends StatelessWidget {
  final EvaluationRepeatedPharmaciesDetailsModel
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
                EvaluationRepeatedPharmaciesDetailsBloc>()
            .add(
              LoadEvaluationRepeatedPharmaciesDetailsEvent(
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
          // ==============================================
          // Header
          // ==============================================

          Container(
            padding:
                const EdgeInsets.all(18),

            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFB76E20),
                  Color(0xFFF2994A),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFFF2994A)
                          .withOpacity(0.17),
                  blurRadius: 15,
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
                            .withOpacity(0.16),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: const Icon(
                    Icons.repeat_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'الصيدليات المكررة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        details.regionName,
                        style: TextStyle(
                          color:
                              Colors.white
                                  .withOpacity(0.8),
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
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    Text(
                      'من ${_number(details.maxScore)}',
                      style: TextStyle(
                        color:
                            Colors.white
                                .withOpacity(0.75),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ==============================================
          // Summary
          // ==============================================

          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title:
                      'صيدليات مكررة',
                  value:
                      '${details.repeatedCount}',
                  icon:
                      Icons.repeat_rounded,
                  color:
                      const Color(0xFFF2994A),
                  soft:
                      const Color(0xFFFFF3E5),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _SummaryCard(
                  title:
                      'إجمالي المباعة',
                  value:
                      '${details.totalSoldPharmacies}',
                  icon:
                      Icons.storefront_outlined,
                  color:
                      const Color(0xFF2F80ED),
                  soft:
                      const Color(0xFFEAF3FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _PercentageCard(
            percentage:
                details.percentage,
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الصيدليات المكررة خلال الشهر',
                  style: TextStyle(
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
                      const Color(0xFFFFF3E5),
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Text(
                  '${details.pharmacies.length}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFFF2994A),
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Text(
            'تظهر هنا الصيدليات التي تم تسجيل عمليتي بيع أو أكثر لها خلال الشهر الحالي.',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

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
// Summary
// ==========================================================

class _SummaryCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  final Color color;
  final Color soft;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.soft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(17),

        border:
            Border.all(
          color: soft,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color: soft,
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            value,
            style:
                TextStyle(
              color: color,
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
                  AppColors.textSecondary,
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
    final progress =
        (percentage / 100)
            .clamp(0.0, 1.0);

    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(17),

        border:
            Border.all(
          color:
              const Color(0xFFFFE1C4),
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color:
                    Color(0xFF00A6A6),
              ),

              const SizedBox(width: 9),

              const Expanded(
                child: Text(
                  'نسبة الصيدليات المكررة',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
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
                      Color(0xFFF2994A),
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,

              backgroundColor:
                  const Color(
                0xFFFFF3E5,
              ),

              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                Color(0xFFF2994A),
              ),
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
  final EvaluationRepeatedPharmacyModel
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
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(15),

        border:
            Border.all(
          color:
              const Color(0xFFE5EAF1),
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
                  const Color(0xFFFFF3E5),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.repeat_rounded,
              color:
                  Color(0xFFF2994A),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  pharmacy.pharmacyName,
                  style:
                      const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                if (pharmacy
                    .regionName
                    .isNotEmpty) ...[
                  const SizedBox(height: 3),

                  Text(
                    pharmacy.regionName,
                    style:
                        const TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFEAF3FF),
                  borderRadius:
                      BorderRadius.circular(9),
                ),

                child: Text(
                  '${pharmacy.salesCount} عمليات بيع',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF2F80ED),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _formatMoney(
                  pharmacy.totalSalesAmount,
                ),

                style:
                    const TextStyle(
                  color:
                      Color(0xFF27AE60),
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

class _EmptyView
    extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border:
            Border.all(
          color:
              const Color(0xFFE5EAF1),
        ),
      ),

      child: const Center(
        child: Text(
          'لا توجد صيدليات مكررة خلال هذا الشهر',
          style: TextStyle(
            color:
                AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

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

          const SizedBox(height: 12),

          Text(message),

          const SizedBox(height: 14),

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
    );
  }
}

String _number(double value) {
  if (value ==
      value.truncateToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
}

String _formatMoney(double value) {
  return '${value.toStringAsFixed(0)} ر.س';
}