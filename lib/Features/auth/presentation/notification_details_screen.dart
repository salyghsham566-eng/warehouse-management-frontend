import 'package:flutter/material.dart';

import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/data/models/notification_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(notification.type);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,
          title: const Text(
            'تفاصيل الإشعار',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // رأس الإشعار
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            _typeIcon(notification.type),
                            color: typeColor,
                            size: 27,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: [
                                  _InfoBadge(
                                    text: notification.typeLabel,
                                    color: typeColor,
                                  ),

                                  _InfoBadge(
                                    text: 'مقروء',
                                    color: const Color(0xFF159B64),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Divider(
                      color: AppColors.border,
                      height: 1,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),

                        const SizedBox(width: 7),

                        Text(
                          _formatDateTime(notification.dateTime),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // =================================================
              // نص الإشعار
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.subject_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'محتوى الإشعار',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      notification.body,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // المرجع
              // =================================================

              if (notification.referenceId.isNotEmpty) ...[
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),

                          SizedBox(width: 8),

                          Text(
                            'المرجع',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  if (notification
                                      .referenceLabel.isNotEmpty)
                                    Text(
                                      notification.referenceLabel,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                  if (notification
                                      .referenceLabel.isNotEmpty)
                                    const SizedBox(height: 4),

                                  Text(
                                    notification.referenceId,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.tag_rounded,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // =================================================
              // ملاحظة UC-249
              // =================================================

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),

                    SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        'يعرض هذا القسم ملخص الإشعار فقط. التفاصيل الكاملة تبقى ضمن القسم الأصلي المرتبط به.',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Badge
// ==========================================================

class _InfoBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _InfoBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ==========================================================
// Helpers
// ==========================================================

IconData _typeIcon(NotificationType type) {
  switch (type) {
    case NotificationType.orders:
      return Icons.shopping_bag_outlined;

    case NotificationType.collection:
      return Icons.payments_outlined;

    case NotificationType.workPlans:
      return Icons.assignment_outlined;

    case NotificationType.offers:
      return Icons.local_offer_outlined;

    case NotificationType.evaluation:
      return Icons.workspace_premium_outlined;

    case NotificationType.general:
      return Icons.campaign_outlined;
  }
}

Color _typeColor(NotificationType type) {
  switch (type) {
    case NotificationType.orders:
      return const Color(0xFF175CD3);

    case NotificationType.collection:
      return const Color(0xFF159B64);

    case NotificationType.workPlans:
      return const Color(0xFF6941C6);

    case NotificationType.offers:
      return const Color(0xFFF79009);

    case NotificationType.evaluation:
      return const Color(0xFFC11574);

    case NotificationType.general:
      return const Color(0xFF475467);
  }
}

String _formatDateTime(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  final hour = date.hour == 0
      ? 12
      : date.hour > 12
          ? date.hour - 12
          : date.hour;

  final minute = date.minute.toString().padLeft(2, '0');

  final period = date.hour >= 12 ? 'م' : 'ص';

  return '$day/$month/${date.year} • $hour:$minute $period';
}