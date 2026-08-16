import 'package:project_2/Features/auth/data/models/notification_model.dart';

abstract class NotificationsEvent {}

class LoadNotificationsEvent
    extends NotificationsEvent {}

class LoadNotificationsArchiveEvent
    extends NotificationsEvent {}

class FilterNotificationsByTypeEvent
    extends NotificationsEvent {
  final NotificationType? type;

  FilterNotificationsByTypeEvent({
    required this.type,
  });
}

class FilterNotificationsByStatusEvent
    extends NotificationsEvent {
  final NotificationFilterStatus status;

  FilterNotificationsByStatusEvent({
    required this.status,
  });
}

class FilterNotificationsByDateEvent
    extends NotificationsEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  FilterNotificationsByDateEvent({
    this.fromDate,
    this.toDate,
  });
}

class ClearNotificationsFiltersEvent
    extends NotificationsEvent {}

class OpenNotificationEvent
    extends NotificationsEvent {
  final String notificationId;

  OpenNotificationEvent({
    required this.notificationId,
  });
}

class MarkNotificationAsReadEvent
    extends NotificationsEvent {
  final String notificationId;

  MarkNotificationAsReadEvent({
    required this.notificationId,
  });
}

class MarkAllNotificationsAsReadEvent
    extends NotificationsEvent {}