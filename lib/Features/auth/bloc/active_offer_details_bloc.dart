import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/active_offer_details_event.dart';
import 'package:project_2/Features/auth/bloc/active_offer_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';

class ActiveOfferDetailsBloc extends Bloc<
    ActiveOfferDetailsEvent,
    ActiveOfferDetailsState> {
  final OffersRepository repository;

  ActiveOfferDetailsBloc({
    required this.repository,
  }) : super(
          ActiveOfferDetailsInitial(),
        ) {
    on<LoadActiveOfferDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadActiveOfferDetailsEvent event,
    Emitter<ActiveOfferDetailsState> emit,
  ) async {
    emit(
      ActiveOfferDetailsLoading(),
    );

    try {
      final offer =
          await repository
              .getActiveOfferDetails(
        offerId: event.offerId,
      );

      emit(
        ActiveOfferDetailsSuccess(
          offer: offer,
        ),
      );
    } catch (error) {
      emit(
        ActiveOfferDetailsFailure(
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