import 'package:project_2/Features/auth/data/datasources/collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_phermacy_repository.dart';

class CollectionRepositoryImpl
    implements CollectionRepository {
  const CollectionRepositoryImpl({
    required this.dataSource,
  });

  final CollectionPharmaciesDataSource dataSource;

  @override
  Future<List<CollectionPharmacyModel>>
      getCollectionPharmacies() async {
    final response =
        await dataSource.getCollectionPharmacies();

    if (!response.success) {
      throw Exception(
        response.message.trim().isNotEmpty
            ? response.message
            : 'فشل تحميل الصيدليات',
      );
    }

    return response.pharmacies;
  }
  @override
Future<CollectionPharmacyModel>
    getCollectionPharmacyDetails(
  String pharmacyId,
) async {
  return dataSource.getCollectionPharmacyDetails(
    pharmacyId,
  );
}
}