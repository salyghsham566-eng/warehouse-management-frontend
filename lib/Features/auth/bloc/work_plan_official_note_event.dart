import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';

abstract class WorkPlanOfficialNoteEvent {}

class AddWorkPlanOfficialNoteEvent
    extends WorkPlanOfficialNoteEvent {
  final int planId;
  final String text;
  final WorkPlanOfficialNoteType type;

  AddWorkPlanOfficialNoteEvent({
    required this.planId,
    required this.text,
    required this.type,
  });
}