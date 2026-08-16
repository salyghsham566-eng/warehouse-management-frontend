import 'dart:typed_data';

import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';

abstract class WarehouseDataSource {
  // =========================================================
  // UC-222
  // =========================================================
  Future<WarehouseOverviewModel>
      getWarehouseOverview();

  // =========================================================
  // UC-224
  // =========================================================
  Future<List<WarehouseCompanyModel>>
      getWarehouseCompanies();
      // =========================================================
// UC-225
// =========================================================
Future<List<WarehouseMedicineModel>>
    getWarehouseCompanyMedicines(
  String companyId,
);// =========================================================
// UC-227
// =========================================================
Future<WarehouseMedicineDetailsModel>
    getWarehouseMedicineDetails(
  String medicineId,
);// =========================================================
// UC-230 + UC-231
// =========================================================
Future<List<WarehouseStockItemModel>>
    getWarehouseStockItems(
  WarehouseStockFilter filter,
);// =========================================================
// UC-232 -> UC-234
// =========================================================
Future<WarehouseInventoryFileModel?>
    getWarehouseInventoryFile();

Future<Uint8List> getWarehouseInventoryPdf(
  String fileId,
);
}
