import '../models/pharmacy_model.dart';

class PharmaciesRepository {
  Future<List<PharmacyModel>> getPharmacies() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      PharmacyModel(
        id: 1,
        name: "صيدلية النهدي",
        branch: "فرع الملقا",
        area: "حي الملقا",
        address: "طريق أنس بن مالك، الرياض",
        dueAmount: 1250.00,
        image: "assets/images/pharmacy1.png",
      ),
      PharmacyModel(
        id: 2,
        name: "صيدلية الدواء",
        branch: "فرع الياسمين",
        area: "حي الياسمين",
        address: "شارع التخصصي، الرياض",
        dueAmount: 0.00,
        image: "assets/images/pharmacy2.png",
      ),
      PharmacyModel(
        id: 3,
        name: "صيدلية غاية",
        branch: "المركزية",
        area: "حي الملقا",
        address: "حي قرطبة، الرياض",
        dueAmount: 420.50,
        image: "assets/images/pharmacy3.png",
      ),
    ];
  }
}