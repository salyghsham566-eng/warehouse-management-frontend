import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';

abstract class WorkPlanOfficialNoteState {}

class WorkPlanOfficialNoteInitial
    extends WorkPlanOfficialNoteState {}

class WorkPlanOfficialNoteSaving
    extends WorkPlanOfficialNoteState {}

class WorkPlanOfficialNoteSuccess
    extends WorkPlanOfficialNoteState {
  final WorkPlanOfficialNoteModel note;

  WorkPlanOfficialNoteSuccess({
    required this.note,
  });
}

class WorkPlanOfficialNoteFailure
    extends WorkPlanOfficialNoteState {
  final String message;

  WorkPlanOfficialNoteFailure({
    required this.message,
  });
}