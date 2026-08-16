import 'dart:typed_data';

import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_event.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';

abstract class WarehouseInventoryFileState {}

class WarehouseInventoryFileInitial
    extends WarehouseInventoryFileState {}

class WarehouseInventoryFileLoading
    extends WarehouseInventoryFileState {}

class WarehouseInventoryFileLoaded
    extends WarehouseInventoryFileState {
  final WarehouseInventoryFileModel? file;

  WarehouseInventoryFileLoaded({
    required this.file,
  });
}

class WarehouseInventoryFileFailure
    extends WarehouseInventoryFileState {
  final String message;

  WarehouseInventoryFileFailure({
    required this.message,
  });
}

class WarehouseInventoryPdfLoading
    extends WarehouseInventoryFileState {
  final WarehouseInventoryFileModel file;
  final WarehouseInventoryPdfAction action;

  WarehouseInventoryPdfLoading({
    required this.file,
    required this.action,
  });
}

class WarehouseInventoryPdfReady
    extends WarehouseInventoryFileState {
  final WarehouseInventoryFileModel file;
  final WarehouseInventoryPdfAction action;
  final Uint8List bytes;

  WarehouseInventoryPdfReady({
    required this.file,
    required this.action,
    required this.bytes,
  });
}

class WarehouseInventoryPdfFailure
    extends WarehouseInventoryFileState {
  final WarehouseInventoryFileModel file;
  final String message;

  WarehouseInventoryPdfFailure({
    required this.file,
    required this.message,
  });
}
