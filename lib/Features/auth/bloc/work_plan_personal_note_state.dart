import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';

abstract class WorkPlanPersonalNoteState {}

class WorkPlanPersonalNoteInitial
    extends WorkPlanPersonalNoteState {}

class WorkPlanPersonalNoteSaving
    extends WorkPlanPersonalNoteState {}

class WorkPlanPersonalNoteSuccess
    extends WorkPlanPersonalNoteState {
  final WorkPlanPersonalNoteModel note;

  WorkPlanPersonalNoteSuccess({
    required this.note,
  });
}

class WorkPlanPersonalNoteFailure
    extends WorkPlanPersonalNoteState {
  final String message;

  WorkPlanPersonalNoteFailure({
    required this.message,
  });
}