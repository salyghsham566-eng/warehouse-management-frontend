import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_event.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_state.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_dashboard_repository.dart';

class FinancialDashboardBloc
    extends Bloc<FinancialDashboardEvent, FinancialDashboardState> {
  final FinancialDashboardRepository repository;

  FinancialDashboardBloc({
    required this.repository,
  }) : super(const FinancialDashboardInitial()) {
    on<LoadFinancialDashboardEvent>(_loadFinancialDashboard);
  }

  Future<void> _loadFinancialDashboard(
    LoadFinancialDashboardEvent event,
    Emitter<FinancialDashboardState> emit,
  ) async {
    try {
      emit(const FinancialDashboardLoading());

      final dashboard = await repository.getFinancialDashboard(
        fromDate: event.fromDate,
        toDate: event.toDate,
        regionId: event.regionId,
      );

      if (dashboard.metrics.isEmpty) {
        emit(const FinancialDashboardEmpty());
        return;
      }

      emit(
        FinancialDashboardSuccess(
          dashboard: dashboard,
        ),
      );
    } catch (error) {
      emit(
        FinancialDashboardFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }
}