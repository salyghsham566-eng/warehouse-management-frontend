import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';

abstract class RegionAccountStatementState
    extends Equatable {
  const RegionAccountStatementState();

  @override
  List<Object?> get props => [];
}

class RegionAccountStatementInitial
    extends RegionAccountStatementState {
  const RegionAccountStatementInitial();
}

class RegionAccountStatementLoading
    extends RegionAccountStatementState {
  const RegionAccountStatementLoading();
}

class RegionAccountStatementSuccess
    extends RegionAccountStatementState {
  final RegionAccountStatementModel statement;

  const RegionAccountStatementSuccess({
    required this.statement,
  });

  @override
  List<Object?> get props => [statement];
}

class RegionAccountStatementEmpty
    extends RegionAccountStatementState {
  const RegionAccountStatementEmpty();
}

class RegionAccountStatementFailure
    extends RegionAccountStatementState {
  final String message;

  const RegionAccountStatementFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}