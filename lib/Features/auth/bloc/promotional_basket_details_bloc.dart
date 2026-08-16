import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/promotional_basket_details_event.dart';
import 'package:project_2/Features/auth/bloc/promotional_basket_details_state.dart';

import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';

class PromotionalBasketDetailsBloc
    extends Bloc<
        PromotionalBasketDetailsEvent,
        PromotionalBasketDetailsState> {
  final OffersRepository repository;

  PromotionalBasketDetailsBloc({
    required this.repository,
  }) : super(
          PromotionalBasketDetailsInitial(),
        ) {
    on<
        LoadPromotionalBasketDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadPromotionalBasketDetailsEvent event,
    Emitter<
            PromotionalBasketDetailsState>
        emit,
  ) async {
    emit(
      PromotionalBasketDetailsLoading(),
    );

    try {
      final basket =
          await repository
              .getPromotionalBasketDetails(
        basketId:
            event.basketId,
      );

      emit(
        PromotionalBasketDetailsSuccess(
          basket:
              basket,
        ),
      );
    } catch (error) {
      emit(
        PromotionalBasketDetailsFailure(
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