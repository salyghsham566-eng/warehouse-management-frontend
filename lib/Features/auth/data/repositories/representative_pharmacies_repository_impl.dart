import 'package:project_2/Features/auth/data/datasources/representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';
import 'package:project_2/Features/auth/domain/repositories/representative_pharmacies_repository.dart';

class RepresentativePharmaciesRepositoryImpl
    implements RepresentativePharmaciesRepository {
  final RepresentativePharmaciesDataSource
      dataSource;

  const RepresentativePharmaciesRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<RepresentativePharmaciesResponseModel>
      getRepresentativePharmacies({
    required String month,
  }) {
    return dataSource
        .getRepresentativePharmacies(
      month: month,
    );
  }
  @override
Future<RepresentativePharmacyDetailsModel>
    getRepresentativePharmacyDetails(
  String pharmacyId,
) {
  return dataSource
      .getRepresentativePharmacyDetails(
    pharmacyId,
  );
}
}
