import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_filter.dart';

abstract class CollectionPaymentsHistoryEvent
    extends Equatable {
  const CollectionPaymentsHistoryEvent();

  @override
  List<Object?> get props => [];
}

class CollectionPaymentsHistoryRequested
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsHistoryRequested();
}

class CollectionPaymentsHistoryRefreshed
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsHistoryRefreshed();
}

class CollectionPaymentsHistorySearchChanged
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsHistorySearchChanged(
    this.searchText,
  );

  final String searchText;

  @override
  List<Object?> get props => [searchText];
}

class CollectionPaymentsHistoryFilterChanged
    extends CollectionPaymentsHistoryEvent {
  const CollectionPaymentsHistoryFilterChanged(
    this.filter,
  );

  final CollectionPaymentsHistoryFilter filter;

  @override
  List<Object?> get props => [filter];
}