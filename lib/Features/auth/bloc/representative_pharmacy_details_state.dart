import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

abstract class RepresentativePharmacyDetailsState {
  const RepresentativePharmacyDetailsState();
}

class RepresentativePharmacyDetailsInitial
    extends RepresentativePharmacyDetailsState {
  const RepresentativePharmacyDetailsInitial();
}

class RepresentativePharmacyDetailsLoading
    extends RepresentativePharmacyDetailsState {
  const RepresentativePharmacyDetailsLoading();
}

class RepresentativePharmacyDetailsSuccess
    extends RepresentativePharmacyDetailsState {
  final RepresentativePharmacyDetailsModel
      details;

  const RepresentativePharmacyDetailsSuccess({
    required this.details,
  });
}

class RepresentativePharmacyDetailsFailure
    extends RepresentativePharmacyDetailsState {
  final String message;

  const RepresentativePharmacyDetailsFailure({
    required this.message,
  });
}
