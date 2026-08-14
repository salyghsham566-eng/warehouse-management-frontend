import 'package:flutter/material.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

class CollectionPharmacyDetailsPage extends StatelessWidget {
  const CollectionPharmacyDetailsPage({
    required this.pharmacy,
    required this.onRecordPayment,
    required this.onOpenHistory,
    super.key,
  });

  final CollectionPharmacyModel pharmacy;
  final VoidCallback? onRecordPayment;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final _StatusStyle statusStyle = _getStatusStyle(pharmacy.accountStatus);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'بيانات الصيدلية',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PharmacyHeaderCard(pharmacy: pharmacy, statusStyle: statusStyle),

              const SizedBox(height: 16),

              _OfficialBalanceCard(balance: pharmacy.officialBalance),

              const SizedBox(height: 16),

              _InformationCard(
                title: 'معلومات الصيدلية',
                children: [
                  _InformationRow(
                    icon: Icons.location_on_outlined,
                    label: 'المنطقة',
                    value: pharmacy.area,
                  ),
                  const Divider(color: AppColors.border, height: 25),
                  _InformationRow(
                    icon: Icons.map_outlined,
                    label: 'العنوان',
                    value: pharmacy.address,
                  ),
                  if (pharmacy.phoneNumber != null &&
                      pharmacy.phoneNumber!.trim().isNotEmpty) ...[
                    const Divider(color: AppColors.border, height: 25),
                    _InformationRow(
                      icon: Icons.phone_outlined,
                      label: 'رقم الهاتف',
                      value: pharmacy.phoneNumber!,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              _LastPaymentCard(
                amount: pharmacy.lastPaymentAmount,
                date: pharmacy.lastPaymentDate,
              ),

              const SizedBox(height: 16),

              _PendingCollectionCard(
                hasPendingCollection: pharmacy.hasPendingCollection,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onRecordPayment,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('تسجيل دفعة'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: onOpenHistory,
                  icon: const Icon(Icons.history),
                  label: const Text('سجل تحصيلات هذه الصيدلية'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PharmacyHeaderCard extends StatelessWidget {
  const _PharmacyHeaderCard({
    required this.pharmacy,
    required this.statusStyle,
  });

  final CollectionPharmacyModel pharmacy;
  final _StatusStyle statusStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pharmacy.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  pharmacy.area,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: statusStyle.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusStyle.icon, color: statusStyle.color, size: 14),
                const SizedBox(width: 5),
                Text(
                  pharmacy.accountStatus.label,
                  style: TextStyle(
                    color: statusStyle.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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

class _OfficialBalanceCard extends StatelessWidget {
  const _OfficialBalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final bool hasBalance = balance > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasBalance ? AppColors.warning : AppColors.success,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: hasBalance ? AppColors.warningSoft : AppColors.successSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: hasBalance ? AppColors.warning : AppColors.success,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الرصيد الرسمي الحالي',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${_formatAmount(balance)} ر.س',
                  style: TextStyle(
                    color: hasBalance
                        ? AppColors.textPrimary
                        : AppColors.success,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: hasBalance ? AppColors.warningSoft : AppColors.successSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              hasBalance ? 'عليه رصيد' : 'مسدد',
              style: TextStyle(
                color: hasBalance ? AppColors.warning : AppColors.success,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 17),
          ...children,
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LastPaymentCard extends StatelessWidget {
  const _LastPaymentCard({required this.amount, required this.date});

  final double? amount;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final bool hasLastPayment = amount != null && date != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر دفعة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          if (!hasLastPayment)
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.textSecondary),
                SizedBox(width: 9),
                Text(
                  'لا توجد دفعات سابقة',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _PaymentValueItem(
                    icon: Icons.payments_outlined,
                    label: 'قيمة آخر دفعة',
                    value: '${_formatAmount(amount!)} ر.س',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentValueItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'تاريخ آخر دفعة',
                    value: _formatDate(date!),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PaymentValueItem extends StatelessWidget {
  const _PaymentValueItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingCollectionCard extends StatelessWidget {
  const _PendingCollectionCard({required this.hasPendingCollection});

  final bool hasPendingCollection;

  @override
  Widget build(BuildContext context) {
    final Color color = hasPendingCollection
        ? AppColors.warning
        : AppColors.success;

    final Color background = hasPendingCollection
        ? AppColors.warningSoft
        : AppColors.successSoft;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            hasPendingCollection
                ? Icons.hourglass_empty
                : Icons.check_circle_outline,
            color: color,
            size: 25,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPendingCollection
                      ? 'يوجد دفعة معلقة'
                      : 'لا توجد دفعات معلقة',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasPendingCollection
                      ? 'توجد دفعة بانتظار اعتماد المفوتر'
                      : 'يمكن تسجيل دفعة جديدة لهذه الصيدلية',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    height: 1.4,
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

_StatusStyle _getStatusStyle(PharmacyAccountStatus status) {
  switch (status) {
    case PharmacyAccountStatus.hasDebt:
      return const _StatusStyle(
        color: AppColors.danger,
        background: AppColors.dangerSoft,
        icon: Icons.account_balance_wallet_outlined,
      );

    case PharmacyAccountStatus.settled:
      return const _StatusStyle(
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.check_circle_outline,
      );

    case PharmacyAccountStatus.pendingCollection:
      return const _StatusStyle(
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.hourglass_empty,
      );
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

  final String day = localDate.day.toString().padLeft(2, '0');

  final String month = localDate.month.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year}';
}
