import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_event.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationOneTimePharmaciesDetailsBloc
    extends Bloc<
        EvaluationOneTimePharmaciesDetailsEvent,
        EvaluationOneTimePharmaciesDetailsState> {
  final EvaluationRepository repository;

  EvaluationOneTimePharmaciesDetailsBloc({
    required this.repository,
  }) : super(
          EvaluationOneTimePharmaciesDetailsInitial(),
        ) {
    on<
        LoadEvaluationOneTimePharmaciesDetailsEvent>(
      _load,
    );
  }

  Future<void> _load(
    LoadEvaluationOneTimePharmaciesDetailsEvent event,
    Emitter<
            EvaluationOneTimePharmaciesDetailsState>
        emit,
  ) async {
    emit(
      EvaluationOneTimePharmaciesDetailsLoading(),
    );

    try {
      final details =
          await repository
              .getOneTimePharmaciesDetails(
        regionId:
            event.regionId,
        month:
            event.month,
        year:
            event.year,
      );

      emit(
        EvaluationOneTimePharmaciesDetailsSuccess(
          details:
              details,
        ),
      );
    } catch (error) {
      emit(
        EvaluationOneTimePharmaciesDetailsFailure(
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