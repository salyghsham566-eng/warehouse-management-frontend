import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanDetailsBloc
    extends Bloc<
        WorkPlanDetailsEvent,
        WorkPlanDetailsState> {
  final WorkPlansRepository repository;

  WorkPlanDetailsBloc({
    required this.repository,
  }) : super(WorkPlanDetailsInitial()) {
    on<LoadWorkPlanDetailsEvent>(
      _loadDetails,
    );
  }

  Future<void> _loadDetails(
    LoadWorkPlanDetailsEvent event,
    Emitter<WorkPlanDetailsState> emit,
  ) async {
    emit(WorkPlanDetailsLoading());

    try {
      final plan =
          await repository.getWorkPlanDetails(
        planId: event.planId,
      );

      emit(
        WorkPlanDetailsLoaded(
          plan: plan,
        ),
      );
    } catch (e) {
      emit(
        WorkPlanDetailsFailure(
          message: e.toString(),
        ),
      );
    }
  }
}