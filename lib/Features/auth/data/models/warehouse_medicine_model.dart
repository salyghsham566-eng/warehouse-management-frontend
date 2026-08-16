class WarehouseMedicineModel {
  final String id;
  final String tradeName;
  final String scientificName;

  const WarehouseMedicineModel({
    required this.id,
    required this.tradeName,
    required this.scientificName,
  });

  factory WarehouseMedicineModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
      return '';
    }

    final tradeName = readString(
      const [
        'trade_name',
        'tradeName',
        'name',
        'product_name',
        'productName',
      ],
    );

    final scientificName = readString(
      const [
        'scientific_name',
        'scientificName',
        'generic_name',
        'genericName',
      ],
    );

    final id = readString(
      const [
        'id',
        'medicine_id',
        'medicineId',
        'product_id',
        'productId',
      ],
    );

    return WarehouseMedicineModel(
      id: id.isNotEmpty ? id : tradeName,
      tradeName: tradeName,
      scientificName: scientificName,
    );
  }
}
