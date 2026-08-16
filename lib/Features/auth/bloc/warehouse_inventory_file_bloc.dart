import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/domain/repositories/warehouse_repository.dart';

class WarehouseInventoryFileBloc extends Bloc<
    WarehouseInventoryFileEvent,
    WarehouseInventoryFileState> {
  final WarehouseRepository repository;

  WarehouseInventoryFileBloc({
    required this.repository,
  }) : super(
          WarehouseInventoryFileInitial(),
        ) {
    on<LoadWarehouseInventoryFileEvent>(
      _loadFile,
    );

    on<LoadWarehouseInventoryPdfEvent>(
      _loadPdf,
    );
  }

  WarehouseInventoryFileModel? _currentFile;

  Future<void> _loadFile(
    LoadWarehouseInventoryFileEvent event,
    Emitter<WarehouseInventoryFileState> emit,
  ) async {
    emit(
      WarehouseInventoryFileLoading(),
    );

    try {
      final file =
          await repository.getWarehouseInventoryFile();

      _currentFile = file;

      emit(
        WarehouseInventoryFileLoaded(
          file: file,
        ),
      );
    } catch (error) {
      emit(
        WarehouseInventoryFileFailure(
          message: _cleanError(error),
        ),
      );
    }
  }

  Future<void> _loadPdf(
    LoadWarehouseInventoryPdfEvent event,
    Emitter<WarehouseInventoryFileState> emit,
  ) async {
    final file = _currentFile;

    if (file == null) {
      emit(
        WarehouseInventoryFileFailure(
          message: 'لا يوجد ملف جرد متاح',
        ),
      );
      return;
    }

    emit(
      WarehouseInventoryPdfLoading(
        file: file,
        action: event.action,
      ),
    );

    try {
      final bytes =
          await repository.getWarehouseInventoryPdf(
        event.fileId,
      );

      emit(
        WarehouseInventoryPdfReady(
          file: file,
          action: event.action,
          bytes: bytes,
        ),
      );

      // نعيد حالة عرض الملف بعد تنفيذ الإجراء
      // حتى تبقى الشاشة مستقرة.
      emit(
        WarehouseInventoryFileLoaded(
          file: file,
        ),
      );
    } catch (error) {
      emit(
        WarehouseInventoryPdfFailure(
          file: file,
          message: _cleanError(error),
        ),
      );

      emit(
        WarehouseInventoryFileLoaded(
          file: file,
        ),
      );
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}
