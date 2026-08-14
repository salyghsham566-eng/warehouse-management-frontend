abstract class SubmitWorkPlanEvent {}

class SubmitWorkPlanRequested
    extends SubmitWorkPlanEvent {
  final int planId;

  SubmitWorkPlanRequested({
    required this.planId,
  });
}