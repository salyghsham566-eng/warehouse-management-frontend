import 'package:project_2/Features/auth/data/datasources/notifications_data_source.dart';
import 'package:project_2/Features/auth/data/models/notification_model.dart';

class MockNotificationsDataSource
    implements NotificationsDataSource {
  late final List<NotificationModel>
      _notifications;

  MockNotificationsDataSource() {
    final now = DateTime.now();

    _notifications = [
      NotificationModel(
        id: 'notification-1',
        title: 'تم اعتماد الطلب',
        type: NotificationType.orders,
        summary:
            'تم اعتماد الطلب رقم ORD-1025.',
        body:
            'تمت الموافقة على الطلب ويمكنك متابعة حالته من قسم الطلبات.',
        dateTime: now.subtract(
          const Duration(
            minutes: 20,
          ),
        ),
        isRead: false,
        referenceId: 'ORD-1025',
        referenceLabel:
            'الطلب رقم 1025',
      ),

      NotificationModel(
        id: 'notification-2',
        title: 'تم اعتماد عملية تحصيل',
        type: NotificationType.collection,
        summary:
            'تم اعتماد دفعة التحصيل رقم COL-220.',
        body:
            'تم اعتماد عملية التحصيل بنجاح. يمكنك مراجعة تفاصيل العملية من قسم التحصيل.',
        dateTime: now.subtract(
          const Duration(
            hours: 2,
          ),
        ),
        isRead: false,
        referenceId: 'COL-220',
        referenceLabel:
            'عملية التحصيل رقم 220',
      ),

      NotificationModel(
        id: 'notification-3',
        title: 'تحديث على خطة العمل',
        type: NotificationType.workPlans,
        summary:
            'تم تحديث حالة خطة العمل الحالية.',
        body:
            'يوجد تحديث جديد على خطة العمل. راجع قسم خطط العمل للاطلاع على التفاصيل.',
        dateTime: now.subtract(
          const Duration(
            days: 1,
          ),
        ),
        isRead: false,
        referenceId: 'PLAN-15',
        referenceLabel:
            'خطة العمل رقم 15',
      ),

      NotificationModel(
        id: 'notification-4',
        title: 'عرض جديد متاح',
        type: NotificationType.offers,
        summary:
            'تمت إضافة عرض جديد للمندوب.',
        body:
            'تمت إضافة عرض جديد ضمن العروض والحسومات ويمكن استخدامه ضمن فترة صلاحيته.',
        dateTime: now.subtract(
          const Duration(
            days: 2,
            hours: 3,
          ),
        ),
        isRead: true,
        referenceId: 'OFFER-2',
        referenceLabel:
            'العرض رقم 2',
      ),

      NotificationModel(
        id: 'notification-5',
        title: 'تحديث التقييم',
        type: NotificationType.evaluation,
        summary:
            'تم تحديث تقييمك الشهري.',
        body:
            'تم تحديث بيانات التقييم الخاصة بك. يمكنك مراجعة التفاصيل من قسم التقييم.',
        dateTime: now.subtract(
          const Duration(
            days: 3,
          ),
        ),
        isRead: false,
        referenceId: 'EVAL-08-2026',
        referenceLabel:
            'تقييم شهر 08/2026',
      ),

      NotificationModel(
        id: 'notification-6',
        title: 'تنبيه عام',
        type: NotificationType.general,
        summary:
            'يرجى التأكد من تحديث بيانات الحساب.',
        body:
            'يرجى التأكد من صحة بيانات الحساب ومعلومات التواصل الخاصة بك.',
        dateTime: now.subtract(
          const Duration(
            days: 4,
          ),
        ),
        isRead: true,
        referenceId: '',
        referenceLabel: 'تنبيه عام',
      ),

      // =====================================================
      // Archive Mock
      // =====================================================

      NotificationModel(
        id: 'notification-7',
        title: 'طلب سابق',
        type: NotificationType.orders,
        summary:
            'تم إنهاء معالجة الطلب السابق.',
        body:
            'هذا إشعار قديم محفوظ ضمن أرشيف الإشعارات.',
        dateTime: now.subtract(
          const Duration(
            days: 18,
          ),
        ),
        isRead: true,
        referenceId: 'ORD-980',
        referenceLabel:
            'الطلب رقم 980',
        isArchived: true,
      ),

      NotificationModel(
        id: 'notification-8',
        title: 'عرض سابق',
        type: NotificationType.offers,
        summary:
            'انتهت صلاحية العرض السابق.',
        body:
            'هذا إشعار قديم خاص بعرض سابق ومحفوظ ضمن الأرشيف.',
        dateTime: now.subtract(
          const Duration(
            days: 25,
          ),
        ),
        isRead: true,
        referenceId: 'OFFER-1',
        referenceLabel:
            'العرض رقم 1',
        isArchived: true,
      ),
    ];
  }

  @override
  Future<List<NotificationModel>>
      getNotifications() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    return _notifications
        .where(
          (notification) =>
              !notification.isArchived,
        )
        .toList()
      ..sort(
        (a, b) => b.dateTime.compareTo(
          a.dateTime,
        ),
      );
  }

  @override
  Future<NotificationModel>
      getNotificationDetails(
    String notificationId,
  ) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    final index =
        _notifications.indexWhere(
      (notification) =>
          notification.id ==
          notificationId,
    );

    if (index == -1) {
      throw Exception(
        'الإشعار غير موجود',
      );
    }

    return _notifications[index];
  }

  @override
  Future<void> markNotificationAsRead(
    String notificationId,
  ) async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 200,
      ),
    );

    final index =
        _notifications.indexWhere(
      (notification) =>
          notification.id ==
          notificationId,
    );

    if (index == -1) {
      throw Exception(
        'الإشعار غير موجود',
      );
    }

    _notifications[index] =
        _notifications[index].copyWith(
      isRead: true,
    );
  }

  @override
  Future<void>
      markAllNotificationsAsRead() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 300,
      ),
    );

    for (int i = 0;
        i < _notifications.length;
        i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] =
            _notifications[i].copyWith(
          isRead: true,
        );
      }
    }
  }

  @override
  Future<List<NotificationModel>>
      getNotificationArchive() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    return _notifications
        .where(
          (notification) =>
              notification.isArchived ||
              notification.isRead,
        )
        .toList()
      ..sort(
        (a, b) => b.dateTime.compareTo(
          a.dateTime,
        ),
      );
  }
}