import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_official_note_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_state.dart';

import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanOfficialNoteBloc
    extends Bloc<
        WorkPlanOfficialNoteEvent,
        WorkPlanOfficialNoteState> {
  final WorkPlansRepository repository;

  WorkPlanOfficialNoteBloc({
    required this.repository,
  }) : super(WorkPlanOfficialNoteInitial()) {
    on<AddWorkPlanOfficialNoteEvent>(
      _addOfficialNote,
    );
  }

  Future<void> _addOfficialNote(
    AddWorkPlanOfficialNoteEvent event,
    Emitter<WorkPlanOfficialNoteState> emit,
  ) async {
    final text = event.text.trim();

    if (text.isEmpty) {
      emit(
        WorkPlanOfficialNoteFailure(
          message: 'يرجى كتابة النص',
        ),
      );
      return;
    }

    emit(
      WorkPlanOfficialNoteSaving(),
    );

    try {
      final note =
          await repository.addOfficialNote(
        planId: event.planId,
        text: text,
        type: event.type,
      );

      emit(
        WorkPlanOfficialNoteSuccess(
          note: note,
        ),
      );
    } catch (e) {
      emit(
        WorkPlanOfficialNoteFailure(
          message: e.toString(),
        ),
      );
    }
  }
}