import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_event.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_indicator_details_repository.dart';

class FinancialIndicatorDetailsBloc extends Bloc<
    FinancialIndicatorDetailsEvent,
    FinancialIndicatorDetailsState> {
  final FinancialIndicatorDetailsRepository repository;

  FinancialIndicatorDetailsBloc({
    required this.repository,
  }) : super(const FinancialIndicatorDetailsInitial()) {
    on<LoadFinancialIndicatorDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadFinancialIndicatorDetailsEvent event,
    Emitter<FinancialIndicatorDetailsState> emit,
  ) async {
    try {
      emit(const FinancialIndicatorDetailsLoading());

      final response =
          await repository.getIndicatorDetails(
        indicatorId: event.indicatorId,
        fromDate: event.fromDate,
        toDate: event.toDate,
        regionId: event.regionId,
      );

      emit(
        FinancialIndicatorDetailsSuccess(
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
        FinancialIndicatorDetailsFailure(
          message: message,
        ),
      );
    }
  }
}