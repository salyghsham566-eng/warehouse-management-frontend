import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_archive_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_archive_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationArchiveBloc
    extends Bloc<
        EvaluationArchiveEvent,
        EvaluationArchiveState> {
  final EvaluationRepository repository;

  EvaluationArchiveBloc({
    required this.repository,
  }) : super(
          EvaluationArchiveInitial(),
        ) {
    on<LoadEvaluationArchiveEvent>(
      _loadArchive,
    );
  }

  Future<void> _loadArchive(
    LoadEvaluationArchiveEvent event,
    Emitter<EvaluationArchiveState> emit,
  ) async {
    emit(
      EvaluationArchiveLoading(),
    );

    try {
      final evaluations =
          await repository
              .getEvaluationArchive(
        regionId: event.regionId,
        month: event.month,
        year: event.year,
      );

      emit(
        EvaluationArchiveSuccess(
          evaluations: evaluations,
        ),
      );
    } catch (error) {
      emit(
        EvaluationArchiveFailure(
          message: error
              .toString()
              .replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}