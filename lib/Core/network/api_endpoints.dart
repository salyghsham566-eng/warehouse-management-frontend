class ApiEndpoints {
  ApiEndpoints._();
//التعديل 
  static const String baseUrl =
      'https://example.com/api/v1';
static const String login =
    '/representative/login';
  static const String companies = '/companies';
  static const String pharmacies = '/pharmacies';
  static const String orders = '/orders';
  static const String collectionPharmacies =
      '/collection/pharmacies';
      static String collectionPharmacyDetails(
  String pharmacyId,
) {
  return '/collection/pharmacies/${Uri.encodeComponent(pharmacyId)}';
}
static const String collectionPayments =
    '/collection/payments';
    static String collectionPaymentDetails(
  String paymentId,
) {
  return '/collection/payments/'
      '${Uri.encodeComponent(paymentId)}';
}
static const String financialDashboard =
    '/representative/financial/dashboard';
   // UC-185
static const String financialPharmacies =
    '/representative/financial/pharmacies'; 
static String financialIndicatorDetails(
  String indicatorId,
) {
  return '/representative/financial/indicators/'
      '${Uri.encodeComponent(indicatorId)}/details';
}
// UC-187
static String financialPharmacyDetails(
  String pharmacyId,
) {
  return '/representative/financial/pharmacies/'
      '${Uri.encodeComponent(pharmacyId)}';
}
// UC-188
static String financialPharmacyStatement(
  String pharmacyId,
) {
  return '/representative/financial/pharmacies/'
      '${Uri.encodeComponent(pharmacyId)}/statement';
}// UC-189
static const String financialRegionStatement =
    '/representative/financial/regions/statement';
  static const String workPlans =
    '/representative/work-plans';

static String workPlanDetails(int planId) {
  return '/representative/work-plans/$planId';
}

static String workPlanGoalDetails({
  required int planId,
  required int goalId,
}) {
  return '/representative/work-plans/$planId/goals/$goalId';
}
static String workPlanPersonalNotes(
  int planId,
) {
  return '/representative/work-plans/$planId/personal-notes';
}
static String workPlanOfficialNotes(
  int planId,
) {
  return '/representative/work-plans/$planId/notes';
}
// =========================================================
// Evaluation - UC-204
// =========================================================

static const String currentEvaluation =
    '/representative/evaluation/current';
    // UC-206
static const String evaluationTargetDetails =
    '/representative/evaluation/target-details';
    // UC-207
static const String
    evaluationCoverageDetails =
    '/representative/evaluation/coverage-details';
    // UC-208
static const String
    evaluationRepeatedPharmaciesDetails =
    '/representative/evaluation/repeated-pharmacies-details';
    // UC-209
static const String
    evaluationOneTimePharmaciesDetails =
    '/representative/evaluation/one-time-pharmacies-details';
}