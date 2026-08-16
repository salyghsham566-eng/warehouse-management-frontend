import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_state.dart';

import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

import 'package:project_2/Features/auth/presentation/collection_payment_details_page.dart';

class CollectionDashboardPage extends StatelessWidget {
  const CollectionDashboardPage({
    required this.onRecordPayment,
    required this.onOpenHistory,
    super.key,
  });

  final Future<void> Function() onRecordPayment;
  final Future<void> Function() onOpenHistory;

  Future<void> _openPageAndReload(
    BuildContext context,
    Future<void> Function() openPage,
  ) async {
    await openPage();

    if (!context.mounted) {
      return;
    }

    context.read<CollectionPaymentsHistoryBloc>().add(
          const CollectionPaymentsHistoryRequested(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionPaymentsHistoryBloc>(
      create: (_) => sl<CollectionPaymentsHistoryBloc>()
        ..add(
          const CollectionPaymentsHistoryRequested(),
        ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<
                CollectionPaymentsHistoryBloc,
                CollectionPaymentsHistoryState>(
              builder: (context, state) {
                switch (state.status) {
                  case CollectionPaymentsHistoryStatus.initial:
                  case CollectionPaymentsHistoryStatus.loading:
                    return const _LoadingView();

                  case CollectionPaymentsHistoryStatus.failure:
                    return _FailureView(
                      message:
                          state.errorMessage ?? 'حدث خطأ أثناء تحميل التحصيلات',
                      onRetry: () {
                        context.read<CollectionPaymentsHistoryBloc>().add(
                              const CollectionPaymentsHistoryRequested(),
                            );
                      },
                    );

                  case CollectionPaymentsHistoryStatus.success:
                    final List<CollectionPaymentModel> allPayments =
                        List<CollectionPaymentModel>.from(
                      state.allPayments,
                    )..sort(
                            (first, second) => second.paymentDate.compareTo(
                              first.paymentDate,
                            ),
                          );

                    // أحدث خمس عمليات فقط.
                    final List<CollectionPaymentModel> recentPayments =
                        allPayments.take(5).toList(growable: false);

                    final int approvedCount = allPayments
                        .where(
                          (payment) =>
                              payment.status ==
                              CollectionApprovalStatus.approved,
                        )
                        .length;

                    final int pendingCount = allPayments
                        .where(
                          (payment) =>
                              payment.status ==
                              CollectionApprovalStatus
                                  .pendingBillingApproval,
                        )
                        .length;

                    final int rejectedCount = allPayments
                        .where(
                          (payment) =>
                              payment.status ==
                              CollectionApprovalStatus.rejected,
                        )
                        .length;

                    final DateTime today = DateTime.now();

                    final double totalToday = allPayments
                        .where(
                          (payment) =>
                              DateUtils.isSameDay(
                                payment.paymentDate,
                                today,
                              ) &&
                              payment.status !=
                                  CollectionApprovalStatus.rejected,
                        )
                        .fold<double>(
                          0,
                          (total, payment) => total + payment.amount,
                        );

                    return _DashboardContent(
                      totalToday: totalToday,
                      approvedCount: approvedCount,
                      pendingCount: pendingCount,
                      rejectedCount: rejectedCount,
                      recentPayments: recentPayments,
                      onRecordPayment: () {
                        _openPageAndReload(
                          context,
                          onRecordPayment,
                        );
                      },
                      onOpenHistory: () {
                        _openPageAndReload(
                          context,
                          onOpenHistory,
                        );
                      },
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.totalToday,
    required this.approvedCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.recentPayments,
    required this.onRecordPayment,
    required this.onOpenHistory,
  });

  final double totalToday;

  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;

  final List<CollectionPaymentModel> recentPayments;

  final VoidCallback onRecordPayment;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final CollectionPaymentsHistoryBloc bloc =
            context.read<CollectionPaymentsHistoryBloc>();

        bloc.add(
          const CollectionPaymentsHistoryRequested(),
        );

        await bloc.stream.firstWhere(
          (newState) =>
              newState.status != CollectionPaymentsHistoryStatus.loading,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        children: [
          const Text(
            'التحصيل',
             textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'متابعة وتسجيل الدفعات النقدية اليومية',
             textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          _MainButton(
            label: 'تسجيل دفعة جديدة',
            icon: Icons.add_circle_outline,
            filled: true,
            onPressed: onRecordPayment,
          ),

          const SizedBox(height: 11),

          _MainButton(
            label: 'سجل التحصيلات',
            icon: Icons.history,
            filled: false,
            onPressed: onOpenHistory,
          ),

          const SizedBox(height: 22),

          _TotalCollectionCard(
            total: totalToday,
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _CollectionStatCard(
                  count: approvedCount,
                  title: 'التحصيلات المعتمدة',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  softColor: AppColors.successSoft,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _CollectionStatCard(
                  count: pendingCount,
                  title: 'بانتظار الاعتماد',
                  icon: Icons.hourglass_empty,
                  color: AppColors.warning,
                  softColor: AppColors.warningSoft,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              Expanded(
                child: _CollectionStatCard(
                  count: rejectedCount,
                  title: 'التحصيلات المرفوضة',
                  icon: Icons.cancel_outlined,
                  color: AppColors.danger,
                  softColor: AppColors.dangerSoft,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'العمليات الأخيرة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: onOpenHistory,
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          if (recentPayments.isEmpty)
            const _EmptyView()
          else
            ...recentPayments.map(
              (payment) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _RecentCollectionTile(
                    item: payment,
                    onTap: () {
                     /* Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) {
                            return CollectionPaymentFormPage(
                             initialPayment: payment,
                            );
                          },
                        ),
                      );*/
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  const _MainButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 51,
      child: filled
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 20,
              ),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 20,
              ),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}

class _TotalCollectionCard extends StatelessWidget {
  const _TotalCollectionCard({
    required this.total,
  });

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.success,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجمالي تحصيلات اليوم',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 11),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _formatAmount(total),
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 27,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ' ر.س',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

class _CollectionStatCard extends StatelessWidget {
  const _CollectionStatCard({
    required this.count,
    required this.title,
    required this.icon,
    required this.color,
    required this.softColor,
  });

  final int count;
  final String title;
  final IconData icon;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 125,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: softColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentCollectionTile extends StatelessWidget {
  const _RecentCollectionTile({
    required this.item,
    required this.onTap,
  });

  final CollectionPaymentModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(
      item.status,
    );

    final Color statusBackground = _getStatusBackground(
      item.status,
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.pharmacyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${item.paymentMethod.label} • '
                      '${_formatDate(item.paymentDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatAmount(item.amount)} ر.س',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.status.label,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.danger,
              size: 55,
            ),

            const SizedBox(height: 14),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 18),

            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: AppColors.textSecondary,
            size: 42,
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد عمليات تحصيل حتى الآن',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(
  CollectionApprovalStatus status,
) {
  switch (status) {
    case CollectionApprovalStatus.approved:
      return AppColors.success;

    case CollectionApprovalStatus.pendingBillingApproval:
      return AppColors.warning;

    case CollectionApprovalStatus.rejected:
      return AppColors.danger;
  }
}

Color _getStatusBackground(
  CollectionApprovalStatus status,
) {
  switch (status) {
    case CollectionApprovalStatus.approved:
      return AppColors.successSoft;

    case CollectionApprovalStatus.pendingBillingApproval:
      return AppColors.warningSoft;

    case CollectionApprovalStatus.rejected:
      return AppColors.dangerSoft;
  }
}

String _formatAmount(double amount) {
  final String value = amount.toStringAsFixed(0);
  final StringBuffer result = StringBuffer();

  for (int index = 0; index < value.length; index++) {
    if (index > 0 && (value.length - index) % 3 == 0) {
      result.write(',');
    }

    result.write(value[index]);
  }

  return result.toString();
}

String _formatDate(DateTime date) {
  final DateTime localDate = date.toLocal();

  final String day = localDate.day.toString().padLeft(
        2,
        '0',
      );

  final String month = localDate.month.toString().padLeft(
        2,
        '0',
      );

  return '$day/$month/${localDate.year}';
}