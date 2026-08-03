import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

enum CollectionPaymentsHistoryStatus {
  initial,
  loading,
  success,
  failure,
}

class CollectionPaymentsHistoryState
    extends Equatable {
  const CollectionPaymentsHistoryState({
    this.status =
        CollectionPaymentsHistoryStatus.initial,
    this.allPayments =
        const <CollectionPaymentModel>[],
    this.visiblePayments =
        const <CollectionPaymentModel>[],
    this.selectedPharmacyId,
    this.errorMessage,
  });

  final CollectionPaymentsHistoryStatus status;

  final List<CollectionPaymentModel> allPayments;
  final List<CollectionPaymentModel> visiblePayments;

  final String? selectedPharmacyId;
  final String? errorMessage;

  CollectionPaymentsHistoryState copyWith({
    CollectionPaymentsHistoryStatus? status,
    List<CollectionPaymentModel>? allPayments,
    List<CollectionPaymentModel>? visiblePayments,
    String? selectedPharmacyId,
    bool clearPharmacyFilter = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CollectionPaymentsHistoryState(
      status: status ?? this.status,
      allPayments: allPayments ?? this.allPayments,
      visiblePayments:
          visiblePayments ?? this.visiblePayments,
      selectedPharmacyId: clearPharmacyFilter
          ? null
          : selectedPharmacyId ??
              this.selectedPharmacyId,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allPayments,
        visiblePayments,
        selectedPharmacyId,
        errorMessage,
      ];
}