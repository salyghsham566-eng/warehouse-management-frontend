import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_state.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_details_page.dart';

class CollectionPaymentsHistoryPage
    extends StatelessWidget {
  const CollectionPaymentsHistoryPage({
    super.key,
  });

  static const String allPharmaciesValue =
      '__all_pharmacies__';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'التحصيلات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<
            CollectionPaymentsHistoryBloc,
            CollectionPaymentsHistoryState>(
          builder: (context, state) {
            switch (state.status) {
              case CollectionPaymentsHistoryStatus.initial:
              case CollectionPaymentsHistoryStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );

              case CollectionPaymentsHistoryStatus.failure:
                return _FailureView(
                  message: state.errorMessage ??
                      'حدث خطأ غير متوقع',
                  onRetry: () {
                    context
                        .read<
                            CollectionPaymentsHistoryBloc>()
                        .add(
                          const CollectionPaymentsHistoryRequested(),
                        );
                  },
                );

              case CollectionPaymentsHistoryStatus.success:
                return _HistoryContent(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.state,
  });

  final CollectionPaymentsHistoryState state;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> pharmacies = {};

    for (final payment in state.allPayments) {
      pharmacies[payment.pharmacyId] =
          payment.pharmacyName;
    }

    final int pendingCount = state.allPayments
        .where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus
                  .pendingBillingApproval,
        )
        .length;

    final int approvedCount = state.allPayments
        .where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus.approved,
        )
        .length;

    final int rejectedCount = state.allPayments
        .where(
          (payment) =>
              payment.status ==
              CollectionApprovalStatus.rejected,
        )
        .length;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final bloc =
            context.read<CollectionPaymentsHistoryBloc>();

        bloc.add(
          const CollectionPaymentsHistoryRequested(),
        );

        await bloc.stream.firstWhere(
          (newState) =>
              newState.status !=
              CollectionPaymentsHistoryStatus.loading,
        );
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsetsDirectional.fromSTEB(
          20,
          10,
          20,
          30,
        ),
        children: [
          const Text(
            'متابعة حالات الدفعات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'يمكنك عرض جميع الدفعات أو دفعات صيدلية محددة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'بانتظار الاعتماد',
                  count: pendingCount,
                  color: AppColors.warning,
                  background:
                      AppColors.warningSoft,
                  icon: Icons.hourglass_empty,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  title: 'معتمدة',
                  count: approvedCount,
                  color: AppColors.success,
                  background:
                      AppColors.successSoft,
                  icon:
                      Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  title: 'مرفوضة',
                  count: rejectedCount,
                  color: AppColors.danger,
                  background:
                      AppColors.dangerSoft,
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'تصفية حسب الصيدلية',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.local_pharmacy_outlined,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 6,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          state.selectedPharmacyId ??
                              CollectionPaymentsHistoryPage
                                  .allPharmaciesValue,
                      isExpanded: true,
                      isDense: true,
                      items: [
                        const DropdownMenuItem<String>(
                          value:
                              CollectionPaymentsHistoryPage
                                  .allPharmaciesValue,
                          child: Text(
                            'جميع الدفعات',
                          ),
                        ),
                        ...pharmacies.entries.map(
                          (entry) =>
                              DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        final String? pharmacyId =
                            value ==
                                    CollectionPaymentsHistoryPage
                                        .allPharmaciesValue
                                ? null
                                : value;

                        context
                            .read<
                                CollectionPaymentsHistoryBloc>()
                            .add(
                              CollectionPaymentsPharmacyFilterChanged(
                                pharmacyId,
                              ),
                            );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الدفعات',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${state.visiblePayments.length} دفعة',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (state.visiblePayments.isEmpty)
            const _EmptyView()
          else
           ...state.visiblePayments.map(
  (payment) => Padding(
    padding: const EdgeInsets.only(
      bottom: 11,
    ),
    child: _PaymentCard(
      payment: payment,
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) =>
                CollectionPaymentDetailsPage(
              payment: payment,
            ),
          ),
        );
      },
    ),
  ),
),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.payment,
     required this.onTap,
  });

  final CollectionPaymentModel payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _StatusStyle statusStyle =
        _statusStyle(payment.status);

    return Material
    ( 
      color: AppColors.surface,
  borderRadius: BorderRadius.circular(17),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(17),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppColors.primary,
                  ),
                ),
      
                const SizedBox(width: 11),
      
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.pharmacyName,
                        style: const TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _formatDate(
                          payment.paymentDate,
                        ),
                        style: const TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
      
                Text(
                  '${_formatAmount(payment.amount)} ر.س',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 14),
      
            const Divider(
              height: 1,
              color: AppColors.border,
            ),
      
            const SizedBox(height: 13),
      
            Row(
              children: [
                Expanded(
                  child: _SmallInformation(
                    label: 'طريقة الدفع',
                    value: payment.paymentMethod.label,
                  ),
                ),
                Expanded(
                  child: _SmallInformation(
                    label: 'الرصيد المتوقع',
                    value:
                        '${_formatAmount(payment.expectedBalanceAfter)} ر.س',
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 13),
      
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: statusStyle.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    statusStyle.icon,
                    size: 16,
                    color: statusStyle.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    payment.status.label,
                    style: TextStyle(
                      color: statusStyle.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
      
            if (payment.status ==
                    CollectionApprovalStatus.rejected &&
                payment.rejectionReason != null &&
                payment.rejectionReason!
                    .trim()
                    .isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.dangerSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.danger
                        .withOpacity(0.35),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.danger,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سبب الرفض: '
                        '${payment.rejectionReason}',
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 11,
                          height: 1.5,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
    required this.background,
    required this.icon,
  });

  final String title;
  final int count;
  final Color color;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInformation extends StatelessWidget {
  const _SmallInformation({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
            size: 45,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'لا توجد دفعات لهذه الصيدلية',
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.danger,
            size: 50,
          ),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 15),
          FilledButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });

  final Color color;
  final Color background;
  final IconData icon;
}

_StatusStyle _statusStyle(
  CollectionApprovalStatus status,
) {
  switch (status) {
    case CollectionApprovalStatus
          .pendingBillingApproval:
      return const _StatusStyle(
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.hourglass_empty,
      );

    case CollectionApprovalStatus.approved:
      return const _StatusStyle(
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.check_circle_outline,
      );

    case CollectionApprovalStatus.rejected:
      return const _StatusStyle(
        color: AppColors.danger,
        background: AppColors.dangerSoft,
        icon: Icons.cancel_outlined,
      );
  }
}

String _formatDate(DateTime date) {
  final DateTime localDate = date.toLocal();

  final String day =
      localDate.day.toString().padLeft(2, '0');

  final String month =
      localDate.month.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year}';
}

String _formatAmount(double amount) {
  final String value = amount.toStringAsFixed(0);
  final StringBuffer result = StringBuffer();

  for (int index = 0; index < value.length; index++) {
    if (index > 0 &&
        (value.length - index) % 3 == 0) {
      result.write(',');
    }

    result.write(value[index]);
  }

  return result.toString();
}