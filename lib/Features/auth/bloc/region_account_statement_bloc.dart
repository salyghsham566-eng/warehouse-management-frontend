import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_event.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_state.dart';
import 'package:project_2/Features/auth/domain/repositories/region_account_statement_repository.dart';

class RegionAccountStatementBloc extends Bloc<
    RegionAccountStatementEvent,
    RegionAccountStatementState> {
  final RegionAccountStatementRepository repository;

  RegionAccountStatementBloc({
    required this.repository,
  }) : super(
          const RegionAccountStatementInitial(),
        ) {
    on<LoadRegionAccountStatementEvent>(
      _loadStatement,
    );
  }

  Future<void> _loadStatement(
    LoadRegionAccountStatementEvent event,
    Emitter<RegionAccountStatementState> emit,
  ) async {
    try {
      emit(
        const RegionAccountStatementLoading(),
      );

      final statement =
          await repository.getRegionAccountStatement(
        regionId: event.regionId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      if (statement.pharmacies.isEmpty) {
        emit(
          const RegionAccountStatementEmpty(),
        );
        return;
      }

      emit(
        RegionAccountStatementSuccess(
          statement: statement,
        ),
      );
    } catch (error) {
      var message = error.toString();

      if (message.startsWith('Exception: ')) {
        message = message.replaceFirst(
          'Exception: ',
          '',
        );
      }

      emit(
        RegionAccountStatementFailure(
          message: message,
        ),
      );
    }
  }
}