abstract class WorkPlanPersonalNoteEvent {}

class AddWorkPlanPersonalNoteEvent
    extends WorkPlanPersonalNoteEvent {
  final int planId;
  final String text;

  AddWorkPlanPersonalNoteEvent({
    required this.planId,
    required this.text,
  });
}