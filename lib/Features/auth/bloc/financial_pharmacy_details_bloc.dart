import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_event.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacy_details_repository.dart';

class FinancialPharmacyDetailsBloc extends Bloc<
    FinancialPharmacyDetailsEvent,
    FinancialPharmacyDetailsState> {
  final FinancialPharmacyDetailsRepository repository;

  FinancialPharmacyDetailsBloc({
    required this.repository,
  }) : super(
          const FinancialPharmacyDetailsInitial(),
        ) {
    on<LoadFinancialPharmacyDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadFinancialPharmacyDetailsEvent event,
    Emitter<FinancialPharmacyDetailsState> emit,
  ) async {
    try {
      emit(
        const FinancialPharmacyDetailsLoading(),
      );

      final details =
          await repository.getFinancialPharmacyDetails(
        pharmacyId: event.pharmacyId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      emit(
        FinancialPharmacyDetailsSuccess(
          details: details,
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
        FinancialPharmacyDetailsFailure(
          message: message,
        ),
      );
    }
  }
}