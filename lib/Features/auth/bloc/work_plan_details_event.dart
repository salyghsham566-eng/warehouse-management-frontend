abstract class WorkPlanDetailsEvent {}

class LoadWorkPlanDetailsEvent
    extends WorkPlanDetailsEvent {
  final int planId;

  LoadWorkPlanDetailsEvent({
    required this.planId,
  });
}