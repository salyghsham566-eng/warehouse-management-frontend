import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/submit_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plans_response_model.dart';

abstract class WorkPlansRepository {
  Future<WorkPlansResponseModel> getWorkPlans();

  Future<WorkPlanDetailsModel> getWorkPlanDetails({
    required int planId,
  });

  Future<WorkPlanGoalDetailsModel> getGoalDetails({
    required int planId,
    required int goalId,
  });
  Future<WorkPlanPersonalNoteModel> addPersonalNote({
  required int planId,
  required String text,
});
Future<WorkPlanOfficialNoteModel> addOfficialNote({
  required int planId,
  required String text,
  required WorkPlanOfficialNoteType type,
});
// UC-200
Future<CreateWorkPlanResponseModel> createWorkPlan({
  required CreateWorkPlanRequestModel request,
});
// UC-201
Future<SubmitWorkPlanResponseModel> submitWorkPlan({
  required int planId,
});
// UC-203
Future<void> updateWorkPlan({
  required int planId,
  required UpdateWorkPlanRequestModel request,
});
}