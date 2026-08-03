import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_event.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_state.dart';
import 'package:project_2/Features/auth/data/models/Collection_modle.dart';

class CollectionDashboardPage extends StatelessWidget {
  const CollectionDashboardPage({
    required this.onRecordPayment,
    required this.onOpenHistory,
    required this.onOpenPaymentDetails,
    super.key,
  });

  final VoidCallback onRecordPayment;
  final VoidCallback onOpenHistory;
  final ValueChanged<String> onOpenPaymentDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CollectionDashboardBloc, CollectionDashboardState>(
          builder: (context, state) {
            switch (state.loadStatus) {
              case CollectionLoadStatus.initial:
              case CollectionLoadStatus.loading:
                return const _LoadingView();

              case CollectionLoadStatus.failure:
                return _FailureView(
                  message: state.errorMessage ?? 'حدث خطأ غير متوقع',
                  onRetry: () {
                    context.read<CollectionDashboardBloc>().add(
                      const CollectionDashboardRequested(),
                    );
                  },
                );

              case CollectionLoadStatus.success:
                final dashboard = state.dashboard;

                if (dashboard == null) {
                  return _FailureView(
                    message: 'لا توجد بيانات متاحة',
                    onRetry: () {
                      context.read<CollectionDashboardBloc>().add(
                        const CollectionDashboardRequested(),
                      );
                    },
                  );
                }

                return _DashboardContent(
                  state: state,
                  dashboard: dashboard,
                  onRecordPayment: onRecordPayment,
                  onOpenHistory: onOpenHistory,
                  onOpenPaymentDetails: onOpenPaymentDetails,
                );
            }
          },
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.state,
    required this.dashboard,
    required this.onRecordPayment,
    required this.onOpenHistory,
    required this.onOpenPaymentDetails,
  });

  final CollectionDashboardState state;
  final CollectionDashboardModel dashboard;

  final VoidCallback onRecordPayment;
  final VoidCallback onOpenHistory;
  final ValueChanged<String> onOpenPaymentDetails;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final bloc = context.read<CollectionDashboardBloc>();

        bloc.add(const CollectionDashboardRequested());

        await bloc.stream.firstWhere(
          (state) =>
              state.loadStatus == CollectionLoadStatus.success ||
              state.loadStatus == CollectionLoadStatus.failure,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          const Text(
            'التحصيل',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'متابعة وتسجيل الدفعات النقدية اليومية',
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
            total: dashboard.totalToday,
            growthPercent: dashboard.growthPercent,
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _CollectionStatCard(
                  count: dashboard.approvedCount,
                  title: 'التحصيلات المعتمدة',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  softColor: AppColors.successSoft,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _CollectionStatCard(
                  count: dashboard.pendingCount,
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
                  count: dashboard.rejectedCount,
                  title: 'التحصيلات المرفوضة',
                  icon: Icons.cancel_outlined,
                  color: AppColors.danger,
                  softColor: AppColors.dangerSoft,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(child: SizedBox()),
            ],
          ),

          const SizedBox(height: 22),

          _SearchAndFilterSection(state: state),

          const SizedBox(height: 20),

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

          if (state.visibleCollections.isEmpty)
            const _EmptyView()
          else
            ...state.visibleCollections.map(
              (collection) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RecentCollectionTile(
                  item: collection,
                  onTap: () => onOpenPaymentDetails(collection.id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchAndFilterSection extends StatelessWidget {
  const _SearchAndFilterSection({required this.state});

  final CollectionDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              context.read<CollectionDashboardBloc>().add(
                CollectionSearchChanged(value),
              );
            },
            decoration: InputDecoration(
              hintText: 'ابحث باسم الصيدلية أو المنطقة',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: state.statusFilter == CollectionStatusFilter.all
              ? AppColors.surface
              : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              final selectedFilter = await _showFilterSheet(
                context,
                currentFilter: state.statusFilter,
              );

              if (!context.mounted || selectedFilter == null) {
                return;
              }

              context.read<CollectionDashboardBloc>().add(
                CollectionStatusFilterChanged(selectedFilter),
              );
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.tune, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

Future<CollectionStatusFilter?> _showFilterSheet(
  BuildContext context, {
  required CollectionStatusFilter currentFilter,
}) {
  return showModalBottomSheet<CollectionStatusFilter>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'فلترة التحصيلات',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...CollectionStatusFilter.values.map((filter) {
              final isSelected = filter == currentFilter;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  filter.label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop(filter);
                },
              );
            }),
          ],
        ),
      );
    },
  );
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
              icon: Icon(icon, size: 20),
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
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
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
    required this.growthPercent,
  });

  final double total;
  final double growthPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.success, width: 1.2),
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
          Row(
            children: [
              Expanded(
                child: Text.rich(
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '↑ ${growthPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
      constraints: const BoxConstraints(minHeight: 125),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.7)),
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
                child: Icon(icon, size: 18, color: color),
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
  const _RecentCollectionTile({required this.item, required this.onTap});

  final CollectionItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.status);

    final statusBackground = _getStatusBackground(item.status);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
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
                      '${item.areaName} • ${_formatDate(item.date)}',
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
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message, required this.onRetry});

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
            const Icon(Icons.error_outline, color: AppColors.danger, size: 55),
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
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('إعادة المحاولة'),
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
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, color: AppColors.textSecondary, size: 42),
          SizedBox(height: 10),
          Text(
            'لا توجد عمليات مطابقة للبحث أو الفلتر',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(CollectionPaymentStatus status) {
  switch (status) {
    case CollectionPaymentStatus.approved:
      return AppColors.success;

    case CollectionPaymentStatus.pending:
      return AppColors.warning;

    case CollectionPaymentStatus.rejected:
      return AppColors.danger;
  }
}

Color _getStatusBackground(CollectionPaymentStatus status) {
  switch (status) {
    case CollectionPaymentStatus.approved:
      return AppColors.successSoft;

    case CollectionPaymentStatus.pending:
      return AppColors.warningSoft;

    case CollectionPaymentStatus.rejected:
      return AppColors.dangerSoft;
  }
}

String _formatAmount(double amount) {
  final value = amount.toStringAsFixed(0);
  final result = StringBuffer();

  for (var index = 0; index < value.length; index++) {
    if (index > 0 && (value.length - index) % 3 == 0) {
      result.write(',');
    }

    result.write(value[index]);
  }

  return result.toString();
}

String _formatDate(DateTime date) {
  final localDate = date.toLocal();

  final day = localDate.day.toString().padLeft(2, '0');

  final month = localDate.month.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year}';
}
