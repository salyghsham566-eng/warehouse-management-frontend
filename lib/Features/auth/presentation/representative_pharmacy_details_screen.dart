import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_event.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_state.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

class RepresentativePharmacyDetailsScreen
    extends StatelessWidget {
  final String pharmacyId;

  const RepresentativePharmacyDetailsScreen({
    super.key,
    required this.pharmacyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        RepresentativePharmacyDetailsBloc>(
      create: (_) =>
          sl<RepresentativePharmacyDetailsBloc>()
            ..add(
              LoadRepresentativePharmacyDetailsEvent(
                pharmacyId: pharmacyId,
              ),
            ),
      child: _RepresentativePharmacyDetailsView(
        pharmacyId: pharmacyId,
      ),
    );
  }
}

class _RepresentativePharmacyDetailsView
    extends StatelessWidget {
  final String pharmacyId;

  const _RepresentativePharmacyDetailsView({
    required this.pharmacyId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تفاصيل الصيدلية',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocBuilder<
            RepresentativePharmacyDetailsBloc,
            RepresentativePharmacyDetailsState>(
          builder: (context, state) {
            if (state
                    is RepresentativePharmacyDetailsInitial ||
                state
                    is RepresentativePharmacyDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state
                is RepresentativePharmacyDetailsFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<
                          RepresentativePharmacyDetailsBloc>()
                      .add(
                        LoadRepresentativePharmacyDetailsEvent(
                          pharmacyId:
                              pharmacyId,
                        ),
                      );
                },
              );
            }

            if (state
                is RepresentativePharmacyDetailsSuccess) {
              return _DetailsContent(
                details: state.details,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final RepresentativePharmacyDetailsModel
      details;

  const _DetailsContent({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        28,
      ),
      children: [
        _PharmacyHeader(
          details: details,
        ),

        const SizedBox(height: 12),

        const _ReadOnlyNotice(),

        const SizedBox(height: 18),

        const _SectionTitle(
          title: 'بيانات التواصل والعنوان',
          icon: Icons.contact_phone_outlined,
        ),

        const SizedBox(height: 10),

        _InfoCard(
          children: [
            _InfoRow(
              icon:
                  Icons.location_on_outlined,
              label: 'المنطقة',
              value: details.region,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.home_work_outlined,
              label: 'العنوان',
              value: details.address,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.phone_outlined,
              label: 'الهاتف',
              value: details.phone,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.person_outline_rounded,
              label: 'جهة التواصل',
              value: details.contactPerson,
            ),
          ],
        ),

        const SizedBox(height: 18),

        const _SectionTitle(
          title: 'الحالة المالية المختصرة',
          icon:
              Icons.account_balance_wallet_outlined,
        ),

        const SizedBox(height: 10),

        _InfoCard(
          children: [
            _StatusRow(
              label: 'حالة الذمة',
              value: details.financialStatus,
              color: _financialStatusColor(
                details.financialStatus,
              ),
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.receipt_long_outlined,
              label: 'آخر فاتورة',
              value: details.lastInvoice,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.payments_outlined,
              label: 'آخر دفعة',
              value: details.lastPayment,
            ),
          ],
        ),

        const SizedBox(height: 18),

        const _SectionTitle(
          title: 'آخر التعاملات',
          icon: Icons.history_rounded,
        ),

        const SizedBox(height: 10),

        _InfoCard(
          children: [
            _InfoRow(
              icon:
                  Icons.shopping_bag_outlined,
              label: 'آخر بيع',
              value: details.lastSale,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.update_rounded,
              label: 'آخر زيارة / تحديث',
              value:
                  details.lastVisitOrUpdate,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.payments_outlined,
              label: 'آخر دفعة',
              value: details.lastPayment,
            ),
            const _InfoDivider(),
            _InfoRow(
              icon:
                  Icons.sticky_note_2_outlined,
              label: 'آخر ملاحظة',
              value: details.lastNote,
            ),
          ],
        ),
      ],
    );
  }

  static Color _financialStatusColor(
    String status,
  ) {
    final value =
        status.trim().toLowerCase();

    if (value.contains('مسدد') ||
        value.contains('مسددة') ||
        value.contains('paid') ||
        value.contains('clear')) {
      return AppColors.success;
    }

    if (value.contains('مدينة') ||
        value.contains('مدين') ||
        value.contains('debt') ||
        value.contains('due')) {
      return AppColors.danger;
    }

    if (value.contains('جزئي') ||
        value.contains('partial') ||
        value.contains('معلق')) {
      return AppColors.warning;
    }

    return AppColors.textSecondary;
  }
}

class _PharmacyHeader
    extends StatelessWidget {
  final RepresentativePharmacyDetailsModel
      details;

  const _PharmacyHeader({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  AppColors.primarySoft,
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.local_pharmacy_rounded,
              color: AppColors.primary,
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  details.name,
                  style: const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  details.region,
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      color: AppColors
                          .textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'آخر تعامل: ${details.lastInteraction}',
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyNotice
    extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'هذه التفاصيل للقراءة فقط. لا يمكن بدء طلب أو تسجيل تحصيل أو فتح كشف حساب كامل من شاشة الصيدليات.',
              style: TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          color: AppColors.primary,
          size: 21,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final visibleValue =
        value.trim().isEmpty
            ? 'غير محدد'
            : value;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors
                    .textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              visibleValue,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final visibleValue =
        value.trim().isEmpty
            ? 'غير محدد'
            : value;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors
                    .textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment:
                  Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  visibleValue,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider
    extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
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
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
