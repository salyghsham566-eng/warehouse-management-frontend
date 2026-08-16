abstract class WarehouseInventoryFileEvent {}

class LoadWarehouseInventoryFileEvent
    extends WarehouseInventoryFileEvent {}

enum WarehouseInventoryPdfAction {
  preview,
  download,
}

class LoadWarehouseInventoryPdfEvent
    extends WarehouseInventoryFileEvent {
  final String fileId;
  final WarehouseInventoryPdfAction action;

  LoadWarehouseInventoryPdfEvent({
    required this.fileId,
    required this.action,
  });
}
