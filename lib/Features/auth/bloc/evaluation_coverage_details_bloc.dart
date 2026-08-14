import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationCoverageDetailsBloc
    extends Bloc<
        EvaluationCoverageDetailsEvent,
        EvaluationCoverageDetailsState> {
  final EvaluationRepository repository;

  EvaluationCoverageDetailsBloc({
    required this.repository,
  }) : super(
          EvaluationCoverageDetailsInitial(),
        ) {
    on<LoadEvaluationCoverageDetailsEvent>(
      _load,
    );
  }

  Future<void> _load(
    LoadEvaluationCoverageDetailsEvent event,
    Emitter<EvaluationCoverageDetailsState>
        emit,
  ) async {
    emit(
      EvaluationCoverageDetailsLoading(),
    );

    try {
      final details =
          await repository
              .getCoverageDetails(
        regionId:
            event.regionId,
        month:
            event.month,
        year:
            event.year,
      );

      emit(
        EvaluationCoverageDetailsSuccess(
          details:
              details,
        ),
      );
    } catch (error) {
      emit(
        EvaluationCoverageDetailsFailure(
          message:
              error
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