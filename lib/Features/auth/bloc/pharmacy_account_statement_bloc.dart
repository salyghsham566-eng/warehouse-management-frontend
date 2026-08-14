import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_event.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_state.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacy_account_statement_repository.dart';

class PharmacyAccountStatementBloc extends Bloc<
    PharmacyAccountStatementEvent,
    PharmacyAccountStatementState> {
  final PharmacyAccountStatementRepository repository;

  PharmacyAccountStatementBloc({
    required this.repository,
  }) : super(
          const PharmacyAccountStatementInitial(),
        ) {
    on<LoadPharmacyAccountStatementEvent>(
      _loadStatement,
    );
  }

  Future<void> _loadStatement(
    LoadPharmacyAccountStatementEvent event,
    Emitter<PharmacyAccountStatementState> emit,
  ) async {
    try {
      emit(
        const PharmacyAccountStatementLoading(),
      );

      final statement =
          await repository.getPharmacyAccountStatement(
        pharmacyId: event.pharmacyId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      emit(
        PharmacyAccountStatementSuccess(
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
        PharmacyAccountStatementFailure(
          message: message,
        ),
      );
    }
  }
}