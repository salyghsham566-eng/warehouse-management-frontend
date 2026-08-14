import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/submit_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plans_response_model.dart';

abstract class WorkPlansDataSource {
  // UC-191
  Future<WorkPlansResponseModel> getWorkPlans();

  // UC-192 + UC-193
  Future<WorkPlanDetailsModel> getWorkPlanDetails({
    required int planId,
  });

  // UC-194 → UC-197
  Future<WorkPlanGoalDetailsModel> getGoalDetails({
    required int planId,
    required int goalId,
  });
  // UC-198
Future<WorkPlanPersonalNoteModel> addPersonalNote({
  required int planId,
  required String text,
});
// UC-199
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