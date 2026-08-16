import 'package:project_2/Features/auth/data/datasources/evaluation_data_source.dart';

import 'package:project_2/Features/auth/data/models/evaluation_archive_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_work_plans_state.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';

class EvaluationRepositoryImpl
    implements EvaluationRepository {
  final EvaluationDataSource dataSource;

  const EvaluationRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<EvaluationOverviewModel>
      getCurrentEvaluation({
    required String regionId,
  }) {
    return dataSource.getCurrentEvaluation(
      regionId: regionId,
    );
  }

  @override
  Future<EvaluationTargetDetailsModel>
      getTargetDetails({
    required String regionId,
    required int month,
    required int year,
  }) {
    return dataSource.getTargetDetails(
      regionId: regionId,
      month: month,
      year: year,
    );
  }

  @override
  Future<EvaluationCoverageDetailsModel>
      getCoverageDetails({
    required String regionId,
    required int month,
    required int year,
  }) {
    return dataSource.getCoverageDetails(
      regionId: regionId,
      month: month,
      year: year,
    );
  }

  @override
  Future<EvaluationRepeatedPharmaciesDetailsModel>
      getRepeatedPharmaciesDetails({
    required String regionId,
    required int month,
    required int year,
  }) {
    return dataSource
        .getRepeatedPharmaciesDetails(
      regionId: regionId,
      month: month,
      year: year,
    );
  }

  @override
  Future<EvaluationOneTimePharmaciesDetailsModel>
      getOneTimePharmaciesDetails({
    required String regionId,
    required int month,
    required int year,
  }) {
    return dataSource
        .getOneTimePharmaciesDetails(
      regionId: regionId,
      month: month,
      year: year,
    );
  }

  // =========================================================
  // UC-211
  // =========================================================

  @override
  Future<List<EvaluationWorkPlanModel>>
      getWorkPlanEvaluations({
    required String regionId,
    required int month,
    required int year,
  }) {
    return dataSource
        .getWorkPlanEvaluations(
      regionId: regionId,
      month: month,
      year: year,
    );
  }

  // =========================================================
  // UC-212
  // =========================================================

  @override
  Future<List<EvaluationArchiveModel>>
      getEvaluationArchive({
    required String regionId,
    int? month,
    int? year,
  }) {
    return dataSource
        .getEvaluationArchive(
      regionId: regionId,
      month: month,
      year: year,
    );
  }
}