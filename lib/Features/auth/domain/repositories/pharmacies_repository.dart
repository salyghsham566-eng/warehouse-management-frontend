import 'package:project_2/Features/auth/data/models/pharmacy_model.dart';

abstract class PharmaciesRepository {
  Future<List<PharmacyModel>> getPharmacies();
}