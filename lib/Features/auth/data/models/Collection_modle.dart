import 'package:equatable/equatable.dart';

enum CollectionPaymentStatus { approved, pending, rejected }

extension CollectionPaymentStatusExtension on CollectionPaymentStatus {
  String get label {
    switch (this) {
      case CollectionPaymentStatus.approved:
        return 'معتمدة';

      case CollectionPaymentStatus.pending:
        return 'بانتظار الاعتماد';

      case CollectionPaymentStatus.rejected:
        return 'مرفوضة';
    }
  }

  static CollectionPaymentStatus fromApi(String value) {
    switch (value) {
      case 'approved':
        return CollectionPaymentStatus.approved;

      case 'pending':
        return CollectionPaymentStatus.pending;

      case 'rejected':
        return CollectionPaymentStatus.rejected;

      default:
        throw FormatException('حالة دفعة غير معروفة: $value');
    }
  }
}

class CollectionDashboardModel extends Equatable {
  const CollectionDashboardModel({
    required this.totalToday,
    required this.growthPercent,
    required this.approvedCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.recentCollections,
  });

  final double totalToday;
  final double growthPercent;

  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;

  final List<CollectionItemModel> recentCollections;

  factory CollectionDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;
    final collections = json['recent_collections'] as List<dynamic>;

    return CollectionDashboardModel(
      totalToday: (summary['total_today'] as num).toDouble(),
      growthPercent: (summary['growth_percent'] as num).toDouble(),
      approvedCount: (summary['approved_count'] as num).toInt(),
      pendingCount: (summary['pending_count'] as num).toInt(),
      rejectedCount: (summary['rejected_count'] as num).toInt(),
      recentCollections: collections
          .map(
            (item) =>
                CollectionItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [
    totalToday,
    growthPercent,
    approvedCount,
    pendingCount,
    rejectedCount,
    recentCollections,
  ];
}

class CollectionItemModel extends Equatable {
  const CollectionItemModel({
    required this.id,
    required this.pharmacyName,
    required this.areaName,
    required this.amount,
    required this.date,
    required this.status,
    this.rejectionReason,
  });

  final String id;
  final String pharmacyName;
  final String areaName;
  final double amount;
  final DateTime date;
  final CollectionPaymentStatus status;
  final String? rejectionReason;

  factory CollectionItemModel.fromJson(Map<String, dynamic> json) {
    return CollectionItemModel(
      id: json['id'] as String,
      pharmacyName: json['pharmacy_name'] as String,
      areaName: json['area_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: CollectionPaymentStatusExtension.fromApi(
        json['status'] as String,
      ),
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    pharmacyName,
    areaName,
    amount,
    date,
    status,
    rejectionReason,
  ];
}
