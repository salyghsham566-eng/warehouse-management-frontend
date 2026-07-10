import 'product_model.dart';

class CompanyModel {
  final String name;
  final int productsCount;
  final int offers;
  final String image;
  final List<ProductModel> products;

  const CompanyModel({
    required this.name,
    required this.productsCount,
    required this.offers,
    required this.image,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "productsCount": productsCount,
      "offers": offers,
      "image": image,
      "products": products.map((product) => product.toMap()).toList(),
    };
  }
}