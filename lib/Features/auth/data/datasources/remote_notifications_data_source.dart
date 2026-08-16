import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/notifications_data_source.dart';
import 'package:project_2/Features/auth/data/models/notification_model.dart';

class RemoteNotificationsDataSource
    implements NotificationsDataSource {
  final Dio dio;

  const RemoteNotificationsDataSource({
    required this.dio,
  });

  @override
  Future<List<NotificationModel>>
      getNotifications() async {
    try {
      final response = await dio.get(
        ApiEndpoints.representativeNotifications,
      );

      return _parseNotificationsList(
        response.data,
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  @override
  Future<NotificationModel>
      getNotificationDetails(
    String notificationId,
  ) async {
    try {
      final response = await dio.get(
        ApiEndpoints.notificationDetails(
          notificationId,
        ),
      );

      final payload =
          _extractSingleNotification(
        response.data,
      );

      return NotificationModel.fromJson(
        payload,
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  @override
  Future<void> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      await dio.patch(
        ApiEndpoints.notificationMarkRead(
          notificationId,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  @override
  Future<void>
      markAllNotificationsAsRead() async {
    try {
      await dio.patch(
        ApiEndpoints
            .notificationsMarkAllRead,
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  @override
  Future<List<NotificationModel>>
      getNotificationArchive() async {
    try {
      final response = await dio.get(
        ApiEndpoints.notificationsArchive,
      );

      return _parseNotificationsList(
        response.data,
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  List<NotificationModel>
      _parseNotificationsList(
    dynamic responseData,
  ) {
    final rawList =
        _extractNotificationList(
      responseData,
    );

    return rawList
        .whereType<Map>()
        .map(
          (item) =>
              NotificationModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .where(
          (notification) =>
              notification.id.isNotEmpty,
        )
        .toList()
      ..sort(
        (a, b) => b.dateTime.compareTo(
          a.dateTime,
        ),
      );
  }

  List<dynamic> _extractNotificationList(
    dynamic responseData,
  ) {
    if (responseData is List) {
      return responseData;
    }

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة الإشعارات غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic rawData =
        root['data'];

    if (rawData is List) {
      return rawData;
    }

    final Map<String, dynamic> payload =
        rawData is Map
            ? Map<String, dynamic>.from(
                rawData,
              )
            : root;

    for (final key in const [
      'notifications',
      'items',
      'results',
    ]) {
      final value = payload[key];

      if (value is List) {
        return value;
      }
    }

    return const [];
  }

  Map<String, dynamic>
      _extractSingleNotification(
    dynamic responseData,
  ) {
    if (responseData is! Map) {
      throw Exception(
        'صيغة تفاصيل الإشعار غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic rawData =
        root['data'];

    if (rawData is Map) {
      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      final dynamic nestedNotification =
          data['notification'];

      if (nestedNotification is Map) {
        return Map<String, dynamic>.from(
          nestedNotification,
        );
      }

      return data;
    }

    final dynamic notification =
        root['notification'];

    if (notification is Map) {
      return Map<String, dynamic>.from(
        notification,
      );
    }

    return root;
  }

  String _handleDioError(
    DioException error,
  ) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'] ??
          data['error'];

      if (message != null &&
          message
              .toString()
              .trim()
              .isNotEmpty) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل الإشعارات';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}