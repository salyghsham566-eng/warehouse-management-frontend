
import 'package:project_2/Features/auth/data/models/company_model.dart';

import 'companies_event.dart';

enum CompaniesStatus {
  initial,
  loading,
  success,
  failure,
}

class CompaniesState {
  final CompaniesStatus status;
  final List<CompanyModel> companies;
  final List<CompanyModel> visibleCompanies;
  final String searchText;
  final CompanyFilter selectedFilter;
  final String? errorMessage;

  const CompaniesState({
    this.status = CompaniesStatus.initial,
    this.companies = const [],
    this.visibleCompanies = const [],
    this.searchText = "",
    this.selectedFilter = CompanyFilter.all,
    this.errorMessage,
  });

  CompaniesState copyWith({
    CompaniesStatus? status,
    List<CompanyModel>? companies,
    List<CompanyModel>? visibleCompanies,
    String? searchText,
    CompanyFilter? selectedFilter,
    String? errorMessage,
  }) {
    return CompaniesState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      visibleCompanies: visibleCompanies ?? this.visibleCompanies,
      searchText: searchText ?? this.searchText,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}