import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/notifications_event.dart';
import 'package:project_2/Features/auth/bloc/notifications_state.dart';
import 'package:project_2/Features/auth/data/models/notification_model.dart';
import 'package:project_2/Features/auth/domain/repositories/notifications_repository.dart';

class NotificationsBloc
    extends Bloc<
        NotificationsEvent,
        NotificationsState> {
  final NotificationsRepository repository;

  NotificationsBloc({
    required this.repository,
  }) : super(
          NotificationsInitial(),
        ) {
    on<LoadNotificationsEvent>(
      _loadNotifications,
    );

    on<LoadNotificationsArchiveEvent>(
      _loadArchive,
    );

    on<FilterNotificationsByTypeEvent>(
      _filterByType,
    );

    on<FilterNotificationsByStatusEvent>(
      _filterByStatus,
    );

    on<FilterNotificationsByDateEvent>(
      _filterByDate,
    );

    on<ClearNotificationsFiltersEvent>(
      _clearFilters,
    );

    on<OpenNotificationEvent>(
      _openNotification,
    );

    on<MarkNotificationAsReadEvent>(
      _markAsRead,
    );

    on<MarkAllNotificationsAsReadEvent>(
      _markAllAsRead,
    );
  }

  Future<void> _loadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      NotificationsLoading(),
    );

    try {
      final notifications =
          await repository
              .getNotifications();

      emit(
        _createLoadedState(
          notifications:
              notifications,
          isArchiveMode: false,
        ),
      );
    } catch (error) {
      emit(
        NotificationsFailure(
          message:
              _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _loadArchive(
    LoadNotificationsArchiveEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      NotificationsLoading(),
    );

    try {
      final notifications =
          await repository
              .getNotificationArchive();

      emit(
        _createLoadedState(
          notifications:
              notifications,
          isArchiveMode: true,
        ),
      );
    } catch (error) {
      emit(
        NotificationsFailure(
          message:
              _getErrorMessage(error),
        ),
      );
    }
  }

  void _filterByType(
    FilterNotificationsByTypeEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    emit(
      _applyFilters(
        current: current,
        selectedType: event.type,
        replaceType: true,
      ),
    );
  }

  void _filterByStatus(
    FilterNotificationsByStatusEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    emit(
      _applyFilters(
        current: current,
        selectedStatus:
            event.status,
      ),
    );
  }

  void _filterByDate(
    FilterNotificationsByDateEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    emit(
      _applyFilters(
        current: current,
        fromDate: event.fromDate,
        toDate: event.toDate,
        replaceDate: true,
      ),
    );
  }

  void _clearFilters(
    ClearNotificationsFiltersEvent event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    final notifications =
        List<NotificationModel>.from(
      current.allNotifications,
    )..sort(
            (a, b) =>
                b.dateTime.compareTo(
              a.dateTime,
            ),
          );

    emit(
      NotificationsLoaded(
        allNotifications:
            notifications,
        visibleNotifications:
            notifications,
        selectedStatus:
            NotificationFilterStatus.all,
        unreadCount:
            _calculateUnreadCount(
          notifications,
        ),
        isArchiveMode:
            current.isArchiveMode,
      ),
    );
  }

  Future<void> _openNotification(
    OpenNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    try {
      var notification =
          await repository
              .getNotificationDetails(
        event.notificationId,
      );

      if (!notification.isRead) {
        await repository
            .markNotificationAsRead(
          event.notificationId,
        );

        notification =
            notification.copyWith(
          isRead: true,
        );
      }

      final updatedNotifications =
          current.allNotifications.map(
        (item) {
          if (item.id ==
              notification.id) {
            return item.copyWith(
              isRead: true,
            );
          }

          return item;
        },
      ).toList();

      emit(
        _applyFilters(
          current:
              NotificationsLoaded(
            allNotifications:
                updatedNotifications,
            visibleNotifications:
                updatedNotifications,
            selectedType:
                current.selectedType,
            selectedStatus:
                current.selectedStatus,
            fromDate:
                current.fromDate,
            toDate:
                current.toDate,
            unreadCount:
                _calculateUnreadCount(
              updatedNotifications,
            ),
            isArchiveMode:
                current.isArchiveMode,
            selectedNotification:
                notification,
          ),
        ),
      );
    } catch (error) {
      emit(
        NotificationsFailure(
          message:
              _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _markAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    try {
      await repository
          .markNotificationAsRead(
        event.notificationId,
      );

      final updated =
          current.allNotifications.map(
        (notification) {
          if (notification.id ==
              event.notificationId) {
            return notification.copyWith(
              isRead: true,
            );
          }

          return notification;
        },
      ).toList();

      emit(
        _applyFilters(
          current:
              NotificationsLoaded(
            allNotifications: updated,
            visibleNotifications:
                updated,
            selectedType:
                current.selectedType,
            selectedStatus:
                current.selectedStatus,
            fromDate:
                current.fromDate,
            toDate:
                current.toDate,
            unreadCount:
                _calculateUnreadCount(
              updated,
            ),
            isArchiveMode:
                current.isArchiveMode,
            selectedNotification:
                current
                    .selectedNotification,
          ),
        ),
      );
    } catch (error) {
      emit(
        NotificationsFailure(
          message:
              _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _markAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;

    if (current
        is! NotificationsLoaded) {
      return;
    }

    try {
      await repository
          .markAllNotificationsAsRead();

      final updated =
          current.allNotifications
              .map(
                (notification) =>
                    notification.copyWith(
                  isRead: true,
                ),
              )
              .toList();

      emit(
        _applyFilters(
          current:
              NotificationsLoaded(
            allNotifications: updated,
            visibleNotifications:
                updated,
            selectedType:
                current.selectedType,
            selectedStatus:
                current.selectedStatus,
            fromDate:
                current.fromDate,
            toDate:
                current.toDate,
            unreadCount: 0,
            isArchiveMode:
                current.isArchiveMode,
            selectedNotification:
                current
                    .selectedNotification,
          ),
        ),
      );
    } catch (error) {
      emit(
        NotificationsFailure(
          message:
              _getErrorMessage(error),
        ),
      );
    }
  }

  NotificationsLoaded _createLoadedState({
    required List<NotificationModel>
        notifications,
    required bool isArchiveMode,
  }) {
    final sorted =
        List<NotificationModel>.from(
      notifications,
    )..sort(
            (a, b) =>
                b.dateTime.compareTo(
              a.dateTime,
            ),
          );

    return NotificationsLoaded(
      allNotifications: sorted,
      visibleNotifications: sorted,
      selectedStatus:
          NotificationFilterStatus.all,
      unreadCount:
          _calculateUnreadCount(
        sorted,
      ),
      isArchiveMode: isArchiveMode,
    );
  }

  NotificationsLoaded _applyFilters({
    required NotificationsLoaded
        current,
    NotificationType? selectedType,
    bool replaceType = false,
    NotificationFilterStatus?
        selectedStatus,
    DateTime? fromDate,
    DateTime? toDate,
    bool replaceDate = false,
  }) {
    final type = replaceType
        ? selectedType
        : current.selectedType;

    final status =
        selectedStatus ??
        current.selectedStatus;

    final startDate = replaceDate
        ? fromDate
        : current.fromDate;

    final endDate = replaceDate
        ? toDate
        : current.toDate;

    var filtered =
        List<NotificationModel>.from(
      current.allNotifications,
    );

    if (type != null) {
      filtered = filtered
          .where(
            (notification) =>
                notification.type ==
                type,
          )
          .toList();
    }

    switch (status) {
      case NotificationFilterStatus
            .unread:
        filtered = filtered
            .where(
              (notification) =>
                  !notification.isRead,
            )
            .toList();
        break;

      case NotificationFilterStatus
            .read:
        filtered = filtered
            .where(
              (notification) =>
                  notification.isRead,
            )
            .toList();
        break;

      case NotificationFilterStatus.all:
        break;
    }

    if (startDate != null) {
      final start = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      filtered = filtered
          .where(
            (notification) =>
                !notification.dateTime
                    .isBefore(start),
          )
          .toList();
    }

    if (endDate != null) {
      final end = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
        999,
      );

      filtered = filtered
          .where(
            (notification) =>
                !notification.dateTime
                    .isAfter(end),
          )
          .toList();
    }

    filtered.sort(
      (a, b) => b.dateTime.compareTo(
        a.dateTime,
      ),
    );

    return NotificationsLoaded(
      allNotifications:
          current.allNotifications,
      visibleNotifications: filtered,
      selectedType: type,
      selectedStatus: status,
      fromDate: startDate,
      toDate: endDate,
      unreadCount:
          _calculateUnreadCount(
        current.allNotifications,
      ),
      isArchiveMode:
          current.isArchiveMode,
      selectedNotification:
          current.selectedNotification,
    );
  }

  int _calculateUnreadCount(
    List<NotificationModel>
        notifications,
  ) {
    return notifications
        .where(
          (notification) =>
              !notification.isRead,
        )
        .length;
  }

  String _getErrorMessage(
    Object error,
  ) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}