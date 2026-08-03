import 'package:project_2/Features/auth/data/datasources/pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_model.dart';

class MockPharmaciesDataSource implements PharmaciesDataSource {
  @override
  Future<List<PharmacyModel>> getPharmacies() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    return const [
      PharmacyModel(
        id: 1,
        name: 'صيدلية النهدي',
        branch: 'فرع الملقا',
        area: 'حي الملقا',
        address: 'طريق أنس بن مالك، الرياض',
        dueAmount: 1250.00,
        image: 'assets/photo_٢٠٢٦-٠٦-٢٢_٢٣-٠٨-٣٦.jpg',
      ),
      PharmacyModel(
        id: 2,
        name: 'صيدلية الدواء',
        branch: 'فرع الياسمين',
        area: 'حي الياسمين',
        address: 'شارع التخصصي، الرياض',
        dueAmount: 0.00,
        image: 'assets/photo_٢٠٢٦-٠٦-٢٢_٢٣-٠٨-٣٦.jpg',
      ),
      PharmacyModel(
        id: 3,
        name: 'صيدلية غاية',
        branch: 'المركزية',
        area: 'حي الملقا',
        address: 'حي قرطبة، الرياض',
        dueAmount: 420.50,
        image: 'assets/photo_٢٠٢٦-٠٦-٢٢_٢٣-٠٨-٣٦.jpg',
      ),
    ];
  }
}