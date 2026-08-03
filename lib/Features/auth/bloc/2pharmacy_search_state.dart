import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

enum PharmacySearchStatus { initial, loading, success, failure }

class PharmacySearchState extends Equatable {
  const PharmacySearchState({
    this.status = PharmacySearchStatus.initial,
    this.allPharmacies = const <CollectionPharmacyModel>[],
    this.visiblePharmacies = const <CollectionPharmacyModel>[],
    this.query = '',
    this.errorMessage,
  });

  final PharmacySearchStatus status;

  final List<CollectionPharmacyModel> allPharmacies;

  final List<CollectionPharmacyModel> visiblePharmacies;

  final String query;
  final String? errorMessage;

  PharmacySearchState copyWith({
    PharmacySearchStatus? status,
    List<CollectionPharmacyModel>? allPharmacies,
    List<CollectionPharmacyModel>? visiblePharmacies,
    String? query,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PharmacySearchState(
      status: status ?? this.status,
      allPharmacies: allPharmacies ?? this.allPharmacies,
      visiblePharmacies: visiblePharmacies ?? this.visiblePharmacies,
      query: query ?? this.query,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allPharmacies,
    visiblePharmacies,
    query,
    errorMessage,
  ];
}
