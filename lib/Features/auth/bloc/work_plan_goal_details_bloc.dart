import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_goal_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanGoalDetailsBloc
    extends Bloc<
        WorkPlanGoalDetailsEvent,
        WorkPlanGoalDetailsState> {
  final WorkPlansRepository repository;

  WorkPlanGoalDetailsBloc({
    required this.repository,
  }) : super(WorkPlanGoalDetailsInitial()) {
    on<LoadWorkPlanGoalDetailsEvent>(
      _loadGoalDetails,
    );
  }

  Future<void> _loadGoalDetails(
    LoadWorkPlanGoalDetailsEvent event,
    Emitter<WorkPlanGoalDetailsState> emit,
  ) async {
    emit(WorkPlanGoalDetailsLoading());

    try {
      final result =
          await repository.getGoalDetails(
        planId: event.planId,
        goalId: event.goalId,
      );

      emit(
        WorkPlanGoalDetailsLoaded(
          details: result,
        ),
      );
    } catch (e) {
      emit(
        WorkPlanGoalDetailsFailure(
          message: e.toString(),
        ),
      );
    }
  }
}