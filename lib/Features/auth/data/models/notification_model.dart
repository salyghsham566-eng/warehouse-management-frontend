enum NotificationType {
  orders,
  collection,
  workPlans,
  offers,
  evaluation,
  general,
}

enum NotificationFilterStatus {
  all,
  unread,
  read,
}

class NotificationModel {
  final String id;
  final String title;
  final NotificationType type;
  final String summary;
  final String body;
  final DateTime dateTime;
  final bool isRead;

  /// المرجع المختصر المرتبط بالإشعار
  /// مثال: ORD-1025 أو COL-220
  final String referenceId;

  /// اسم مختصر للمرجع
  /// مثال: الطلب رقم 1025
  final String referenceLabel;

  /// يستخدم في UC-260
  final bool isArchived;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.summary,
    required this.body,
    required this.dateTime,
    required this.isRead,
    required this.referenceId,
    required this.referenceLabel,
    this.isArchived = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    NotificationType? type,
    String? summary,
    String? body,
    DateTime? dateTime,
    bool? isRead,
    String? referenceId,
    String? referenceLabel,
    bool? isArchived,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      isRead: isRead ?? this.isRead,
      referenceId:
          referenceId ?? this.referenceId,
      referenceLabel:
          referenceLabel ?? this.referenceLabel,
      isArchived:
          isArchived ?? this.isArchived,
    );
  }

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: _readString(
        json,
        const [
          'id',
          'notification_id',
          'notificationId',
        ],
      ),

      title: _readString(
        json,
        const [
          'title',
          'subject',
        ],
        fallback: 'إشعار',
      ),

      type: _parseType(
        json['type'] ??
            json['notification_type'] ??
            json['category'],
      ),

      summary: _readString(
        json,
        const [
          'summary',
          'short_message',
          'shortMessage',
          'description',
        ],
      ),

      body: _readString(
        json,
        const [
          'body',
          'message',
          'content',
          'text',
        ],
      ),

      dateTime: _parseDateTime(
        json['date_time'] ??
            json['dateTime'] ??
            json['created_at'] ??
            json['createdAt'] ??
            json['date'] ??
            json['timestamp'],
      ),

      isRead: _parseIsRead(
        json,
      ),

      referenceId: _readString(
        json,
        const [
          'reference_id',
          'referenceId',
          'reference',
          'entity_id',
          'entityId',
        ],
      ),

      referenceLabel: _readString(
        json,
        const [
          'reference_label',
          'referenceLabel',
          'reference_title',
          'referenceTitle',
        ],
      ),

      isArchived: _parseBool(
        json['is_archived'] ??
            json['isArchived'] ??
            json['archived'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.apiValue,
      'summary': summary,
      'body': body,
      'date_time':
          dateTime.toIso8601String(),
      'is_read': isRead,
      'reference_id': referenceId,
      'reference_label': referenceLabel,
      'is_archived': isArchived,
    };
  }

  String get typeLabel {
    switch (type) {
      case NotificationType.orders:
        return 'طلبات';

      case NotificationType.collection:
        return 'تحصيل';

      case NotificationType.workPlans:
        return 'خطط عمل';

      case NotificationType.offers:
        return 'عروض وحسومات';

      case NotificationType.evaluation:
        return 'تقييم';

      case NotificationType.general:
        return 'عام';
    }
  }

  static NotificationType _parseType(
    dynamic value,
  ) {
    final type =
        value?.toString().toLowerCase().trim();

    switch (type) {
      case 'orders':
      case 'order':
      case 'طلبات':
        return NotificationType.orders;

      case 'collection':
      case 'collections':
      case 'payment':
      case 'payments':
      case 'تحصيل':
        return NotificationType.collection;

      case 'work_plan':
      case 'work_plans':
      case 'work-plan':
      case 'work-plans':
      case 'workplans':
      case 'خطط عمل':
        return NotificationType.workPlans;

      case 'offer':
      case 'offers':
      case 'discount':
      case 'discounts':
      case 'عروض':
      case 'عروض وحسومات':
        return NotificationType.offers;

      case 'evaluation':
      case 'rating':
      case 'تقييم':
        return NotificationType.evaluation;

      default:
        return NotificationType.general;
    }
  }

  static bool _parseIsRead(
    Map<String, dynamic> json,
  ) {
    final direct =
        json['is_read'] ??
        json['isRead'] ??
        json['read'];

    if (direct != null) {
      return _parseBool(direct);
    }

    final status =
        json['status']?.toString().toLowerCase();

    return status == 'read' ||
        status == 'مقروء';
  }

  static bool _parseBool(
    dynamic value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final text =
        value?.toString().toLowerCase().trim();

    return text == 'true' ||
        text == '1' ||
        text == 'yes' ||
        text == 'read';
  }

  static DateTime _parseDateTime(
    dynamic value,
  ) {
    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
          value?.toString() ?? '',
        ) ??
        DateTime.now();
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return fallback;
  }
}

extension NotificationTypeExtension
    on NotificationType {
  String get apiValue {
    switch (this) {
      case NotificationType.orders:
        return 'orders';

      case NotificationType.collection:
        return 'collection';

      case NotificationType.workPlans:
        return 'work_plans';

      case NotificationType.offers:
        return 'offers';

      case NotificationType.evaluation:
        return 'evaluation';

      case NotificationType.general:
        return 'general';
    }
  }
}