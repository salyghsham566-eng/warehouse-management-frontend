abstract class RepresentativePharmacyDetailsEvent {
  const RepresentativePharmacyDetailsEvent();
}

class LoadRepresentativePharmacyDetailsEvent
    extends RepresentativePharmacyDetailsEvent {
  final String pharmacyId;

  const LoadRepresentativePharmacyDetailsEvent({
    required this.pharmacyId,
  });
}
