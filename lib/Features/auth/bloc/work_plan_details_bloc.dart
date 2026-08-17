import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanDetailsBloc
    extends Bloc<WorkPlanDetailsEvent, WorkPlanDetailsState> {
  final WorkPlansRepository repository;

  WorkPlanDetailsBloc({
    required this.repository,
  }) : super(WorkPlanDetailsInitial()) {
    on<LoadWorkPlanDetailsEvent>(
      _loadDetails,
    );

    on<AddPersonalNoteToDetailsEvent>(
      _addPersonalNoteLocally,
    );

    on<AddOfficialNoteToDetailsEvent>(
      _addOfficialNoteLocally,
    );
  }

  Future<void> _loadDetails(
    LoadWorkPlanDetailsEvent event,
    Emitter<WorkPlanDetailsState> emit,
  ) async {
    final bool hasLoadedData =
        state is WorkPlanDetailsLoaded;

    if (!hasLoadedData) {
      emit(
        WorkPlanDetailsLoading(),
      );
    }

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
      if (!hasLoadedData) {
        emit(
          WorkPlanDetailsFailure(
            message: e.toString(),
          ),
        );
      }
    }
  }

  void _addPersonalNoteLocally(
    AddPersonalNoteToDetailsEvent event,
    Emitter<WorkPlanDetailsState> emit,
  ) {
    final currentState = state;

    if (currentState
        is! WorkPlanDetailsLoaded) {
      return;
    }

    final updatedPlan =
        currentState.plan.copyWith(
      personalNotes: [
        event.note,
        ...currentState.plan.personalNotes,
      ],
    );

    emit(
      WorkPlanDetailsLoaded(
        plan: updatedPlan,
      ),
    );
  }

  void _addOfficialNoteLocally(
    AddOfficialNoteToDetailsEvent event,
    Emitter<WorkPlanDetailsState> emit,
  ) {
    final currentState = state;

    if (currentState
        is! WorkPlanDetailsLoaded) {
      return;
    }

    final updatedPlan =
        currentState.plan.copyWith(
      officialNotes: [
        event.note,
        ...currentState.plan.officialNotes,
      ],
    );

    emit(
      WorkPlanDetailsLoaded(
        plan: updatedPlan,
      ),
    );
  }
}