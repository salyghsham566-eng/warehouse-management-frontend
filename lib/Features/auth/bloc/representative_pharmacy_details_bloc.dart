import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_event.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/representative_pharmacies_repository.dart';

class RepresentativePharmacyDetailsBloc extends Bloc<
    RepresentativePharmacyDetailsEvent,
    RepresentativePharmacyDetailsState> {
  final RepresentativePharmaciesRepository
      repository;

  RepresentativePharmacyDetailsBloc({
    required this.repository,
  }) : super(
          const RepresentativePharmacyDetailsInitial(),
        ) {
    on<LoadRepresentativePharmacyDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadRepresentativePharmacyDetailsEvent event,
    Emitter<RepresentativePharmacyDetailsState>
        emit,
  ) async {
    emit(
      const RepresentativePharmacyDetailsLoading(),
    );

    try {
      final details =
          await repository
              .getRepresentativePharmacyDetails(
        event.pharmacyId,
      );

      emit(
        RepresentativePharmacyDetailsSuccess(
          details: details,
        ),
      );
    } catch (error) {
      emit(
        RepresentativePharmacyDetailsFailure(
          message: _cleanError(error),
        ),
      );
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}
