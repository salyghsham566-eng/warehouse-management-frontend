import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacy_details_event.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacy_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_phermacy_repository.dart';

class CollectionPharmacyDetailsBloc extends Bloc<
    CollectionPharmacyDetailsEvent,
    CollectionPharmacyDetailsState> {
  CollectionPharmacyDetailsBloc({
    required this.repository,
  }) : super(
          const CollectionPharmacyDetailsInitial(),
        ) {
    on<LoadCollectionPharmacyDetailsEvent>(
      _onLoadDetails,
    );
  }

  final CollectionRepository repository;

  Future<void> _onLoadDetails(
    LoadCollectionPharmacyDetailsEvent event,
    Emitter<CollectionPharmacyDetailsState> emit,
  ) async {
    emit(
      const CollectionPharmacyDetailsLoading(),
    );

    try {
      final pharmacy =
          await repository
              .getCollectionPharmacyDetails(
        event.pharmacyId,
      );

      emit(
        CollectionPharmacyDetailsLoaded(
          pharmacy: pharmacy,
        ),
      );
    } catch (error) {
      emit(
        CollectionPharmacyDetailsFailure(
          message: error
              .toString()
              .replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}