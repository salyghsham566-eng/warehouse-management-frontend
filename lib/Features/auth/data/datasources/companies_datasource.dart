

import 'package:project_2/Features/auth/data/models/company_model.dart';

abstract class CompaniesDataSource {
  Future<List<CompanyModel>> getCompanies();
}