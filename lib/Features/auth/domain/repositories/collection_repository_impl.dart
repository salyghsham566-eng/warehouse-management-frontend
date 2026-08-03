import 'package:project_2/Features/auth/data/models/Collection_modle.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_mock_data_source.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_repository.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl(this._mockDataSource);

  final CollectionMockDataSource _mockDataSource;

  @override
  Future<CollectionDashboardModel> getDashboard() async {
    final response = await _mockDataSource.fetchDashboard();

    return CollectionDashboardModel.fromJson(response);
  }
}
