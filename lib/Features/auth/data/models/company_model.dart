import 'product_model.dart';

class CompanyModel {
  final int id;
  final String name;
  final int productsCount;
  final int offers;
  final String image;
  final List<ProductModel> products;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.productsCount,
    required this.offers,
    required this.image,
    required this.products,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: _parseInt(
        json['id'] ?? json['company_id'] ?? json['companyId'],
      ),
      name: json['name']?.toString() ?? '',
      productsCount:
          (json['products_count'] as num?)?.toInt() ??
          (json['productsCount'] as num?)?.toInt() ??
          0,
      offers: (json['offers'] as num?)?.toInt() ?? 0,
      image: (
        json['image'] ??
        json['image_url'] ??
        json['imageUrl']
      )?.toString() ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (item) => ProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'products_count': productsCount,
      'offers': offers,
      'image': image,
      'products': products
          .map((product) => product.toJson())
          .toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
