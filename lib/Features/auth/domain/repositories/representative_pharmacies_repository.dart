import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

abstract class RepresentativePharmaciesRepository {
  Future<RepresentativePharmaciesResponseModel>
      getRepresentativePharmacies({
    required String month,
  });Future<RepresentativePharmacyDetailsModel>
    getRepresentativePharmacyDetails(
  String pharmacyId,
);
}
