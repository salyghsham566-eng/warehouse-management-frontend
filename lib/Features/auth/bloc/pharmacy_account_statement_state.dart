import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';

abstract class PharmacyAccountStatementState
    extends Equatable {
  const PharmacyAccountStatementState();

  @override
  List<Object?> get props => [];
}

class PharmacyAccountStatementInitial
    extends PharmacyAccountStatementState {
  const PharmacyAccountStatementInitial();
}

class PharmacyAccountStatementLoading
    extends PharmacyAccountStatementState {
  const PharmacyAccountStatementLoading();
}

class PharmacyAccountStatementSuccess
    extends PharmacyAccountStatementState {
  final PharmacyAccountStatementModel statement;

  const PharmacyAccountStatementSuccess({
    required this.statement,
  });

  @override
  List<Object?> get props => [statement];
}

class PharmacyAccountStatementFailure
    extends PharmacyAccountStatementState {
  final String message;

  const PharmacyAccountStatementFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}