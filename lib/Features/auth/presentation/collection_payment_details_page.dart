import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

class CollectionPaymentDetailsPage extends StatelessWidget {
  const CollectionPaymentDetailsPage({
    required this.payment,
    super.key,
  });

  final CollectionPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final _PaymentStatusStyle statusStyle =
        _getStatusStyle(payment.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'تفاصيل دفعة التحصيل',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            20,
            12,
            20,
            30,
          ),
          children: [
            _PaymentHeaderCard(
              payment: payment,
              statusStyle: statusStyle,
            ),

            const SizedBox(height: 15),

            _InformationCard(
              title: 'بيانات الدفعة',
              children: [
                _InformationRow(
                  icon: Icons.local_pharmacy_outlined,
                  label: 'الصيدلية',
                  value: payment.pharmacyName,
                ),
                const _CardDivider(),
                _InformationRow(
                  icon: Icons.payments_outlined,
                  label: 'المبلغ',
                  value:
                      '${_formatAmount(payment.amount)} ر.س',
                ),
                const _CardDivider(),
                _InformationRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'تاريخ الدفعة',
                  value: _formatDate(payment.paymentDate),
                ),
                const _CardDivider(),
                _InformationRow(
                  icon: Icons.credit_card_outlined,
                  label: 'طريقة الدفع',
                  value: payment.paymentMethod.label,
                ),
                const _CardDivider(),
                _InformationRow(
                  icon: statusStyle.icon,
                  label: 'الحالة',
                  value: payment.status.label,
                  valueColor: statusStyle.color,
                ),
              ],
            ),

            const SizedBox(height: 15),

            _ReceiptCard(
              receiptImagePath: payment.receiptImagePath,
            ),

            const SizedBox(height: 15),

            _TextDetailsCard(
              title: 'الملاحظات',
              icon: Icons.notes_outlined,
              text: _nullableText(
                payment.notes,
                emptyValue: 'لا توجد ملاحظات',
              ),
            ),

            if (payment.status ==
                CollectionApprovalStatus.rejected) ...[
              const SizedBox(height: 15),
              _RejectionReasonCard(
                rejectionReason: _nullableText(
                  payment.rejectionReason,
                  emptyValue: 'لم يتم تحديد سبب الرفض',
                ),
              ),
            ],

            const SizedBox(height: 15),

            _AccountingNotice(
              status: payment.status,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentHeaderCard extends StatelessWidget {
  const _PaymentHeaderCard({
    required this.payment,
    required this.statusStyle,
  });

  final CollectionPaymentModel payment;
  final _PaymentStatusStyle statusStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.primary,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.pharmacyName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'رقم الدفعة: ${payment.id}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatAmount(payment.amount)} ر.س',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
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
                      color: statusStyle.color,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      payment.status.label,
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
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.border,
        ),
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
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 19,
          ),
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
                style: TextStyle(
                  color:
                      valueColor ?? AppColors.textPrimary,
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

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.border,
      height: 25,
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({
    required this.receiptImagePath,
  });

  final String? receiptImagePath;

  @override
  Widget build(BuildContext context) {
    final String? path = receiptImagePath?.trim();

    final bool hasReceipt =
        path != null && path.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'صورة الوصل',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 15),

          if (!hasReceipt)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                    size: 42,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'لا توجد صورة وصل مرفقة',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: GestureDetector(
                onTap: () {
                  _openReceiptPreview(
                    context,
                    path,
                  );
                },
                child: _ReceiptImage(
                  imagePath: path,
                  height: 210,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReceiptImage extends StatelessWidget {
  const _ReceiptImage({
    required this.imagePath,
    required this.height,
  });

  final String imagePath;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _ImageErrorView(height: height);
        },
      );
    }

    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _ImageErrorView(height: height);
      },
    );
  }
}

class _ImageErrorView extends StatelessWidget {
  const _ImageErrorView({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.background,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppColors.textSecondary,
            size: 42,
          ),
          SizedBox(height: 9),
          Text(
            'تعذر عرض صورة الوصل',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextDetailsCard extends StatelessWidget {
  const _TextDetailsCard({
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _RejectionReasonCard extends StatelessWidget {
  const _RejectionReasonCard({
    required this.rejectionReason,
  });

  final String rejectionReason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.danger,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.cancel_outlined,
            color: AppColors.danger,
            size: 24,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'سبب الرفض',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rejectionReason,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 12,
                    height: 1.6,
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

class _AccountingNotice extends StatelessWidget {
  const _AccountingNotice({
    required this.status,
  });

  final CollectionApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final Color background;
    late final IconData icon;
    late final String message;

    switch (status) {
      case CollectionApprovalStatus
            .pendingBillingApproval:
        color = AppColors.warning;
        background = AppColors.warningSoft;
        icon = Icons.info_outline;
        message =
            'هذه الدفعة بانتظار اعتماد المفوتر، لذلك لم تؤثر على الرصيد الرسمي بعد.';

      case CollectionApprovalStatus.approved:
        color = AppColors.success;
        background = AppColors.successSoft;
        icon = Icons.check_circle_outline;
        message =
            'تم اعتماد هذه الدفعة وأصبحت معتمدة محاسبياً.';

      case CollectionApprovalStatus.rejected:
        color = AppColors.danger;
        background = AppColors.dangerSoft;
        icon = Icons.cancel_outlined;
        message =
            'تم رفض هذه الدفعة ولم تؤثر على الرصيد الرسمي.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 11,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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

_PaymentStatusStyle _getStatusStyle(
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

void _openReceiptPreview(
  BuildContext context,
  String imagePath,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _ReceiptImage(
                  imagePath: imagePath,
                  height:
                      MediaQuery.sizeOf(context).height *
                          0.7,
                ),
              ),
            ),
            PositionedDirectional(
              top: 8,
              end: 8,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String _nullableText(
  String? value, {
  required String emptyValue,
}) {
  final String normalized = value?.trim() ?? '';

  return normalized.isEmpty ? emptyValue : normalized;
}

String _formatDate(DateTime date) {
  final DateTime localDate = date.toLocal();

  final String day =
      localDate.day.toString().padLeft(2, '0');

  final String month =
      localDate.month.toString().padLeft(2, '0');

  final String hour =
      localDate.hour.toString().padLeft(2, '0');

  final String minute =
      localDate.minute.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year} - $hour:$minute';
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