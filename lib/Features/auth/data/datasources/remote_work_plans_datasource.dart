import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';

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

class RemoteWorkPlansDataSource
    implements WorkPlansDataSource {
  final Dio dio;

  RemoteWorkPlansDataSource({
    required this.dio,
  });

  // =========================================================
  // UC-191
  // =========================================================

  @override
  Future<WorkPlansResponseModel> getWorkPlans() async {
    final response = await dio.get(
      ApiEndpoints.workPlans,
    );

    return WorkPlansResponseModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  // =========================================================
  // UC-192 + UC-193
  // =========================================================

  @override
  Future<WorkPlanDetailsModel> getWorkPlanDetails({
    required int planId,
  }) async {
    final response = await dio.get(
      ApiEndpoints.workPlanDetails(planId),
    );

    final responseJson =
        Map<String, dynamic>.from(response.data);

    final data = Map<String, dynamic>.from(
      responseJson['data'],
    );

    return WorkPlanDetailsModel.fromJson(data);
  }

  // =========================================================
  // UC-194 → UC-197
  // =========================================================

  @override
  Future<WorkPlanGoalDetailsModel> getGoalDetails({
    required int planId,
    required int goalId,
  }) async {
    final response = await dio.get(
      ApiEndpoints.workPlanGoalDetails(
        planId: planId,
        goalId: goalId,
      ),
    );

    final responseJson =
        Map<String, dynamic>.from(response.data);

    final data = Map<String, dynamic>.from(
      responseJson['data'],
    );

    return WorkPlanGoalDetailsModel.fromJson(data);
  }
  @override
Future<WorkPlanPersonalNoteModel> addPersonalNote({
  required int planId,
  required String text,
}) async {
  final response = await dio.post(
    ApiEndpoints.workPlanPersonalNotes(
      planId,
    ),
    data: {
      "text": text,
    },
  );

  final responseJson =
      Map<String, dynamic>.from(
    response.data,
  );

  final data = Map<String, dynamic>.from(
    responseJson['data'],
  );

  return WorkPlanPersonalNoteModel.fromJson(
    data,
  );
}
@override
Future<WorkPlanOfficialNoteModel> addOfficialNote({
  required int planId,
  required String text,
  required WorkPlanOfficialNoteType type,
}) async {
  final response = await dio.post(
    ApiEndpoints.workPlanOfficialNotes(
      planId,
    ),
    data: {
      "text": text,
      "type":
          workPlanOfficialNoteTypeToString(type),
    },
  );

  final responseJson =
      Map<String, dynamic>.from(
    response.data,
  );

  final data = Map<String, dynamic>.from(
    responseJson['data'],
  );

  return WorkPlanOfficialNoteModel.fromJson(
    data,
  );
}
// =========================================================
// UC-200 - Create Work Plan
// =========================================================

@override
Future<CreateWorkPlanResponseModel> createWorkPlan({
  required CreateWorkPlanRequestModel request,
}) async {
  final response = await dio.post(
    ApiEndpoints.workPlans,
    data: request.toJson(),
  );

  final dynamic rawResponse = response.data;

  if (rawResponse is! Map) {
    throw const FormatException(
      'صيغة استجابة إنشاء خطة العمل غير صحيحة',
    );
  }

  final responseJson =
      Map<String, dynamic>.from(
    rawResponse,
  );

  final dynamic rawData =
      responseJson['data'];

  final Map<String, dynamic> data;

  if (rawData is Map) {
    data = Map<String, dynamic>.from(
      rawData,
    );
  } else {
    data = responseJson;
  }

  return CreateWorkPlanResponseModel.fromJson(
    data,
    message:
        responseJson['message']?.toString(),
  );
}
// =========================================================
// UC-201 - Submit Work Plan For Review
// =========================================================

@override
Future<SubmitWorkPlanResponseModel> submitWorkPlan({
  required int planId,
}) async {
  final response = await dio.post(
    '${ApiEndpoints.workPlans}/$planId/submit',
  );

  final dynamic rawResponse = response.data;

  if (rawResponse is! Map) {
    throw const FormatException(
      'صيغة استجابة إرسال الخطة غير صحيحة',
    );
  }

  final responseJson =
      Map<String, dynamic>.from(
    rawResponse,
  );

  final dynamic rawData =
      responseJson['data'];

  final Map<String, dynamic> data;

  if (rawData is Map) {
    data = Map<String, dynamic>.from(
      rawData,
    );
  } else {
    data = responseJson;
  }

  return SubmitWorkPlanResponseModel.fromJson(
    data,
    message:
        responseJson['message']?.toString(),
  );
}
// =========================================================
// UC-203 - Update Work Plan
// =========================================================

@override
Future<void> updateWorkPlan({
  required int planId,
  required UpdateWorkPlanRequestModel request,
}) async {
  await dio.patch(
    '${ApiEndpoints.workPlans}/$planId',
    data: request.toJson(),
  );
}
}