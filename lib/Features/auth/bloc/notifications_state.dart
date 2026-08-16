import 'package:project_2/Features/auth/data/models/notification_model.dart';

abstract class NotificationsState {}

class NotificationsInitial
    extends NotificationsState {}

class NotificationsLoading
    extends NotificationsState {}

class NotificationsLoaded
    extends NotificationsState {
  /// كل الإشعارات المحملة قبل التصفية
  final List<NotificationModel>
      allNotifications;

  /// الإشعارات الظاهرة بعد التصفية
  final List<NotificationModel>
      visibleNotifications;

  final NotificationType? selectedType;

  final NotificationFilterStatus
      selectedStatus;

  final DateTime? fromDate;
  final DateTime? toDate;

  /// عدد الإشعارات غير المقروءة
  final int unreadCount;

  /// هل نحن داخل الأرشيف؟
  final bool isArchiveMode;

  /// يستخدم لاحقاً بشاشة التفاصيل
  final NotificationModel?
      selectedNotification;

   NotificationsLoaded({
    required this.allNotifications,
    required this.visibleNotifications,
    required this.selectedStatus,
    required this.unreadCount,
    required this.isArchiveMode,
    this.selectedType,
    this.fromDate,
    this.toDate,
    this.selectedNotification,
  });
}

class NotificationsFailure
    extends NotificationsState {
  final String message;

  NotificationsFailure({
    required this.message,
  });
}