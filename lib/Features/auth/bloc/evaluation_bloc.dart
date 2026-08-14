import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationBloc
    extends Bloc<
        EvaluationEvent,
        EvaluationState> {
  final EvaluationRepository repository;

  EvaluationBloc({
    required this.repository,
  }) : super(EvaluationInitial()) {
    on<LoadCurrentEvaluationEvent>(
      _loadCurrentEvaluation,
    );
  }

  Future<void> _loadCurrentEvaluation(
    LoadCurrentEvaluationEvent event,
    Emitter<EvaluationState> emit,
  ) async {
    emit(EvaluationLoading());

    try {
      final evaluation =
          await repository
              .getCurrentEvaluation(
        regionId: event.regionId,
      );

      emit(
        EvaluationSuccess(
          evaluation: evaluation,
        ),
      );
    } catch (error) {
      emit(
        EvaluationFailure(
          message: _getErrorMessage(
            error,
          ),
        ),
      );
    }
  }

  String _getErrorMessage(
    Object error,
  ) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}