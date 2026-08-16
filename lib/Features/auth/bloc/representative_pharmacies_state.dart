import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';

enum RepresentativePharmaciesStatus {
  initial,
  loading,
  success,
  failure,
}

class RepresentativePharmaciesState {
  final RepresentativePharmaciesStatus status;

  final List<RepresentativePharmacyModel>
      pharmacies;

  final List<RepresentativePharmacyModel>
      visiblePharmacies;

  final Map<String, int> regionCounts;

  final String selectedRegion;
  final String searchText;

  final DateTime? fromDate;
  final DateTime? toDate;

  final String selectedMonth;

  final double? totalTarget;

  final Map<String, double>
      regionTargets;

  final String errorMessage;

  const RepresentativePharmaciesState({
    this.status =
        RepresentativePharmaciesStatus.initial,
    this.pharmacies = const [],
    this.visiblePharmacies = const [],
    this.regionCounts = const {},
    this.selectedRegion = 'الكل',
    this.searchText = '',
    this.fromDate,
    this.toDate,
    this.selectedMonth = '',
    this.totalTarget,
    this.regionTargets = const {},
    this.errorMessage = '',
  });

  List<String> get regions =>
      regionCounts.keys.toList();

  int get totalLinkedCount =>
      pharmacies.length;

  int get visibleCount =>
      visiblePharmacies.length;

  double? get selectedRegionTarget {
    if (selectedRegion == 'الكل') {
      return null;
    }

    return regionTargets[
        selectedRegion];
  }
}
