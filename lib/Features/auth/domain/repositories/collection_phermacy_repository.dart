
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

abstract class CollectionRepository {
  Future<List<CollectionPharmacyModel>> getCollectionPharmacies();
 Future<CollectionPharmacyModel>
      getCollectionPharmacyDetails(
    String pharmacyId,
  );}