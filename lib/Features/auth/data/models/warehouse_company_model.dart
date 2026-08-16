class WarehouseCompanyModel {
  final String id;
  final String name;
  final int? itemsCount;

  const WarehouseCompanyModel({
    required this.id,
    required this.name,
    this.itemsCount,
  });

  factory WarehouseCompanyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = json[key];
        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
      return '';
    }

    int? readNullableInt(
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = json[key];

        if (value is int) {
          return value;
        }

        if (value is num) {
          return value.toInt();
        }

        if (value is String) {
          final parsed = int.tryParse(value.trim());
          if (parsed != null) {
            return parsed;
          }
        }
      }

      return null;
    }

    final name = readString(
      const [
        'name',
        'company_name',
        'companyName',
      ],
    );

    final id = readString(
      const [
        'id',
        'company_id',
        'companyId',
      ],
    );

    return WarehouseCompanyModel(
      id: id.isNotEmpty ? id : name,
      name: name,
      itemsCount: readNullableInt(
        const [
          'items_count',
          'itemsCount',
          'medicines_count',
          'medicinesCount',
          'products_count',
          'productsCount',
        ],
      ),
    );
  }
}
