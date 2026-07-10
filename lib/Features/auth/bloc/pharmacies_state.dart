import '../data/models/pharmacy_model.dart';

enum PharmaciesStatus {
  initial,
  loading,
  success,
  failure,
}

class PharmaciesState {
  final PharmaciesStatus status;
  final List<PharmacyModel> pharmacies;
  final List<PharmacyModel> visiblePharmacies;
  final String selectedArea;
  final String searchText;
  final String? errorMessage;

  const PharmaciesState({
    this.status = PharmaciesStatus.initial,
    this.pharmacies = const [],
    this.visiblePharmacies = const [],
    this.selectedArea = "الكل",
    this.searchText = "",
    this.errorMessage,
  });

  PharmaciesState copyWith({
    PharmaciesStatus? status,
    List<PharmacyModel>? pharmacies,
    List<PharmacyModel>? visiblePharmacies,
    String? selectedArea,
    String? searchText,
    String? errorMessage,
  }) {
    return PharmaciesState(
      status: status ?? this.status,
      pharmacies: pharmacies ?? this.pharmacies,
      visiblePharmacies: visiblePharmacies ?? this.visiblePharmacies,
      selectedArea: selectedArea ?? this.selectedArea,
      searchText: searchText ?? this.searchText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}