import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_personal_note_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_personal_note_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanPersonalNoteBloc
    extends Bloc<WorkPlanPersonalNoteEvent, WorkPlanPersonalNoteState> {
  final WorkPlansRepository repository;

  WorkPlanPersonalNoteBloc({
    required this.repository,
  }) : super(WorkPlanPersonalNoteInitial()) {
    on<AddWorkPlanPersonalNoteEvent>(_addNote);
  }

  Future<void> _addNote(
    AddWorkPlanPersonalNoteEvent event,
    Emitter<WorkPlanPersonalNoteState> emit,
  ) async {
    emit(WorkPlanPersonalNoteSaving());

    try {
      final note = await repository.addPersonalNote(
        planId: event.planId,
        text: event.text,
      );

      emit(
        WorkPlanPersonalNoteSuccess(
          note: note,
        ),
      );
    } catch (e) {
      emit(
        WorkPlanPersonalNoteFailure(
          message: e.toString(),
        ),
      );
    }
  }
}