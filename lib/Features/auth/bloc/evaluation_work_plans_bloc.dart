import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_work_plans_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_work_plans_state.dart';
import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationWorkPlansBloc extends Bloc<
    EvaluationWorkPlansEvent,
    EvaluationWorkPlansState> {
  final EvaluationRepository repository;

  EvaluationWorkPlansBloc({
    required this.repository,
  }) : super(EvaluationWorkPlansInitial()) {
    on<LoadEvaluationWorkPlansEvent>(
      _loadEvaluationWorkPlans,
    );
  }

  Future<void> _loadEvaluationWorkPlans(
    LoadEvaluationWorkPlansEvent event,
    Emitter<EvaluationWorkPlansState> emit,
  ) async {
    emit(EvaluationWorkPlansLoading());

    try {
      final plans =
          await repository.getWorkPlanEvaluations(
        regionId: event.regionId,
        month: event.month,
        year: event.year,
      );

      emit(
        EvaluationWorkPlansSuccess(
          plans: plans,
        ),
      );
    } catch (error) {
      emit(
        EvaluationWorkPlansFailure(
          message: _getErrorMessage(error),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    return error.toString().replaceFirst(
          'Exception: ',
          '',
        );
  }
}