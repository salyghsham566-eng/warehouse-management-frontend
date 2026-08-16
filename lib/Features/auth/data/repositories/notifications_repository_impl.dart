import 'package:project_2/Features/auth/data/datasources/notifications_data_source.dart';
import 'package:project_2/Features/auth/data/models/notification_model.dart';
import 'package:project_2/Features/auth/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl
    implements NotificationsRepository {
  final NotificationsDataSource dataSource;

  const NotificationsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<NotificationModel>>
      getNotifications() {
    return dataSource.getNotifications();
  }

  @override
  Future<NotificationModel>
      getNotificationDetails(
    String notificationId,
  ) {
    return dataSource
        .getNotificationDetails(
      notificationId,
    );
  }

  @override
  Future<void> markNotificationAsRead(
    String notificationId,
  ) {
    return dataSource
        .markNotificationAsRead(
      notificationId,
    );
  }

  @override
  Future<void>
      markAllNotificationsAsRead() {
    return dataSource
        .markAllNotificationsAsRead();
  }

  @override
  Future<List<NotificationModel>>
      getNotificationArchive() {
    return dataSource
        .getNotificationArchive();
  }
}