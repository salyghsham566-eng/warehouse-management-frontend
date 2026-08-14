abstract class WorkPlanGoalDetailsEvent {}

class LoadWorkPlanGoalDetailsEvent
    extends WorkPlanGoalDetailsEvent {
  final int planId;
  final int goalId;

  LoadWorkPlanGoalDetailsEvent({
    required this.planId,
    required this.goalId,
  });
}