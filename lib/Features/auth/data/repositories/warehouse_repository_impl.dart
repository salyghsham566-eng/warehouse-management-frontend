import 'dart:typed_data';

import 'package:project_2/Features/auth/data/datasources/warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';
import 'package:project_2/Features/auth/domain/repositories/warehouse_repository.dart';

class WarehouseRepositoryImpl
    implements WarehouseRepository {
  final WarehouseDataSource dataSource;

  const WarehouseRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<WarehouseOverviewModel>
      getWarehouseOverview() {
    return dataSource
        .getWarehouseOverview();
  }

  @override
  Future<List<WarehouseCompanyModel>>
      getWarehouseCompanies() {
    return dataSource
        .getWarehouseCompanies();
  }
  @override
Future<List<WarehouseMedicineModel>>
    getWarehouseCompanyMedicines(
  String companyId,
) {
  return dataSource.getWarehouseCompanyMedicines(
    companyId,
  );
}@override
Future<WarehouseMedicineDetailsModel>
    getWarehouseMedicineDetails(
  String medicineId,
) {
  return dataSource.getWarehouseMedicineDetails(
    medicineId,
  );
}@override
Future<List<WarehouseStockItemModel>>
    getWarehouseStockItems(
  WarehouseStockFilter filter,
) {
  return dataSource.getWarehouseStockItems(
    filter,
  );
}@override
Future<WarehouseInventoryFileModel?>
    getWarehouseInventoryFile() {
  return dataSource.getWarehouseInventoryFile();
}

@override
Future<Uint8List> getWarehouseInventoryPdf(
  String fileId,
) {
  return dataSource.getWarehouseInventoryPdf(
    fileId,
  );
}
}
