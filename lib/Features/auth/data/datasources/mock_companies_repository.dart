import 'package:project_2/Features/auth/data/datasources/companies_datasource.dart';
import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/Features/auth/data/models/product_model.dart';

class MockCompaniesDataSource implements CompaniesDataSource {
  @override
  Future<List<CompanyModel>> getCompanies() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    return const [
      CompanyModel(
        id: 1,
        name: 'GSK العالمية',
        productsCount: 450,
        offers: 5,
        image: 'assets/images/gsk.png',
        products: [
          ProductModel(
            id: 101,
            name: 'أوغمنتين 1 جم',
            scientificName: 'Amoxicillin / Clavulanic Acid',
            description: '14 حبة',
            expiry: '12/2027',
            price: 85.50,
            oldPrice: 95.00,
            image: 'assets/images/augmentin.png',
            basicOffer: null,
          ),
          ProductModel(
            id: 102,
            name: 'فولتارين جل',
            scientificName: 'Diclofenac',
            description: 'أنبوب 50 غرام',
            expiry: '08/2028',
            price: 22.00,
            oldPrice: null,
            image: 'assets/images/voltaren.png',
            basicOffer: BasicOfferModel(
              isActive: true,
              buyQuantity: 10,
              freeQuantity: 2,
            ),
          ),
        ],
      ),
      CompanyModel(
        id: 2,
        name: 'حما فارما',
        productsCount: 1200,
        offers: 0,
        image: 'assets/images/hama.png',
        products: [
          ProductModel(
            id: 103,
            name: 'باراسيتامول',
            scientificName: 'Paracetamol',
            description: '20 حبة - 500 ملغ',
            expiry: '06/2028',
            price: 12.50,
            oldPrice: null,
            image: 'assets/images/paracetamol.png',
            basicOffer: BasicOfferModel(
              isActive: true,
              buyQuantity: 10,
              freeQuantity: 2,
            ),
          ),
          ProductModel(
            id: 104,
            name: 'أموكسيسيلين',
            scientificName: 'Amoxicillin',
            description: 'كبسولات 500 ملغ',
            expiry: '09/2027',
            price: 28.00,
            oldPrice: null,
            image: 'assets/images/amoxicillin.png',
            basicOffer: null,
          ),
        ],
      ),
    ];
  }
}
