class WarehouseOverviewModel {
  final bool hasLowStockItems;
  final bool hasOutOfStockItems;
  final bool hasInventoryFile;
  final String? inventoryFileName;

  const WarehouseOverviewModel({
    required this.hasLowStockItems,
    required this.hasOutOfStockItems,
    required this.hasInventoryFile,
    this.inventoryFileName,
  });

  factory WarehouseOverviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    bool readBool(
      List<String> keys, {
      bool fallback = false,
    }) {
      for (final key in keys) {
        final value = json[key];

        if (value is bool) {
          return value;
        }

        if (value is num) {
          return value != 0;
        }

        if (value is String) {
          final normalized = value.trim().toLowerCase();

          if (normalized == 'true' ||
              normalized == '1' ||
              normalized == 'yes') {
            return true;
          }

          if (normalized == 'false' ||
              normalized == '0' ||
              normalized == 'no') {
            return false;
          }
        }
      }

      return fallback;
    }

    String? readString(
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = json[key];

        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }

      return null;
    }

    return WarehouseOverviewModel(
      hasLowStockItems: readBool(
        const [
          'has_low_stock_items',
          'hasLowStockItems',
          'has_low_stock',
        ],
      ),
      hasOutOfStockItems: readBool(
        const [
          'has_out_of_stock_items',
          'hasOutOfStockItems',
          'has_out_of_stock',
        ],
      ),
      hasInventoryFile: readBool(
        const [
          'has_inventory_file',
          'hasInventoryFile',
          'inventory_file_available',
        ],
      ),
      inventoryFileName: readString(
        const [
          'inventory_file_name',
          'inventoryFileName',
          'file_name',
        ],
      ),
    );
  }
}
