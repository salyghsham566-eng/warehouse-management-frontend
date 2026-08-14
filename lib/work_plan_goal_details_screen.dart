import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_goal_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_state.dart';

import 'package:project_2/Features/auth/data/models/work_plan_goal_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';

class WorkPlanGoalDetailsScreen extends StatelessWidget {
  final int planId;
  final int goalId;

  const WorkPlanGoalDetailsScreen({
    super.key,
    required this.planId,
    required this.goalId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: const Color(0xFF102A43),
          title: const Text(
            'تفاصيل إنجاز الهدف',
            style: TextStyle(
              color: Color(0xFF102A43),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            WorkPlanGoalDetailsBloc,
            WorkPlanGoalDetailsState>(
          builder: (context, state) {
            // ================================================
            // Loading
            // ================================================

            if (state is WorkPlanGoalDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ================================================
            // Error
            // ================================================

            if (state is WorkPlanGoalDetailsFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 55,
                        color: Colors.redAccent,
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'تعذر تحميل تفاصيل الهدف',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ================================================
            // Loaded
            // ================================================

            if (state is WorkPlanGoalDetailsLoaded) {
              final details = state.details;

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  30,
                ),
                children: [
                  // ==========================================
                  // ملخص الهدف
                  // موجود بكل الأنواع
                  // ==========================================

                  _GoalSummaryCard(
                    details: details,
                  ),

                  const SizedBox(height: 20),

                  // ==========================================
                  // التفاصيل حسب نوع الهدف
                  // ==========================================

                  switch (details.type) {
                    WorkPlanGoalType.general =>
                      _buildGeneralGoal(details),

                    WorkPlanGoalType.sales =>
                      _buildSalesGoal(details),

                    WorkPlanGoalType.pharmacyCoverage =>
                      _buildCoverageGoal(
                        details,
                        isVisits: false,
                      ),

                    WorkPlanGoalType.visits =>
                      _buildCoverageGoal(
                        details,
                        isVisits: true,
                      ),

                    WorkPlanGoalType.collection =>
                      _buildCollectionGoal(details),
                  },
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // =========================================================
  // UC-194
  // تفاصيل هدف عام
  // =========================================================

  Widget _buildGeneralGoal(
    WorkPlanGoalDetailsModel details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'البيانات الفعلية المحتسبة',
          icon: Icons.analytics_outlined,
        ),

        const SizedBox(height: 10),

        if (details.actualData.isEmpty)
          const _EmptyDetailsCard(
            message: 'لا توجد بيانات فعلية محتسبة لهذا الهدف',
          )
        else
          ...details.actualData.map(
            (item) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _ActualDataCard(
                  item: item,
                ),
              );
            },
          ),
      ],
    );
  }

  // =========================================================
  // UC-195
  // تفاصيل هدف المبيعات
  // =========================================================

  Widget _buildSalesGoal(
    WorkPlanGoalDetailsModel details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: _SectionTitle(
                title: 'الفواتير المحتسبة',
                icon: Icons.receipt_long_outlined,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${details.invoices.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF087443),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (details.invoices.isEmpty)
          const _EmptyDetailsCard(
            message: 'لا توجد فواتير محتسبة لهذا الهدف',
          )
        else
          ...details.invoices.map(
            (invoice) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _InvoiceCard(
                  invoice: invoice,
                ),
              );
            },
          ),
      ],
    );
  }

  // =========================================================
  // UC-196
  // تفاصيل التغطية أو الزيارات
  // =========================================================

  Widget _buildCoverageGoal(
    WorkPlanGoalDetailsModel details, {
    required bool isVisits,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SectionTitle(
                title: isVisits
                    ? 'الزيارات المحتسبة'
                    : 'الصيدليات المحتسبة',
                icon: isVisits
                    ? Icons.location_on_outlined
                    : Icons.local_pharmacy_outlined,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isVisits
                    ? const Color(0xFFF2EEFF)
                    : const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${details.coverage.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isVisits
                      ? const Color(0xFF6941C6)
                      : const Color(0xFF175CD3),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (details.coverage.isEmpty)
          _EmptyDetailsCard(
            message: isVisits
                ? 'لا توجد زيارات محتسبة لهذا الهدف'
                : 'لا توجد صيدليات محتسبة لهذا الهدف',
          )
        else
          ...details.coverage.map(
            (item) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _CoverageCard(
                  item: item,
                  isVisit: isVisits,
                ),
              );
            },
          ),
      ],
    );
  }

  // =========================================================
  // UC-197
  // ملخص هدف التحصيل
  // =========================================================

  Widget _buildCollectionGoal(
    WorkPlanGoalDetailsModel details,
  ) {
    final summary = details.collectionSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'ملخص التحصيل',
          icon: Icons.payments_outlined,
        ),

        const SizedBox(height: 10),

        if (summary == null)
          const _EmptyDetailsCard(
            message: 'لا يوجد ملخص تحصيل متاح',
          )
        else
          _CollectionSummaryCard(
            summary: summary,
          ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFF5E5B8),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFFB54708),
              ),

              SizedBox(width: 8),

              Expanded(
                child: Text(
                  'يتم عرض ملخص التحصيل فقط. تفاصيل عمليات التحصيل متاحة من قسم التحصيل.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.6,
                    color: Color(0xFF7A5B17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// Summary Card
// ===========================================================

class _GoalSummaryCard extends StatelessWidget {
  final WorkPlanGoalDetailsModel details;

  const _GoalSummaryCard({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final typeInfo =
        _getGoalTypeInfo(details.type);

    final progress =
        details.progress.clamp(0, 100).toDouble() / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: typeInfo.backgroundColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  typeInfo.icon,
                  color: typeInfo.color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  details.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF102A43),
                  ),
                ),
              ),

              Text(
                '${details.progress.toInt()}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: typeInfo.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
                  const Color(0xFFE8EDF3),
              valueColor: AlwaysStoppedAnimation<Color>(
                typeInfo.color,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  title: 'المستهدف',
                  value:
                      '${_formatNumber(details.targetValue)} ${details.unit}',
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFEAECF0),
              ),

              Expanded(
                child: _SummaryValue(
                  title: 'المنجز',
                  value:
                      '${_formatNumber(details.achievedValue)} ${details.unit}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Summary Value
// ===========================================================

class _SummaryValue extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryValue({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF98A2B3),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF344054),
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// Section Title
// ===========================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF0B2D5B),
        ),

        const SizedBox(width: 7),

        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// UC-194 Actual Data
// ===========================================================

class _ActualDataCard extends StatelessWidget {
  final GoalActualDataModel item;

  const _ActualDataCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Color(0xFF475467),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),

                if (item.date.isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Text(
                    _formatDate(item.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF98A2B3),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Text(
            item.value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0B2D5B),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// UC-195 Invoice
// ===========================================================

class _InvoiceCard extends StatelessWidget {
  final GoalInvoiceModel invoice;

  const _InvoiceCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF3),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF087443),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.pharmacyName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'فاتورة ${invoice.invoiceNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${_formatNumber(invoice.amount)} ر.س',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF087443),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(
            height: 1,
            color: Color(0xFFEAECF0),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Color(0xFF98A2B3),
              ),

              const SizedBox(width: 5),

              Text(
                _formatDate(invoice.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// UC-196 Coverage / Visit
// ===========================================================

class _CoverageCard extends StatelessWidget {
  final GoalCoverageModel item;
  final bool isVisit;

  const _CoverageCard({
    required this.item,
    required this.isVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.completed
                  ? const Color(0xFFECFDF3)
                  : const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isVisit
                  ? Icons.location_on_outlined
                  : Icons.local_pharmacy_outlined,
              color: item.completed
                  ? const Color(0xFF087443)
                  : const Color(0xFF98A2B3),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.pharmacyName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344054),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.completed
                      ? isVisit
                          ? 'تمت الزيارة'
                          : 'تمت التغطية'
                      : isVisit
                          ? 'لم تتم الزيارة'
                          : 'لم تتم التغطية',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.completed
                        ? const Color(0xFF087443)
                        : const Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),

          if (item.completed &&
              item.date.isNotEmpty)
            Text(
              _formatDate(item.date),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF667085),
              ),
            ),

          const SizedBox(width: 6),

          Icon(
            item.completed
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 20,
            color: item.completed
                ? const Color(0xFF12B76A)
                : const Color(0xFFD0D5DD),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// UC-197 Collection Summary
// ===========================================================

class _CollectionSummaryCard extends StatelessWidget {
  final CollectionGoalSummaryModel summary;

  const _CollectionSummaryCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          _CollectionRow(
            title: 'المبلغ المستهدف',
            value:
                '${_formatNumber(summary.targetAmount)} ر.س',
          ),

          const Divider(
            height: 28,
            color: Color(0xFFEAECF0),
          ),

          _CollectionRow(
            title: 'المبلغ المحصل',
            value:
                '${_formatNumber(summary.collectedAmount)} ر.س',
          ),

          const Divider(
            height: 28,
            color: Color(0xFFEAECF0),
          ),

          _CollectionRow(
            title: 'عدد عمليات التحصيل',
            value:
                '${summary.operationsCount} عملية',
          ),
        ],
      ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  final String title;
  final String value;

  const _CollectionRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF667085),
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// Empty
// ===========================================================

class _EmptyDetailsCard extends StatelessWidget {
  final String message;

  const _EmptyDetailsCard({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 36,
            color: Color(0xFF98A2B3),
          ),

          const SizedBox(height: 8),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Goal Type Style
// ===========================================================

class _GoalTypeInfo {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _GoalTypeInfo({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

_GoalTypeInfo _getGoalTypeInfo(
  WorkPlanGoalType type,
) {
  switch (type) {
    case WorkPlanGoalType.general:
      return const _GoalTypeInfo(
        icon: Icons.flag_outlined,
        color: Color(0xFF475467),
        backgroundColor: Color(0xFFF2F4F7),
      );

    case WorkPlanGoalType.sales:
      return const _GoalTypeInfo(
        icon: Icons.trending_up,
        color: Color(0xFF087443),
        backgroundColor: Color(0xFFECFDF3),
      );

    case WorkPlanGoalType.pharmacyCoverage:
      return const _GoalTypeInfo(
        icon: Icons.local_pharmacy_outlined,
        color: Color(0xFF175CD3),
        backgroundColor: Color(0xFFEFF8FF),
      );

    case WorkPlanGoalType.visits:
      return const _GoalTypeInfo(
        icon: Icons.location_on_outlined,
        color: Color(0xFF6941C6),
        backgroundColor: Color(0xFFF4F3FF),
      );

    case WorkPlanGoalType.collection:
      return const _GoalTypeInfo(
        icon: Icons.payments_outlined,
        color: Color(0xFFC14F00),
        backgroundColor: Color(0xFFFFF4E8),
      );
  }
}

// ===========================================================
// Helpers
// ===========================================================

String _formatDate(String value) {
  if (value.isEmpty) {
    return '-';
  }

  try {
    final date = DateTime.parse(value);

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  } catch (_) {
    return value;
  }
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    final text = value.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 &&
          (text.length - i) % 3 == 0) {
        buffer.write(',');
      }

      buffer.write(text[i]);
    }

    return buffer.toString();
  }

  return value.toStringAsFixed(2);
}