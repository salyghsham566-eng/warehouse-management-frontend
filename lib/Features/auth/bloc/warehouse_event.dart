import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';

abstract class WarehouseEvent {}

// =========================================================
// UC-222
// =========================================================
class LoadWarehouseOverviewEvent
    extends WarehouseEvent {}

// =========================================================
// UC-224
// =========================================================
class LoadWarehouseCompaniesEvent
    extends WarehouseEvent {}
// =========================================================
// UC-225
// =========================================================
class LoadWarehouseCompanyMedicinesEvent
    extends WarehouseEvent {
  final String companyId;
  final String companyName;

  LoadWarehouseCompanyMedicinesEvent({
    required this.companyId,
    required this.companyName,
  });
  
}// =========================================================
// UC-227
// =========================================================
class LoadWarehouseMedicineDetailsEvent
    extends WarehouseEvent {
  final String medicineId;

  LoadWarehouseMedicineDetailsEvent({
    required this.medicineId,
  });
  
}
// =========================================================
// UC-230 + UC-231
// =========================================================
class LoadWarehouseStockItemsEvent
    extends WarehouseEvent {
  final WarehouseStockFilter filter;

  LoadWarehouseStockItemsEvent({
    required this.filter,
  });
}