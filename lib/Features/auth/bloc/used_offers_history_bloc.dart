import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/used_offers_history_event.dart';
import 'package:project_2/Features/auth/bloc/used_offers_history_state.dart';

import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';

class UsedOffersHistoryBloc
    extends Bloc<
        UsedOffersHistoryEvent,
        UsedOffersHistoryState> {
  final OffersRepository repository;

  UsedOffersHistoryBloc({
    required this.repository,
  }) : super(
          UsedOffersHistoryInitial(),
        ) {
    on<LoadUsedOffersHistoryEvent>(
      _loadHistory,
    );
  }

  Future<void> _loadHistory(
    LoadUsedOffersHistoryEvent event,
    Emitter<UsedOffersHistoryState> emit,
  ) async {
    emit(
      UsedOffersHistoryLoading(),
    );

    try {
      final offers =
          await repository
              .getUsedOffersHistory();

      emit(
        UsedOffersHistorySuccess(
          offers: offers,
        ),
      );
    } catch (error) {
      emit(
        UsedOffersHistoryFailure(
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