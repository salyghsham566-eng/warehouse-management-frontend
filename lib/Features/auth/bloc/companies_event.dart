enum CompanyFilter { all, hasOffers, noOffers, mostProducts }

abstract class CompaniesEvent {}

class CompaniesStarted extends CompaniesEvent {}

class CompaniesSearchChanged extends CompaniesEvent {
  final String searchText;

  CompaniesSearchChanged(this.searchText);
}

class CompaniesFilterChanged extends CompaniesEvent {
  final CompanyFilter filter;

  CompaniesFilterChanged(this.filter);
}
