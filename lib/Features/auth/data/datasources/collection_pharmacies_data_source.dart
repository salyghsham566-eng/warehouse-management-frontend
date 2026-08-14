
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/repositories/collection_pharmacies_response.dart';

abstract class CollectionPharmaciesDataSource {
  Future<CollectionPharmaciesResponse>
      getCollectionPharmacies();
        Future<CollectionPharmacyModel>
      getCollectionPharmacyDetails(
    String pharmacyId,
  );
}