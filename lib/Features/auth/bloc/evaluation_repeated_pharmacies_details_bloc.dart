import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationRepeatedPharmaciesDetailsBloc
    extends Bloc<
        EvaluationRepeatedPharmaciesDetailsEvent,
        EvaluationRepeatedPharmaciesDetailsState> {
  final EvaluationRepository repository;

  EvaluationRepeatedPharmaciesDetailsBloc({
    required this.repository,
  }) : super(
          EvaluationRepeatedPharmaciesDetailsInitial(),
        ) {
    on<
        LoadEvaluationRepeatedPharmaciesDetailsEvent>(
      _load,
    );
  }

  Future<void> _load(
    LoadEvaluationRepeatedPharmaciesDetailsEvent event,
    Emitter<
            EvaluationRepeatedPharmaciesDetailsState>
        emit,
  ) async {
    emit(
      EvaluationRepeatedPharmaciesDetailsLoading(),
    );

    try {
      final details =
          await repository
              .getRepeatedPharmaciesDetails(
        regionId:
            event.regionId,
        month:
            event.month,
        year:
            event.year,
      );

      emit(
        EvaluationRepeatedPharmaciesDetailsSuccess(
          details:
              details,
        ),
      );
    } catch (error) {
      emit(
        EvaluationRepeatedPharmaciesDetailsFailure(
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