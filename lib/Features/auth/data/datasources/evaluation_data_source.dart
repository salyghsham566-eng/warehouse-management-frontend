import 'package:project_2/Features/auth/data/models/evaluation_archive_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_work_plans_state.dart';

abstract class EvaluationDataSource {
  Future<EvaluationOverviewModel>
      getCurrentEvaluation({
    required String regionId,
  });

  // =========================================================
  // UC-206
  // =========================================================

  Future<EvaluationTargetDetailsModel>
      getTargetDetails({
    required String regionId,
    required int month,
    required int year,
  });

  // =========================================================
  // UC-207
  // =========================================================

  Future<EvaluationCoverageDetailsModel>
      getCoverageDetails({
    required String regionId,
    required int month,
    required int year,
  });

  // =========================================================
  // UC-208
  // =========================================================

  Future<EvaluationRepeatedPharmaciesDetailsModel>
      getRepeatedPharmaciesDetails({
    required String regionId,
    required int month,
    required int year,
  });

  // =========================================================
  // UC-209
  // =========================================================

  Future<EvaluationOneTimePharmaciesDetailsModel>
      getOneTimePharmaciesDetails({
    required String regionId,
    required int month,
    required int year,
  });

  // =========================================================
  // UC-211
  // =========================================================

  Future<List<EvaluationWorkPlanModel>>
      getWorkPlanEvaluations({
    required String regionId,
    required int month,
    required int year,
  });

  // =========================================================
  // UC-212
  // =========================================================

  Future<List<EvaluationArchiveModel>>
      getEvaluationArchive({
    required String regionId,
    int? month,
    int? year,
  });
}