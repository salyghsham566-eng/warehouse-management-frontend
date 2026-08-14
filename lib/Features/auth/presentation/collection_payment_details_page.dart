import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentDetailsPage extends StatefulWidget {
  const CollectionPaymentDetailsPage({
    required this.paymentId,
    super.key,
  });

  final String paymentId;

  @override
  State<CollectionPaymentDetailsPage> createState() =>
      _CollectionPaymentDetailsPageState();
}

class _CollectionPaymentDetailsPageState
    extends State<CollectionPaymentDetailsPage> {
  late Future<CollectionPaymentModel> _paymentFuture;

  @override
  void initState() {
    super.initState();
    _loadPayment();
  }

  void _loadPayment() {
    final String normalizedPaymentId = widget.paymentId.trim();

    if (normalizedPaymentId.isEmpty) {
      _paymentFuture = Future<CollectionPaymentModel>.error(
        Exception('رقم الدفعة غير صالح'),
      );
      return;
    }

    _paymentFuture = sl<CollectionPaymentRepository>()
        .getCollectionPaymentDetails(normalizedPaymentId);
  }

  void _retry() {
    setState(_loadPayment);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
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
          child: FutureBuilder<CollectionPaymentModel>(
            future: _paymentFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                final String message = snapshot.error
                    .toString()
                    .replaceFirst('Exception: ', '')
                    .trim();

                return _PaymentDetailsError(
                  message: message.isEmpty
                      ? 'تعذر تحميل تفاصيل الدفعة'
                      : message,
                  onRetry: _retry,
                );
              }

              final CollectionPaymentModel? payment = snapshot.data;

              if (payment == null) {
                return _PaymentDetailsError(
                  message: 'لم يتم العثور على بيانات الدفعة',
                  onRetry: _retry,
                );
              }

              return _PaymentDetailsContent(payment: payment);
            },
          ),
        ),
      ),
    );
  }
}

class _PaymentDetailsContent extends StatelessWidget {
  const _PaymentDetailsContent({
    required this.payment,
  });

  final CollectionPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final _PaymentDetailsStatusStyle statusStyle =
        _paymentDetailsStatusStyle(payment.status);

    final String notes = payment.notes?.trim() ?? '';
    final String receiptPath = payment.receiptImagePath?.trim() ?? '';
    final String rejectionReason = payment.rejectionReason?.trim() ?? '';

    final bool hasRejectionReason =
        payment.status == CollectionApprovalStatus.rejected &&
            rejectionReason.isNotEmpty;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        16,
        12,
        16,
        30,
      ),
      children: [
        _PaymentDetailsHeader(payment: payment),
        const SizedBox(height: 14),
        _PaymentDetailsSection(
          title: 'بيانات الدفعة',
          child: Column(
            children: [
              _PaymentDetailsRow(
                icon: Icons.local_pharmacy_outlined,
                label: 'الصيدلية',
                value: payment.pharmacyName,
              ),
              const Divider(
                height: 25,
                color: AppColors.border,
              ),
              _PaymentDetailsRow(
                icon: Icons.payments_outlined,
                label: 'المبلغ',
                value: '${_formatAmount(payment.amount)} ر.س',
              ),
              const Divider(
                height: 25,
                color: AppColors.border,
              ),
              _PaymentDetailsRow(
                icon: Icons.calendar_month_outlined,
                label: 'تاريخ الدفعة',
                value: _formatDate(payment.paymentDate),
              ),
              const Divider(
                height: 25,
                color: AppColors.border,
              ),
              _PaymentDetailsRow(
                icon: Icons.credit_card_outlined,
                label: 'طريقة الدفع',
                value: payment.paymentMethod.label,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _PaymentDetailsSection(
          title: 'حالة الدفعة',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: statusStyle.background,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: statusStyle.color),
            ),
            child: Row(
              children: [
                Icon(
                  statusStyle.icon,
                  color: statusStyle.color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    payment.status.label,
                    style: TextStyle(
                      color: statusStyle.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _PaymentDetailsSection(
          title: 'صورة الوصل',
          child: receiptPath.isEmpty
              ? const _PaymentDetailsEmptyValue(
                  icon: Icons.receipt_long_outlined,
                  text: 'لم تتم إضافة صورة وصل',
                )
              : _PaymentReceiptPreview(
                  imagePath: receiptPath,
                ),
        ),
        const SizedBox(height: 14),
        _PaymentDetailsSection(
          title: 'الملاحظات',
          child: notes.isEmpty
              ? const _PaymentDetailsEmptyValue(
                  icon: Icons.notes_outlined,
                  text: 'لا توجد ملاحظات',
                )
              : Text(
                  notes,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
        ),
        if (hasRejectionReason) ...[
          const SizedBox(height: 14),
          _PaymentDetailsSection(
            title: 'سبب الرفض',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.dangerSoft,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.danger),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rejectionReason,
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 12,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PaymentDetailsHeader extends StatelessWidget {
  const _PaymentDetailsHeader({
    required this.payment,
  });

  final CollectionPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 51,
            height: 51,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: AppColors.primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.pharmacyName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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
          const SizedBox(width: 8),
          Text(
            '${_formatAmount(payment.amount)} ر.س',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailsSection extends StatelessWidget {
  const _PaymentDetailsSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
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
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _PaymentDetailsRow extends StatelessWidget {
  const _PaymentDetailsRow({
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
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
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

class _PaymentReceiptPreview extends StatelessWidget {
  const _PaymentReceiptPreview({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final Uri? uri = Uri.tryParse(imagePath);

    final bool isNetworkImage = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    final Widget image;

    if (isNetworkImage) {
      image = Image.network(
        imagePath,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const _PaymentDetailsEmptyValue(
            icon: Icons.broken_image_outlined,
            text: 'تعذر عرض صورة الوصل',
          );
        },
      );
    } else {
      final File receiptFile = File(imagePath);

      image = receiptFile.existsSync()
          ? Image.file(
              receiptFile,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            )
          : const _PaymentDetailsEmptyValue(
              icon: Icons.broken_image_outlined,
              text: 'صورة الوصل غير موجودة',
            );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: image,
    );
  }
}

class _PaymentDetailsEmptyValue extends StatelessWidget {
  const _PaymentDetailsEmptyValue({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 38,
          ),
          const SizedBox(height: 9),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailsError extends StatelessWidget {
  const _PaymentDetailsError({
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
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentDetailsStatusStyle {
  const _PaymentDetailsStatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });

  final Color color;
  final Color background;
  final IconData icon;
}

_PaymentDetailsStatusStyle _paymentDetailsStatusStyle(
  CollectionApprovalStatus status,
) {
  switch (status) {
    case CollectionApprovalStatus.pendingBillingApproval:
      return const _PaymentDetailsStatusStyle(
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.hourglass_empty,
      );

    case CollectionApprovalStatus.approved:
      return const _PaymentDetailsStatusStyle(
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.check_circle_outline,
      );

    case CollectionApprovalStatus.rejected:
      return const _PaymentDetailsStatusStyle(
        color: AppColors.danger,
        background: AppColors.dangerSoft,
        icon: Icons.cancel_outlined,
      );
  }
}

String _formatDate(DateTime date) {
  final DateTime localDate = date.toLocal();
  final String day = localDate.day.toString().padLeft(2, '0');
  final String month = localDate.month.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year}';
}

String _formatAmount(double amount) {
  final bool isNegative = amount < 0;
  final double absoluteAmount = amount.abs();
  final bool hasDecimals =
      absoluteAmount != absoluteAmount.roundToDouble();

  final String value = absoluteAmount.toStringAsFixed(
    hasDecimals ? 2 : 0,
  );

  final List<String> parts = value.split('.');
  final String integerPart = parts.first;
  final StringBuffer formatted = StringBuffer();

  for (int index = 0; index < integerPart.length; index++) {
    if (index > 0 && (integerPart.length - index) % 3 == 0) {
      formatted.write(',');
    }

    formatted.write(integerPart[index]);
  }

  if (parts.length > 1) {
    formatted
      ..write('.')
      ..write(parts[1]);
  }

  return isNegative ? '-${formatted.toString()}' : formatted.toString();
}
