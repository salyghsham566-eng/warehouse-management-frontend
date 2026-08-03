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

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name']?.toString() ?? '',
      productsCount:
          (json['products_count'] as num?)?.toInt() ??
          (json['productsCount'] as num?)?.toInt() ??
          0,
      offers: (json['offers'] as num?)?.toInt() ?? 0,
      image: json['image']?.toString() ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'products_count': productsCount,
      'offers': offers,
      'image': image,
      'products': products
          .map((product) => product.toJson())
          .toList(),
    };
  }

  // مؤقتًا حتى ما تنكسر الملفات القديمة التي تستخدم toMap.
  Map<String, dynamic> toMap() {
    return toJson();
  }
}