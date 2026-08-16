import 'package:project_2/Features/auth/data/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationModel>>
      getNotifications();

  Future<NotificationModel>
      getNotificationDetails(
    String notificationId,
  );

  Future<void> markNotificationAsRead(
    String notificationId,
  );

  Future<void>
      markAllNotificationsAsRead();

  Future<List<NotificationModel>>
      getNotificationArchive();
}