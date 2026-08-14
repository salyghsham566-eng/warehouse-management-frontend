import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_target_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_target_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationTargetDetailsBloc
    extends Bloc<
        EvaluationTargetDetailsEvent,
        EvaluationTargetDetailsState> {
  final EvaluationRepository repository;

  EvaluationTargetDetailsBloc({
    required this.repository,
  }) : super(
          EvaluationTargetDetailsInitial(),
        ) {
    on<LoadEvaluationTargetDetailsEvent>(
      _load,
    );
  }

  Future<void> _load(
    LoadEvaluationTargetDetailsEvent event,
    Emitter<EvaluationTargetDetailsState>
        emit,
  ) async {
    emit(
      EvaluationTargetDetailsLoading(),
    );

    try {
      final details =
          await repository
              .getTargetDetails(
        regionId: event.regionId,
        month: event.month,
        year: event.year,
      );

      emit(
        EvaluationTargetDetailsSuccess(
          details: details,
        ),
      );
    } catch (e) {
      emit(
        EvaluationTargetDetailsFailure(
          message: e
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