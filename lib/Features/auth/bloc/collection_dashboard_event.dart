import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_state.dart';

sealed class CollectionDashboardEvent extends Equatable {
  const CollectionDashboardEvent();

  @override
  List<Object?> get props => const [];
}

final class CollectionDashboardRequested extends CollectionDashboardEvent {
  const CollectionDashboardRequested();
}

final class CollectionSearchChanged extends CollectionDashboardEvent {
  const CollectionSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class CollectionStatusFilterChanged extends CollectionDashboardEvent {
  const CollectionStatusFilterChanged(this.filter);

  final CollectionStatusFilter filter;

  @override
  List<Object?> get props => [filter];
}
