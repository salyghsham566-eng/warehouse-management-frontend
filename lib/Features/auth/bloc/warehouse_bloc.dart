import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/warehouse_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_state.dart';
import 'package:project_2/Features/auth/domain/repositories/warehouse_repository.dart';

class WarehouseBloc
    extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseRepository repository;

  WarehouseBloc({
    required this.repository,
  }) : super(
          WarehouseInitial(),
        ) {
    on<LoadWarehouseOverviewEvent>(
      _loadOverview,
    );
    on<LoadWarehouseCompaniesEvent>(
      _loadCompanies,
    );
    on<LoadWarehouseCompanyMedicinesEvent>(
  _loadCompanyMedicines,
);
on<LoadWarehouseMedicineDetailsEvent>(
  _loadMedicineDetails,
);on<LoadWarehouseStockItemsEvent>(
  _loadStockItems,
);
  }

  Future<void> _loadOverview(
    LoadWarehouseOverviewEvent event,
    Emitter<WarehouseState> emit,
  ) async {
    emit(
      WarehouseLoading(),
    );

    try {
      final overview =
          await repository
              .getWarehouseOverview();

      emit(
        WarehouseSuccess(
          overview: overview,
        ),
      );
    } catch (error) {
      emit(
        WarehouseFailure(
          message: _cleanError(error),
        ),
      );
    }
  }

  Future<void> _loadCompanies(
    LoadWarehouseCompaniesEvent event,
    Emitter<WarehouseState> emit,
  ) async {
    emit(
      WarehouseCompaniesLoading(),
    );

    try {
      final companies =
          await repository
              .getWarehouseCompanies();

      emit(
        WarehouseCompaniesSuccess(
          companies: companies,
        ),
      );
    } catch (error) {
      emit(
        WarehouseCompaniesFailure(
          message: _cleanError(error),
        ),
      );
    }
  }
Future<void> _loadCompanyMedicines(
  LoadWarehouseCompanyMedicinesEvent event,
  Emitter<WarehouseState> emit,
) async {
  emit(
    WarehouseCompanyMedicinesLoading(),
  );

  try {
    final medicines =
        await repository.getWarehouseCompanyMedicines(
      event.companyId,
    );

    emit(
      WarehouseCompanyMedicinesSuccess(
        companyName: event.companyName,
        medicines: medicines,
      ),
    );
  } catch (error) {
    emit(
      WarehouseCompanyMedicinesFailure(
        message: _cleanError(error),
      ),
    );
  }
}Future<void> _loadMedicineDetails(
  LoadWarehouseMedicineDetailsEvent event,
  Emitter<WarehouseState> emit,
) async {
  emit(
    WarehouseMedicineDetailsLoading(),
  );

  try {
    final details =
        await repository.getWarehouseMedicineDetails(
      event.medicineId,
    );

    emit(
      WarehouseMedicineDetailsSuccess(
        details: details,
      ),
    );
  } catch (error) {
    emit(
      WarehouseMedicineDetailsFailure(
        message: _cleanError(error),
      ),
    );
  }
}Future<void> _loadStockItems(
  LoadWarehouseStockItemsEvent event,
  Emitter<WarehouseState> emit,
) async {
  emit(
    WarehouseStockItemsLoading(),
  );

  try {
    final items =
        await repository.getWarehouseStockItems(
      event.filter,
    );

    emit(
      WarehouseStockItemsSuccess(
        filter: event.filter,
        items: items,
      ),
    );
  } catch (error) {
    emit(
      WarehouseStockItemsFailure(
        message: _cleanError(error),
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
