abstract class PharmaciesEvent {}

class PharmaciesStarted extends PharmaciesEvent {}

class PharmaciesSearchChanged extends PharmaciesEvent {
  final String searchText;

  PharmaciesSearchChanged(this.searchText);
}

class PharmaciesAreaChanged extends PharmaciesEvent {
  final String area;

  PharmaciesAreaChanged(this.area);
}