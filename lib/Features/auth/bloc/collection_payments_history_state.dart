import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_filter.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

enum CollectionPaymentsHistoryStatus {
  initial,
  loading,
  success,
  failure,
}

const Object _unset = Object();

class CollectionPaymentsHistoryState
    extends Equatable {
  const CollectionPaymentsHistoryState({
    this.status =
        CollectionPaymentsHistoryStatus.initial,
    this.allPayments = const [],
    this.visiblePayments = const [],
    this.selectedFilter =
        CollectionPaymentsHistoryFilter.all,
    this.searchText = '',
    this.errorMessage,
  });

  final CollectionPaymentsHistoryStatus status;

  final List<CollectionPaymentModel> allPayments;
  final List<CollectionPaymentModel>
      visiblePayments;

  final CollectionPaymentsHistoryFilter
      selectedFilter;

  final String searchText;
  final String? errorMessage;

  CollectionPaymentsHistoryState copyWith({
    CollectionPaymentsHistoryStatus? status,
    List<CollectionPaymentModel>? allPayments,
    List<CollectionPaymentModel>?
        visiblePayments,
    CollectionPaymentsHistoryFilter?
        selectedFilter,
    String? searchText,
    Object? errorMessage = _unset,
  }) {
    return CollectionPaymentsHistoryState(
      status: status ?? this.status,
      allPayments:
          allPayments ?? this.allPayments,
      visiblePayments:
          visiblePayments ?? this.visiblePayments,
      selectedFilter:
          selectedFilter ?? this.selectedFilter,
      searchText:
          searchText ?? this.searchText,
      errorMessage:
          identical(errorMessage, _unset)
              ? this.errorMessage
              : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allPayments,
        visiblePayments,
        selectedFilter,
        searchText,
        errorMessage,
      ];
}