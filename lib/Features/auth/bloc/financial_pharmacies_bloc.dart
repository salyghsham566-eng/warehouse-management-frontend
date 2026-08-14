import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_event.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_state.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacies_repository.dart';

class FinancialPharmaciesBloc extends Bloc<
    FinancialPharmaciesEvent,
    FinancialPharmaciesState> {
  final FinancialPharmaciesRepository repository;

  FinancialPharmaciesBloc({
    required this.repository,
  }) : super(const FinancialPharmaciesInitial()) {
    on<LoadFinancialPharmaciesEvent>(
      _loadFinancialPharmacies,
    );
  }

  Future<void> _loadFinancialPharmacies(
    LoadFinancialPharmaciesEvent event,
    Emitter<FinancialPharmaciesState> emit,
  ) async {
    try {
      emit(const FinancialPharmaciesLoading());

      final response =
          await repository.getFinancialPharmacies(
        fromDate: event.fromDate,
        toDate: event.toDate,
        regionId: event.regionId,
        sort: event.sort,
      );

      if (response.pharmacies.isEmpty) {
        emit(const FinancialPharmaciesEmpty());
        return;
      }

      emit(
        FinancialPharmaciesSuccess(
          response: response,
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
        FinancialPharmaciesFailure(
          message: message,
        ),
      );
    }
  }
}