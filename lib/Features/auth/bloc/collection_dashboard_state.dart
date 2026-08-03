import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/Collection_modle.dart';

enum CollectionLoadStatus { initial, loading, success, failure }

enum CollectionStatusFilter { all, approved, pending, rejected }

extension CollectionStatusFilterExtension on CollectionStatusFilter {
  String get label {
    switch (this) {
      case CollectionStatusFilter.all:
        return 'جميع الدفعات';

      case CollectionStatusFilter.approved:
        return 'معتمدة';

      case CollectionStatusFilter.pending:
        return 'بانتظار الاعتماد';

      case CollectionStatusFilter.rejected:
        return 'مرفوضة';
    }
  }

  CollectionPaymentStatus? get paymentStatus {
    switch (this) {
      case CollectionStatusFilter.all:
        return null;

      case CollectionStatusFilter.approved:
        return CollectionPaymentStatus.approved;

      case CollectionStatusFilter.pending:
        return CollectionPaymentStatus.pending;

      case CollectionStatusFilter.rejected:
        return CollectionPaymentStatus.rejected;
    }
  }
}

class CollectionDashboardState extends Equatable {
  const CollectionDashboardState({
    this.loadStatus = CollectionLoadStatus.initial,
    this.dashboard,
    this.visibleCollections = const [],
    this.searchQuery = '',
    this.statusFilter = CollectionStatusFilter.all,
    this.errorMessage,
  });

  final CollectionLoadStatus loadStatus;
  final CollectionDashboardModel? dashboard;

  final List<CollectionItemModel> visibleCollections;

  final String searchQuery;
  final CollectionStatusFilter statusFilter;
  final String? errorMessage;

  CollectionDashboardState copyWith({
    CollectionLoadStatus? loadStatus,
    CollectionDashboardModel? dashboard,
    List<CollectionItemModel>? visibleCollections,
    String? searchQuery,
    CollectionStatusFilter? statusFilter,
    String? errorMessage,
  }) {
    return CollectionDashboardState(
      loadStatus: loadStatus ?? this.loadStatus,
      dashboard: dashboard ?? this.dashboard,
      visibleCollections: visibleCollections ?? this.visibleCollections,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    dashboard,
    visibleCollections,
    searchQuery,
    statusFilter,
    errorMessage,
  ];
}
