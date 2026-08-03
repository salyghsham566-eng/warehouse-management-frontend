import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

abstract class CollectionPharmacyRepository {
  Future<List<CollectionPharmacyModel>> getPharmacies();
}
