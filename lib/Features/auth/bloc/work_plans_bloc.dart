import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plans_event.dart';
import 'package:project_2/Features/auth/bloc/work_plans_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlansBloc
    extends Bloc<WorkPlansEvent, WorkPlansState> {
  final WorkPlansRepository repository;

  WorkPlansBloc({
    required this.repository,
  }) : super(WorkPlansInitial()) {
    on<LoadWorkPlansEvent>(
      _onLoadWorkPlans,
    );
  }

  Future<void> _onLoadWorkPlans(
    LoadWorkPlansEvent event,
    Emitter<WorkPlansState> emit,
  ) async {
    emit(
      WorkPlansLoading(),
    );

    try {
      final response =
          await repository.getWorkPlans();

      emit(
        WorkPlansLoaded(
          assignedPlans:
              response.assignedPlans,
          createdPlans:
              response.createdPlans,
        ),
      );
    } catch (e) {
      emit(
        WorkPlansFailure(
          message: e.toString(),
        ),
      );
    }
  }
}