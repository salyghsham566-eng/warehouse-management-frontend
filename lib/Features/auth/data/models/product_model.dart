class BasicOfferModel {
  final bool isActive;
  final int buyQuantity;
  final int freeQuantity;
  

  const BasicOfferModel({
    required this.isActive,
    required this.buyQuantity,
    required this.freeQuantity,
  });

  factory BasicOfferModel.fromJson(Map<String, dynamic> json) {
    return BasicOfferModel(
      isActive: _parseBool(
        json['is_active'] ?? json['isActive'],
      ),
      buyQuantity: _parseInt(
        json['buy_quantity'] ?? json['buyQuantity'],
      ),
      freeQuantity: _parseInt(
        json['free_quantity'] ?? json['freeQuantity'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'buy_quantity': buyQuantity,
      'free_quantity': freeQuantity,
    };
  }

  // مؤقتًا حتى لا تنكسر الملفات القديمة.
  Map<String, dynamic> toMap() {
    return toJson();
  }
}

class ProductModel {
  final int id;
  final String name;
  final String scientificName;
  final String description;
  final String expiry;
  final double price;
  final double? oldPrice;
  final String image;
  final BasicOfferModel? basicOffer;

  const ProductModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.expiry,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.basicOffer,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic basicOfferData =
        json['basic_offer'] ?? json['basicOffer'];

    return ProductModel(
        id: _parseInt(
      json['id'] ?? json['product_id'] ?? json['productId'],
    ),
      name: json['name']?.toString() ?? '',
      scientificName:
          (json['scientific_name'] ?? json['scientificName'])
                  ?.toString() ??
              '',
      description: json['description']?.toString() ?? '',
      expiry: json['expiry']?.toString() ?? '',
      price: _parseDouble(json['price']),
      oldPrice: _parseNullableDouble(
        json['old_price'] ?? json['oldPrice'],
      ),
     image:
    (
      json['image'] ??
      json['image_url'] ??
      json['imageUrl']
    )?.toString() ??
    '',
      basicOffer: basicOfferData is Map<String, dynamic>
          ? BasicOfferModel.fromJson(basicOfferData)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'expiry': expiry,
      'price': price,
      'old_price': oldPrice,
      'image': image,
      'basic_offer': basicOffer?.toJson(),
    };
  }

  // مؤقتًا حتى لا تنكسر الملفات القديمة.
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

double _parseDouble(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalizedValue = value?.toString().toLowerCase();

  return normalizedValue == 'true' ||
      normalizedValue == '1' ||
      normalizedValue == 'yes';
}