class BasicOfferModel {
  final bool isActive;
  final int buyQuantity;
  final int freeQuantity;

  const BasicOfferModel({
    required this.isActive,
    required this.buyQuantity,
    required this.freeQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      "isActive": isActive,
      "buyQuantity": buyQuantity,
      "freeQuantity": freeQuantity,
    };
  }
}

class ProductModel {
  final String name;
  final String scientificName;
  final String description;
  final String expiry;
  final double price;
  final double? oldPrice;
  final String image;
  final BasicOfferModel? basicOffer;

  const ProductModel({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.expiry,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.basicOffer,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "scientificName": scientificName,
      "description": description,
      "expiry": expiry,
      "price": price,
      "oldPrice": oldPrice,
      "image": image,
      "basicOffer": basicOffer?.toMap(),
    };
  }
}