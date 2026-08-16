import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

abstract class RepresentativePharmaciesDataSource {
  Future<RepresentativePharmaciesResponseModel>
      getRepresentativePharmacies({
    required String month,
  });// =========================================================
// UC-242 -> UC-245
// =========================================================
Future<RepresentativePharmacyDetailsModel>
    getRepresentativePharmacyDetails(
  String pharmacyId,
);
}
