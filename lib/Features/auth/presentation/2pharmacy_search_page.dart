import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_bloc.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_event.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_state.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

class PharmacySearchPage extends StatelessWidget {
  const PharmacySearchPage({
    required this.onPharmacySelected,
    super.key,
  });

  final ValueChanged<CollectionPharmacyModel>
      onPharmacySelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'اختيار صيدلية',
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
            PharmacySearchBloc,
            PharmacySearchState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ابحث عن الصيدلية',
                        style: TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'تظهر فقط الصيدليات التي عليها ذمم',
                        style: TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SearchField(
                        onChanged: (query) {
                          context
                              .read<
                                  PharmacySearchBloc>()
                              .add(
                                PharmacySearchQueryChanged(
                                  query,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(
                    context,
                    state,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PharmacySearchState state,
  ) {
    switch (state.status) {
      case PharmacySearchStatus.initial:
      case PharmacySearchStatus.loading:
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );

      case PharmacySearchStatus.failure:
        return _ErrorView(
          message: state.errorMessage ??
              'حدث خطأ غير متوقع',
          onRetry: () {
            context
                .read<PharmacySearchBloc>()
                .add(
                  const PharmacySearchRequested(),
                );
          },
        );

      case PharmacySearchStatus.success:
        final List<CollectionPharmacyModel>
            debtPharmacies = state.visiblePharmacies
                .where(_canRegisterPayment)
                .toList(growable: false);

        if (debtPharmacies.isEmpty) {
          return _EmptyView(
            hasSearchQuery:
                state.query.trim().isNotEmpty,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final PharmacySearchBloc bloc =
                context.read<PharmacySearchBloc>();

            bloc.add(
              const PharmacySearchRequested(),
            );

            await bloc.stream.firstWhere(
              (newState) =>
                  newState.status ==
                      PharmacySearchStatus.success ||
                  newState.status ==
                      PharmacySearchStatus.failure,
            );
          },
          child: ListView.separated(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              30,
            ),
            itemCount: debtPharmacies.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 11),
            itemBuilder: (context, index) {
              final CollectionPharmacyModel pharmacy =
                  debtPharmacies[index];

              return _PharmacyCard(
                pharmacy: pharmacy,
                onTap: () {
                  onPharmacySelected(pharmacy);
                },
              );
            },
          ),
        );
    }
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
      textInputAction: TextInputAction.search,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        hintText: 'ابحث بالاسم أو المنطقة أو العنوان',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({
    required this.pharmacy,
    required this.onTap,
  });

  final CollectionPharmacyModel pharmacy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _PharmacyStatusStyle statusStyle =
        _getStatusStyle(
      pharmacy.accountStatus,
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(16),
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
                    width: 46,
                    height: 46,
                    decoration:
                        const BoxDecoration(
                      color:
                          AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_pharmacy_outlined,
                      color: AppColors.primary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:
                                AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pharmacy.area,
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_back_ios_new,
                    color:
                        AppColors.textSecondary,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color:
                        AppColors.textSecondary,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pharmacy.address,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              const Divider(
                height: 1,
                color: AppColors.border,
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الرصيد الرسمي الحالي',
                          style: TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatAmount(pharmacy.officialBalance)} ر.س',
                          style: const TextStyle(
                            color:
                                AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          statusStyle.background,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          statusStyle.icon,
                          color:
                              statusStyle.color,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          pharmacy
                              .accountStatus.label,
                          style: TextStyle(
                            color:
                                statusStyle.color,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
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

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.hasSearchQuery,
  });

  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_pharmacy_outlined,
              color: AppColors.textSecondary,
              size: 55,
            ),
            const SizedBox(height: 14),
            Text(
              hasSearchQuery
                  ? 'لا توجد صيدلية عليها ذمة مطابقة للبحث'
                  : 'لا توجد صيدليات عليها ذمم حالياً',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
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
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
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

class _PharmacyStatusStyle {
  const _PharmacyStatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });

  final Color color;
  final Color background;
  final IconData icon;
}

_PharmacyStatusStyle _getStatusStyle(
  PharmacyAccountStatus status,
) {
  switch (status) {
    case PharmacyAccountStatus.hasDebt:
      return const _PharmacyStatusStyle(
        color: AppColors.danger,
        background: AppColors.dangerSoft,
        icon:
            Icons.account_balance_wallet_outlined,
      );

    case PharmacyAccountStatus.settled:
      return const _PharmacyStatusStyle(
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.check_circle_outline,
      );

    case PharmacyAccountStatus.pendingCollection:
      return const _PharmacyStatusStyle(
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.hourglass_empty,
      );
  }
}

/// تسمح بعرض الصيدلية فقط عندما تكون عليها ذمة فعلية.
///
/// الصيدلية المسددة أو التي حالتها دفعة معلقة لن تظهر،
/// حتى لو كانت موجودة ضمن القائمة القادمة من الـBloc.
bool _canRegisterPayment(
  CollectionPharmacyModel pharmacy,
) {
  return pharmacy.accountStatus ==
          PharmacyAccountStatus.hasDebt &&
      pharmacy.officialBalance > 0;
}

String _formatAmount(double amount) {
  final bool isNegative = amount < 0;
  final double absoluteAmount = amount.abs();

  final bool hasDecimals =
      absoluteAmount !=
          absoluteAmount.roundToDouble();

  final String value =
      absoluteAmount.toStringAsFixed(
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

  return isNegative
      ? '-${result.toString()}'
      : result.toString();
}