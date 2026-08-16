abstract class RepresentativePharmaciesEvent {
  const RepresentativePharmaciesEvent();
}

class RepresentativePharmaciesStarted
    extends RepresentativePharmaciesEvent {
  final String month;

  const RepresentativePharmaciesStarted({
    required this.month,
  });
}

class RepresentativePharmaciesSearchChanged
    extends RepresentativePharmaciesEvent {
  final String searchText;

  const RepresentativePharmaciesSearchChanged(
    this.searchText,
  );
}

class RepresentativePharmaciesRegionChanged
    extends RepresentativePharmaciesEvent {
  final String region;

  const RepresentativePharmaciesRegionChanged(
    this.region,
  );
}

class RepresentativePharmaciesDateRangeChanged
    extends RepresentativePharmaciesEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  const RepresentativePharmaciesDateRangeChanged({
    required this.fromDate,
    required this.toDate,
  });
}

class RepresentativePharmaciesMonthChanged
    extends RepresentativePharmaciesEvent {
  final String month;

  const RepresentativePharmaciesMonthChanged(
    this.month,
  );
}
