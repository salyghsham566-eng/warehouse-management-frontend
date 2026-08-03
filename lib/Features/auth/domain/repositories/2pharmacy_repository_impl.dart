import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/2pharmacy_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacy_mock_data_source.dart';

class CollectionPharmacyRepositoryImpl implements CollectionPharmacyRepository {
  CollectionPharmacyRepositoryImpl(this._dataSource);

  final CollectionPharmacyMockDataSource _dataSource;

  @override
  Future<List<CollectionPharmacyModel>> getPharmacies() async {
    final response = await _dataSource.fetchPharmacies();

    return response
        .map(CollectionPharmacyModel.fromJson)
        .toList(growable: false);
  }
}
