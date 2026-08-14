import 'package:project_2/Features/auth/data/datasources/evaluation_data_source.dart';
import 'package:project_2/Features/auth/data/models/evaluation_coverage_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_one_time_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_overview_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_repeated_pharmacies_details_model.dart';
import 'package:project_2/Features/auth/data/models/evaluation_target_details_model.dart';

class MockEvaluationDataSource
    implements EvaluationDataSource {
 @override
Future<EvaluationOverviewModel>
    getCurrentEvaluation({
  required String regionId,
}) async {
  await Future<void>.delayed(
    const Duration(
      milliseconds: 600,
    ),
  );

  final now = DateTime.now();

  final regions = const [
    EvaluationRegionModel(
      id: '1',
      name: 'المنطقة الشمالية',
    ),
    EvaluationRegionModel(
      id: '2',
      name: 'المنطقة الجنوبية',
    ),
    EvaluationRegionModel(
      id: '3',
      name: 'المنطقة الوسطى',
    ),
    EvaluationRegionModel(
      id: '4',
      name: 'المنطقة الغربية',
    ),
  ];

  String regionName =
      'جميع المناطق';

  if (regionId != 'all') {
    for (final region in regions) {
      if (region.id == regionId) {
        regionName = region.name;
        break;
      }
    }
  }

  // قيم Mock مختلفة حسب المنطقة
  double target;
  double coverage;
  double repeated;
  double oneTime;

  switch (regionId) {
    case '1':
      target = 29;
      coverage = 31;
      repeated = 16;
      oneTime = 8;
      break;

    case '2':
      target = 25;
      coverage = 27;
      repeated = 14;
      oneTime = 7;
      break;

    case '3':
      target = 32;
      coverage = 33;
      repeated = 18;
      oneTime = 9;
      break;

    case '4':
      target = 27;
      coverage = 29;
      repeated = 15;
      oneTime = 8;
      break;

    default:
      target = 30;
      coverage = 32;
      repeated = 17;
      oneTime = 8;
  }

  return EvaluationOverviewModel(
    month: now.month,
    year: now.year,
    regionId: regionId,
    regionName: regionName,
    regions: regions,

    targetScore:
        EvaluationScoreModel(
      score: target,
      maxScore: 35,
    ),

    coverageScore:
        EvaluationScoreModel(
      score: coverage,
      maxScore: 35,
    ),

    repeatedScore:
        EvaluationScoreModel(
      score: repeated,
      maxScore: 20,
    ),

    oneTimeScore:
        EvaluationScoreModel(
      score: oneTime,
      maxScore: 10,
    ),
  );
}// =========================================================
// UC-206 - Target Details
// =========================================================

@override
Future<EvaluationTargetDetailsModel>
    getTargetDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  await Future<void>.delayed(
    const Duration(
      milliseconds: 600,
    ),
  );

  String regionName =
      'جميع المناطق';

  double requiredTarget;
  double achievedTarget;
  double score;

  List<EvaluationTargetPharmacyModel>
      pharmacies;

  switch (regionId) {
    case '1':
      regionName =
          'المنطقة الشمالية';

      requiredTarget = 100000;
      achievedTarget = 83000;
      score = 29;

      pharmacies = const [
        EvaluationTargetPharmacyModel(
          pharmacyId: 1,
          pharmacyName:
              'صيدلية الشفاء',
          salesAmount: 28000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 2,
          pharmacyName:
              'صيدلية الحياة',
          salesAmount: 31000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 3,
          pharmacyName:
              'صيدلية الأمل',
          salesAmount: 24000,
        ),
      ];
      break;

    case '2':
      regionName =
          'المنطقة الجنوبية';

      requiredTarget = 90000;
      achievedTarget = 64000;
      score = 25;

      pharmacies = const [
        EvaluationTargetPharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية السلام',
          salesAmount: 35000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 5,
          pharmacyName:
              'صيدلية الندى',
          salesAmount: 29000,
        ),
      ];
      break;

    case '3':
      regionName =
          'المنطقة الوسطى';

      requiredTarget = 120000;
      achievedTarget = 110000;
      score = 32;

      pharmacies = const [
        EvaluationTargetPharmacyModel(
          pharmacyId: 6,
          pharmacyName:
              'صيدلية النور',
          salesAmount: 43000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 7,
          pharmacyName:
              'صيدلية الرحمة',
          salesAmount: 37000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 8,
          pharmacyName:
              'صيدلية المدينة',
          salesAmount: 30000,
        ),
      ];
      break;

    case '4':
      regionName =
          'المنطقة الغربية';

      requiredTarget = 95000;
      achievedTarget = 73000;
      score = 27;

      pharmacies = const [
        EvaluationTargetPharmacyModel(
          pharmacyId: 9,
          pharmacyName:
              'صيدلية الوفاء',
          salesAmount: 40000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 10,
          pharmacyName:
              'صيدلية الروضة',
          salesAmount: 33000,
        ),
      ];
      break;

    default:
      requiredTarget = 405000;
      achievedTarget = 347000;
      score = 30;

      pharmacies = const [
        EvaluationTargetPharmacyModel(
          pharmacyId: 1,
          pharmacyName:
              'صيدلية الشفاء',
          salesAmount: 65000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 2,
          pharmacyName:
              'صيدلية الحياة',
          salesAmount: 59000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 3,
          pharmacyName:
              'صيدلية الأمل',
          salesAmount: 72000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية النور',
          salesAmount: 81000,
        ),
        EvaluationTargetPharmacyModel(
          pharmacyId: 5,
          pharmacyName:
              'صيدلية السلام',
          salesAmount: 70000,
        ),
      ];
  }

  final double percentage =
    requiredTarget <= 0
        ? 0.0
        : (achievedTarget / requiredTarget) * 100;

  return EvaluationTargetDetailsModel(
    month: month,
    year: year,

    regionId: regionId,
    regionName: regionName,

    requiredTarget:
        requiredTarget,

    achievedTarget:
        achievedTarget,

    percentage:
        percentage,

    score: score,

    maxScore: 35,

    pharmacies:
        pharmacies,
  );
}
// =========================================================
// UC-207 - Coverage Details
// =========================================================

@override
Future<EvaluationCoverageDetailsModel>
    getCoverageDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  await Future<void>.delayed(
    const Duration(
      milliseconds: 600,
    ),
  );

  String regionName =
      'جميع المناطق';

  List<EvaluationCoveragePharmacyModel>
      covered;

  List<EvaluationCoveragePharmacyModel>
      uncovered;

  double score;

  switch (regionId) {
    case '1':
      regionName =
          'المنطقة الشمالية';

      covered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 1,
          pharmacyName:
              'صيدلية الشفاء',
          regionName:
              'المنطقة الشمالية',
          salesCount: 3,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 2,
          pharmacyName:
              'صيدلية الحياة',
          regionName:
              'المنطقة الشمالية',
          salesCount: 2,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 3,
          pharmacyName:
              'صيدلية الأمل',
          regionName:
              'المنطقة الشمالية',
          salesCount: 1,
        ),
      ];

      uncovered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية النور',
          regionName:
              'المنطقة الشمالية',
          salesCount: 0,
        ),
      ];

      score = 31;
      break;

    case '2':
      regionName =
          'المنطقة الجنوبية';

      covered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 5,
          pharmacyName:
              'صيدلية السلام',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 2,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 6,
          pharmacyName:
              'صيدلية الوفاء',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 1,
        ),
      ];

      uncovered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 7,
          pharmacyName:
              'صيدلية الندى',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 0,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 8,
          pharmacyName:
              'صيدلية الروضة',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 0,
        ),
      ];

      score = 27;
      break;

    case '3':
      regionName =
          'المنطقة الوسطى';

      covered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 9,
          pharmacyName:
              'صيدلية الرحمة',
          regionName:
              'المنطقة الوسطى',
          salesCount: 4,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 10,
          pharmacyName:
              'صيدلية المدينة',
          regionName:
              'المنطقة الوسطى',
          salesCount: 3,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 11,
          pharmacyName:
              'صيدلية المستقبل',
          regionName:
              'المنطقة الوسطى',
          salesCount: 2,
        ),
      ];

      uncovered = const [];

      score = 33;
      break;

    case '4':
      regionName =
          'المنطقة الغربية';

      covered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 12,
          pharmacyName:
              'صيدلية الغرب',
          regionName:
              'المنطقة الغربية',
          salesCount: 2,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 13,
          pharmacyName:
              'صيدلية البركة',
          regionName:
              'المنطقة الغربية',
          salesCount: 1,
        ),
      ];

      uncovered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 14,
          pharmacyName:
              'صيدلية الخير',
          regionName:
              'المنطقة الغربية',
          salesCount: 0,
        ),
      ];

      score = 29;
      break;

    default:
      covered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 1,
          pharmacyName:
              'صيدلية الشفاء',
          regionName:
              'المنطقة الشمالية',
          salesCount: 3,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 2,
          pharmacyName:
              'صيدلية الحياة',
          regionName:
              'المنطقة الشمالية',
          salesCount: 2,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 5,
          pharmacyName:
              'صيدلية السلام',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 2,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 9,
          pharmacyName:
              'صيدلية الرحمة',
          regionName:
              'المنطقة الوسطى',
          salesCount: 4,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 12,
          pharmacyName:
              'صيدلية الغرب',
          regionName:
              'المنطقة الغربية',
          salesCount: 2,
        ),
      ];

      uncovered = const [
        EvaluationCoveragePharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية النور',
          regionName:
              'المنطقة الشمالية',
          salesCount: 0,
        ),
        EvaluationCoveragePharmacyModel(
          pharmacyId: 7,
          pharmacyName:
              'صيدلية الندى',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 0,
        ),
      ];

      score = 32;
  }

  final int coveredCount =
      covered.length;

  final int uncoveredCount =
      uncovered.length;

  final int total =
      coveredCount + uncoveredCount;

  final double percentage =
      total == 0
          ? 0.0
          : (coveredCount / total) * 100;

  return EvaluationCoverageDetailsModel(
    month: month,
    year: year,

    regionId:
        regionId,

    regionName:
        regionName,

    coveredCount:
        coveredCount,

    uncoveredCount:
        uncoveredCount,

    totalPharmacies:
        total,

    percentage:
        percentage,

    score:
        score,

    maxScore:
        35,

    coveredPharmacies:
        covered,

    uncoveredPharmacies:
        uncovered,
  );
}// =========================================================
// UC-208 - Repeated Pharmacies
// =========================================================

@override
Future<EvaluationRepeatedPharmaciesDetailsModel>
    getRepeatedPharmaciesDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 600),
  );

  String regionName =
      'جميع المناطق';

  List<EvaluationRepeatedPharmacyModel>
      pharmacies;

  int totalSoldPharmacies;
  double score;

  switch (regionId) {
    case '1':
      regionName =
          'المنطقة الشمالية';

      pharmacies = const [
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 1,
          pharmacyName: 'صيدلية الشفاء',
          regionName: 'المنطقة الشمالية',
          salesCount: 4,
          totalSalesAmount: 42000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 2,
          pharmacyName: 'صيدلية الحياة',
          regionName: 'المنطقة الشمالية',
          salesCount: 3,
          totalSalesAmount: 37000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 3,
          pharmacyName: 'صيدلية الأمل',
          regionName: 'المنطقة الشمالية',
          salesCount: 2,
          totalSalesAmount: 26000,
        ),
      ];

      totalSoldPharmacies = 4;
      score = 16;
      break;

    case '2':
      regionName =
          'المنطقة الجنوبية';

      pharmacies = const [
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 5,
          pharmacyName: 'صيدلية السلام',
          regionName: 'المنطقة الجنوبية',
          salesCount: 3,
          totalSalesAmount: 33000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 6,
          pharmacyName: 'صيدلية الوفاء',
          regionName: 'المنطقة الجنوبية',
          salesCount: 2,
          totalSalesAmount: 24000,
        ),
      ];

      totalSoldPharmacies = 4;
      score = 14;
      break;

    case '3':
      regionName =
          'المنطقة الوسطى';

      pharmacies = const [
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 9,
          pharmacyName: 'صيدلية الرحمة',
          regionName: 'المنطقة الوسطى',
          salesCount: 5,
          totalSalesAmount: 54000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 10,
          pharmacyName: 'صيدلية المدينة',
          regionName: 'المنطقة الوسطى',
          salesCount: 4,
          totalSalesAmount: 47000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 11,
          pharmacyName: 'صيدلية المستقبل',
          regionName: 'المنطقة الوسطى',
          salesCount: 3,
          totalSalesAmount: 39000,
        ),
      ];

      totalSoldPharmacies = 3;
      score = 18;
      break;

    case '4':
      regionName =
          'المنطقة الغربية';

      pharmacies = const [
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 12,
          pharmacyName: 'صيدلية الغرب',
          regionName: 'المنطقة الغربية',
          salesCount: 3,
          totalSalesAmount: 31000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 13,
          pharmacyName: 'صيدلية البركة',
          regionName: 'المنطقة الغربية',
          salesCount: 2,
          totalSalesAmount: 22000,
        ),
      ];

      totalSoldPharmacies = 3;
      score = 15;
      break;

    default:
      pharmacies = const [
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 1,
          pharmacyName: 'صيدلية الشفاء',
          regionName: 'المنطقة الشمالية',
          salesCount: 4,
          totalSalesAmount: 42000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 5,
          pharmacyName: 'صيدلية السلام',
          regionName: 'المنطقة الجنوبية',
          salesCount: 3,
          totalSalesAmount: 33000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 9,
          pharmacyName: 'صيدلية الرحمة',
          regionName: 'المنطقة الوسطى',
          salesCount: 5,
          totalSalesAmount: 54000,
        ),
        EvaluationRepeatedPharmacyModel(
          pharmacyId: 12,
          pharmacyName: 'صيدلية الغرب',
          regionName: 'المنطقة الغربية',
          salesCount: 3,
          totalSalesAmount: 31000,
        ),
      ];

      totalSoldPharmacies = 6;
      score = 17;
  }

  final int repeatedCount =
      pharmacies.length;

  final double percentage =
      totalSoldPharmacies == 0
          ? 0.0
          : (repeatedCount /
                  totalSoldPharmacies) *
              100;

  return EvaluationRepeatedPharmaciesDetailsModel(
    month: month,
    year: year,
    regionId: regionId,
    regionName: regionName,
    repeatedCount: repeatedCount,
    totalSoldPharmacies:
        totalSoldPharmacies,
    percentage: percentage,
    score: score,
    maxScore: 20,
    pharmacies: pharmacies,
  );
}// =========================================================
// UC-209 - One Time Pharmacies
// =========================================================

@override
Future<EvaluationOneTimePharmaciesDetailsModel>
    getOneTimePharmaciesDetails({
  required String regionId,
  required int month,
  required int year,
}) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 600),
  );

  String regionName =
      'جميع المناطق';

  List<EvaluationOneTimePharmacyModel>
      pharmacies;

  int totalSoldPharmacies;

  double score;

  switch (regionId) {
    case '1':
      regionName =
          'المنطقة الشمالية';

      pharmacies = const [
        EvaluationOneTimePharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية النور',
          regionName:
              'المنطقة الشمالية',
          salesCount: 1,
          salesAmount: 18000,
          lastSaleDate:
              '2026-08-10',
        ),
      ];

      totalSoldPharmacies = 4;
      score = 8;
      break;

    case '2':
      regionName =
          'المنطقة الجنوبية';

      pharmacies = const [
        EvaluationOneTimePharmacyModel(
          pharmacyId: 7,
          pharmacyName:
              'صيدلية الندى',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 1,
          salesAmount: 15000,
          lastSaleDate:
              '2026-08-08',
        ),
        EvaluationOneTimePharmacyModel(
          pharmacyId: 8,
          pharmacyName:
              'صيدلية الروضة',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 1,
          salesAmount: 12000,
          lastSaleDate:
              '2026-08-12',
        ),
      ];

      totalSoldPharmacies = 4;
      score = 7;
      break;

    case '3':
      regionName =
          'المنطقة الوسطى';

      pharmacies = const [
        EvaluationOneTimePharmacyModel(
          pharmacyId: 15,
          pharmacyName:
              'صيدلية الأمان',
          regionName:
              'المنطقة الوسطى',
          salesCount: 1,
          salesAmount: 21000,
          lastSaleDate:
              '2026-08-09',
        ),
      ];

      totalSoldPharmacies = 4;
      score = 9;
      break;

    case '4':
      regionName =
          'المنطقة الغربية';

      pharmacies = const [
        EvaluationOneTimePharmacyModel(
          pharmacyId: 14,
          pharmacyName:
              'صيدلية الخير',
          regionName:
              'المنطقة الغربية',
          salesCount: 1,
          salesAmount: 17000,
          lastSaleDate:
              '2026-08-11',
        ),
      ];

      totalSoldPharmacies = 3;
      score = 8;
      break;

    default:
      pharmacies = const [
        EvaluationOneTimePharmacyModel(
          pharmacyId: 4,
          pharmacyName:
              'صيدلية النور',
          regionName:
              'المنطقة الشمالية',
          salesCount: 1,
          salesAmount: 18000,
          lastSaleDate:
              '2026-08-10',
        ),
        EvaluationOneTimePharmacyModel(
          pharmacyId: 7,
          pharmacyName:
              'صيدلية الندى',
          regionName:
              'المنطقة الجنوبية',
          salesCount: 1,
          salesAmount: 15000,
          lastSaleDate:
              '2026-08-08',
        ),
        EvaluationOneTimePharmacyModel(
          pharmacyId: 14,
          pharmacyName:
              'صيدلية الخير',
          regionName:
              'المنطقة الغربية',
          salesCount: 1,
          salesAmount: 17000,
          lastSaleDate:
              '2026-08-11',
        ),
      ];

      totalSoldPharmacies = 7;
      score = 8;
  }

  final int oneTimeCount =
      pharmacies.length;

  final double percentage =
      totalSoldPharmacies == 0
          ? 0.0
          : (oneTimeCount /
                  totalSoldPharmacies) *
              100;

  return EvaluationOneTimePharmaciesDetailsModel(
    month: month,
    year: year,

    regionId:
        regionId,

    regionName:
        regionName,

    oneTimeCount:
        oneTimeCount,

    totalSoldPharmacies:
        totalSoldPharmacies,

    percentage:
        percentage,

    score:
        score,

    maxScore:
        10,

    pharmacies:
        pharmacies,
  );
}
}