import 'package:project_2/Features/auth/data/datasources/pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacies_repository.dart';

class PharmaciesRepositoryImpl implements PharmaciesRepository {
  final PharmaciesDataSource dataSource;

  const PharmaciesRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<PharmacyModel>> getPharmacies() {
    return dataSource.getPharmacies();
  }
}