import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_filter.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_state.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_details_page.dart';

class CollectionPaymentsHistoryPage
    extends StatelessWidget {
  const CollectionPaymentsHistoryPage({
    this.pharmacyId,
    this.pharmacyName,
    super.key,
  });

  final String? pharmacyId;
  final String? pharmacyName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        CollectionPaymentsHistoryBloc>(
      create: (_) =>
          sl<CollectionPaymentsHistoryBloc>()
            ..add(
              const CollectionPaymentsHistoryRequested(),
            ),
      child: _CollectionPaymentsHistoryView(
        pharmacyId: pharmacyId,
        pharmacyName: pharmacyName,
      ),
    );
  }
}

class _CollectionPaymentsHistoryView
    extends StatelessWidget {
  const _CollectionPaymentsHistoryView({
    required this.pharmacyId,
    required this.pharmacyName,
  });

  final String? pharmacyId;
  final String? pharmacyName;

  @override
  Widget build(BuildContext context) {
    final String normalizedPharmacyName =
        pharmacyName?.trim() ?? '';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            normalizedPharmacyName.isEmpty
                ? 'التحصيلات'
                : 'تحصيلات $normalizedPharmacyName',
            style: const TextStyle(
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
              if (state.status ==
                      CollectionPaymentsHistoryStatus
                          .initial ||
                  state.status ==
                      CollectionPaymentsHistoryStatus
                          .loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state.status ==
                  CollectionPaymentsHistoryStatus
                      .failure) {
                return _FailureView(
                  message: state.errorMessage ??
                      'حدث خطأ أثناء تحميل التحصيلات',
                  onRetry: () {
                    context
                        .read<
                            CollectionPaymentsHistoryBloc>()
                        .add(
                          const CollectionPaymentsHistoryRequested(),
                        );
                  },
                );
              }

              return _HistoryContent(
                state: state,
                pharmacyId: pharmacyId,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.state,
    required this.pharmacyId,
  });

  final CollectionPaymentsHistoryState state;
  final String? pharmacyId;

  @override
  Widget build(BuildContext context) {
    final String selectedPharmacyId =
        pharmacyId?.trim() ?? '';

    final List<CollectionPaymentModel> payments =
        selectedPharmacyId.isEmpty
            ? state.visiblePayments
            : state.visiblePayments
                .where(
                  (payment) =>
                      payment.pharmacyId.trim() ==
                      selectedPharmacyId,
                )
                .toList(growable: false);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final bloc =
            context.read<CollectionPaymentsHistoryBloc>();

        final nextState = bloc.stream.firstWhere(
          (newState) =>
              newState.status ==
                  CollectionPaymentsHistoryStatus
                      .success ||
              newState.status ==
                  CollectionPaymentsHistoryStatus
                      .failure,
        );

        bloc.add(
          const CollectionPaymentsHistoryRefreshed(),
        );

        await nextState;
      },
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(
                14,
                8,
                14,
                0,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _SearchField(
                    onChanged: (value) {
                      context
                          .read<
                              CollectionPaymentsHistoryBloc>()
                          .add(
                            CollectionPaymentsHistorySearchChanged(
                              value,
                            ),
                          );
                    },
                  ),

                  const SizedBox(height: 14),

                  _FilterChips(
                    selectedFilter:
                        state.selectedFilter,
                    onSelected: (filter) {
                      context
                          .read<
                              CollectionPaymentsHistoryBloc>()
                          .add(
                            CollectionPaymentsHistoryFilterChanged(
                              filter,
                            ),
                          );
                    },
                  ),

                  const SizedBox(height: 23),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'الدفعات',
                          style: TextStyle(
                            color:
                                AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '${payments.length} دفعة',
                        style: const TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          if (payments.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyView(
                hasSearch:
                    state.searchText.isNotEmpty,
                selectedFilter:
                    state.selectedFilter,
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(
                14,
                0,
                14,
                30,
              ),
              sliver: SliverList.separated(
                itemCount: payments.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  final CollectionPaymentModel payment =
                      payments[index];

                  return _PaymentCard(
                    payment: payment,
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) {
                            return CollectionPaymentDetailsPage(
                              paymentId: payment.id,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText:
            'ابحث عن الصيدلية أو رقم الدفعة...',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.primary,
          size: 25,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedFilter,
    required this.onSelected,
  });

  final CollectionPaymentsHistoryFilter
      selectedFilter;

  final ValueChanged<
          CollectionPaymentsHistoryFilter>
      onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount:
            CollectionPaymentsHistoryFilter
                .values.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter =
              CollectionPaymentsHistoryFilter
                  .values[index];

          final bool isSelected =
              selectedFilter == filter;

          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              onSelected(filter);
            },
            label: Text(filter.label),
            labelPadding:
                const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            padding: EdgeInsets.zero,
            backgroundColor:
                AppColors.primarySoft,
            selectedColor: AppColors.primary,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          );
        },
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
    final _PaymentStatusStyle statusStyle =
        _getPaymentStatusStyle(
      payment.status,
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(17),
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
                    width: 45,
                    height: 45,
                    decoration:
                        const BoxDecoration(
                      color:
                          AppColors.primarySoft,
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
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: AppColors
                                .textPrimary,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'رقم الدفعة: ${payment.id}',
                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

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
                      label: 'تاريخ الدفعة',
                      value: _formatDate(
                        payment.paymentDate,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _SmallInformation(
                      label: 'طريقة الدفع',
                      value:
                          payment.paymentMethod.label,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusStyle.background,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusStyle.icon,
                      color: statusStyle.color,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      payment.status.label,
                      style: TextStyle(
                        color: statusStyle.color,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              if (payment.status ==
                      CollectionApprovalStatus
                          .rejected &&
                  payment.rejectionReason
                          ?.trim()
                          .isNotEmpty ==
                      true) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.dangerSoft,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallInformation
    extends StatelessWidget {
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
  const _EmptyView({
    required this.hasSearch,
    required this.selectedFilter,
  });

  final bool hasSearch;

  final CollectionPaymentsHistoryFilter
      selectedFilter;

  @override
  Widget build(BuildContext context) {
    String message = 'لا توجد دفعات';

    if (hasSearch) {
      message =
          'لا توجد نتائج مطابقة للبحث';
    } else if (selectedFilter !=
        CollectionPaymentsHistoryFilter.all) {
      message =
          'لا توجد دفعات ضمن هذا التصنيف';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 50,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label:
                  const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusStyle {
  const _PaymentStatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });

  final Color color;
  final Color background;
  final IconData icon;
}

_PaymentStatusStyle _getPaymentStatusStyle(
  CollectionApprovalStatus status,
) {
  switch (status) {
    case CollectionApprovalStatus
          .pendingBillingApproval:
      return const _PaymentStatusStyle(
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.hourglass_empty,
      );

    case CollectionApprovalStatus.approved:
      return const _PaymentStatusStyle(
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.check_circle_outline,
      );

    case CollectionApprovalStatus.rejected:
      return const _PaymentStatusStyle(
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
  final bool hasDecimals =
      amount != amount.roundToDouble();

  final String value = amount.toStringAsFixed(
    hasDecimals ? 2 : 0,
  );

  final List<String> parts = value.split('.');
  final String integerPart = parts.first;

  final StringBuffer result = StringBuffer();

  for (
    int index = 0;
    index < integerPart.length;
    index++
  ) {
    if (index > 0 &&
        (integerPart.length - index) % 3 == 0) {
      result.write(',');
    }

    result.write(integerPart[index]);
  }

  if (parts.length > 1) {
    result
      ..write('.')
      ..write(parts[1]);
  }

  return result.toString();
}