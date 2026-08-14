import 'package:project_2/Features/auth/data/datasources/work_plans_datasource.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/submit_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plans_response_model.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlansRepositoryImpl
    implements WorkPlansRepository {
  final WorkPlansDataSource dataSource;

  WorkPlansRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<WorkPlansResponseModel> getWorkPlans() {
    return dataSource.getWorkPlans();
  }
  @override
Future<WorkPlanDetailsModel> getWorkPlanDetails({
  required int planId,
}) {
  return dataSource.getWorkPlanDetails(
    planId: planId,
  );
}

@override
Future<WorkPlanGoalDetailsModel> getGoalDetails({
  required int planId,
  required int goalId,
}) {
  return dataSource.getGoalDetails(
    planId: planId,
    goalId: goalId,
  );
}
@override
Future<WorkPlanPersonalNoteModel> addPersonalNote({
  required int planId,
  required String text,
}) {
  return dataSource.addPersonalNote(
    planId: planId,
    text: text,
  );
}
@override
Future<WorkPlanOfficialNoteModel> addOfficialNote({
  required int planId,
  required String text,
  required WorkPlanOfficialNoteType type,
}) {
  return dataSource.addOfficialNote(
    planId: planId,
    text: text,
    type: type,
  );
}
@override
Future<CreateWorkPlanResponseModel> createWorkPlan({
  required CreateWorkPlanRequestModel request,
}) {
  return dataSource.createWorkPlan(
    request: request,
  );
}
@override
Future<SubmitWorkPlanResponseModel> submitWorkPlan({
  required int planId,
}) {
  return dataSource.submitWorkPlan(
    planId: planId,
  );
}
@override
Future<void> updateWorkPlan({
  required int planId,
  required UpdateWorkPlanRequestModel request,
}) {
  return dataSource.updateWorkPlan(
    planId: planId,
    request: request,
  );
}
}