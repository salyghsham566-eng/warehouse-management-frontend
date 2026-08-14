import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';

abstract class FinancialDashboardState extends Equatable {
  const FinancialDashboardState();

  @override
  List<Object?> get props => [];
}

class FinancialDashboardInitial extends FinancialDashboardState {
  const FinancialDashboardInitial();
}

class FinancialDashboardLoading extends FinancialDashboardState {
  const FinancialDashboardLoading();
}

class FinancialDashboardSuccess extends FinancialDashboardState {
  final FinancialDashboardModel dashboard;

  const FinancialDashboardSuccess({
    required this.dashboard,
  });

  @override
  List<Object?> get props => [dashboard];
}

class FinancialDashboardEmpty extends FinancialDashboardState {
  const FinancialDashboardEmpty();
}

class FinancialDashboardFailure extends FinancialDashboardState {
  final String message;

  const FinancialDashboardFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}