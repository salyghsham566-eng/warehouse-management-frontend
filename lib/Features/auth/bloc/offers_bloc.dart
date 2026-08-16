import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/offers_event.dart';
import 'package:project_2/Features/auth/bloc/offers_state.dart';

import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';

class OffersBloc
    extends Bloc<
        OffersEvent,
        OffersState> {
  final OffersRepository repository;

  OffersBloc({
    required this.repository,
  }) : super(
          OffersInitial(),
        ) {
    on<LoadOffersEvent>(
      _loadOffers,
    );
  }

  Future<void> _loadOffers(
    LoadOffersEvent event,
    Emitter<OffersState> emit,
  ) async {
    emit(
      OffersLoading(),
    );

    try {
      final data =
          await repository
              .getRepresentativeOffers();

      emit(
        OffersSuccess(
          data: data,
        ),
      );
    } catch (error) {
      emit(
        OffersFailure(
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