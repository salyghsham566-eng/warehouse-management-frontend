import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';

abstract class WarehouseState {}

class WarehouseInitial
    extends WarehouseState {}

// =========================================================
// UC-222
// =========================================================
class WarehouseLoading
    extends WarehouseState {}

class WarehouseSuccess
    extends WarehouseState {
  final WarehouseOverviewModel overview;

  WarehouseSuccess({
    required this.overview,
  });
}

class WarehouseFailure
    extends WarehouseState {
  final String message;

  WarehouseFailure({
    required this.message,
  });
}

// =========================================================
// UC-224
// =========================================================
class WarehouseCompaniesLoading
    extends WarehouseState {}

class WarehouseCompaniesSuccess
    extends WarehouseState {
  final List<WarehouseCompanyModel> companies;

  WarehouseCompaniesSuccess({
    required this.companies,
  });
}

class WarehouseCompaniesFailure
    extends WarehouseState {
  final String message;

  WarehouseCompaniesFailure({
    required this.message,
  });
}// =========================================================
// UC-225
// =========================================================
class WarehouseCompanyMedicinesLoading
    extends WarehouseState {}

class WarehouseCompanyMedicinesSuccess
    extends WarehouseState {
  final String companyName;
  final List<WarehouseMedicineModel> medicines;

  WarehouseCompanyMedicinesSuccess({
    required this.companyName,
    required this.medicines,
  });
}

class WarehouseCompanyMedicinesFailure
    extends WarehouseState {
  final String message;

  WarehouseCompanyMedicinesFailure({
    required this.message,
  });
}
// =========================================================
// UC-227
// =========================================================
class WarehouseMedicineDetailsLoading
    extends WarehouseState {}

class WarehouseMedicineDetailsSuccess
    extends WarehouseState {
  final WarehouseMedicineDetailsModel details;

  WarehouseMedicineDetailsSuccess({
    required this.details,
  });
}

class WarehouseMedicineDetailsFailure
    extends WarehouseState {
  final String message;

  WarehouseMedicineDetailsFailure({
    required this.message,
  });
}// =========================================================
// UC-230 + UC-231
// =========================================================
class WarehouseStockItemsLoading
    extends WarehouseState {}

class WarehouseStockItemsSuccess
    extends WarehouseState {
  final WarehouseStockFilter filter;
  final List<WarehouseStockItemModel> items;

  WarehouseStockItemsSuccess({
    required this.filter,
    required this.items,
  });
}

class WarehouseStockItemsFailure
    extends WarehouseState {
  final String message;

  WarehouseStockItemsFailure({
    required this.message,
  });
}