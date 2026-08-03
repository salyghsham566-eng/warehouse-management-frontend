abstract class PharmaciesEvent {
  const PharmaciesEvent();
}

class PharmaciesStarted extends PharmaciesEvent {
  const PharmaciesStarted();
}

class PharmaciesSearchChanged extends PharmaciesEvent {
  final String searchText;

  const PharmaciesSearchChanged(this.searchText);
}

class PharmaciesAreaChanged extends PharmaciesEvent {
  final String area;

  const PharmaciesAreaChanged(this.area);
}