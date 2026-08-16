import 'package:project_2/Features/auth/data/models/notification_model.dart';

abstract class NotificationsDataSource {
  // =========================================================
  // UC-246 + UC-248
  // =========================================================

  Future<List<NotificationModel>>
      getNotifications();

  // =========================================================
  // UC-249
  // =========================================================

  Future<NotificationModel>
      getNotificationDetails(
    String notificationId,
  );

  // =========================================================
  // UC-253
  // =========================================================

  Future<void> markNotificationAsRead(
    String notificationId,
  );

  // =========================================================
  // UC-254
  // =========================================================

  Future<void>
      markAllNotificationsAsRead();

  // =========================================================
  // UC-260
  // =========================================================

  Future<List<NotificationModel>>
      getNotificationArchive();
}