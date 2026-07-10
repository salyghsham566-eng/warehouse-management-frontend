import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/companies_event.dart';
import 'package:project_2/Features/auth/bloc/companies_state.dart';
import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/Features/auth/data/repositories/fake_companies_repository.dart';



class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final FakeCompaniesRepository repository;

  CompaniesBloc(this.repository) : super(const CompaniesState()) {
    on<CompaniesStarted>(_onStarted);
    on<CompaniesSearchChanged>(_onSearchChanged);
    on<CompaniesFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(
    CompaniesStarted event,
    Emitter<CompaniesState> emit,
  ) async {
    emit(state.copyWith(status: CompaniesStatus.loading));

    try {
      final companies = await repository.getCompanies();

      emit(
        state.copyWith(
          status: CompaniesStatus.success,
          companies: companies,
          visibleCompanies: _applyFilters(
            companies: companies,
            searchText: state.searchText,
            selectedFilter: state.selectedFilter,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CompaniesStatus.failure,
          errorMessage: "حدث خطأ أثناء تحميل الشركات",
        ),
      );
    }
  }

  void _onSearchChanged(
    CompaniesSearchChanged event,
    Emitter<CompaniesState> emit,
  ) {
    emit(
      state.copyWith(
        searchText: event.searchText,
        visibleCompanies: _applyFilters(
          companies: state.companies,
          searchText: event.searchText,
          selectedFilter: state.selectedFilter,
        ),
      ),
    );
  }

  void _onFilterChanged(
    CompaniesFilterChanged event,
    Emitter<CompaniesState> emit,
  ) {
    emit(
      state.copyWith(
        selectedFilter: event.filter,
        visibleCompanies: _applyFilters(
          companies: state.companies,
          searchText: state.searchText,
          selectedFilter: event.filter,
        ),
      ),
    );
  }

  List<CompanyModel> _applyFilters({
    required List<CompanyModel> companies,
    required String searchText,
    required CompanyFilter selectedFilter,
  }) {
    final text = searchText.trim().toLowerCase();

    List<CompanyModel> result = companies.where((company) {
      return company.name.toLowerCase().contains(text);
    }).toList();

    switch (selectedFilter) {
      case CompanyFilter.hasOffers:
        result = result.where((company) => company.offers > 0).toList();
        break;

      case CompanyFilter.noOffers:
        result = result.where((company) => company.offers == 0).toList();
        break;

      case CompanyFilter.mostProducts:
        result.sort(
          (a, b) => b.productsCount.compareTo(a.productsCount),
        );
        break;

      case CompanyFilter.all:
        break;
    }

    return result;
  }
}