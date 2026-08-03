import 'package:project_2/Features/auth/data/datasources/companies_datasource.dart';
import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/Features/auth/domain/repositories/companies_repository.dart';

class CompaniesRepositoryImpl implements CompaniesRepository {
  final CompaniesDataSource dataSource;

  const CompaniesRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<CompanyModel>> getCompanies() {
    return dataSource.getCompanies();
  }
}