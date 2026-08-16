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
// UC-211
static const String evaluationWorkPlans =
    '/representative/evaluation/work-plans';
// UC-212
static const String evaluationArchive =
    '/representative/evaluation/archive';
    // =========================================================
// Offers & Discounts - UC-213
// =========================================================

static const String representativeOffers =
    '/representative/offers';
    // =========================================================
// UC-214 -> UC-218
// =========================================================

static String promotionalBasketDetails(
  String basketId,
) {
  return '/representative/offers/baskets/$basketId';
}
// =========================================================
// UC-220 -> UC-221
// =========================================================

static const String usedOffersHistory =
    '/representative/offers/history';
    static String activeOfferDetails(
  String offerId,
) {
  return '/representative/offers/$offerId';
}
    // =========================================================
    // Warehouse - UC-222
    // =========================================================

    static const String warehouseOverview =
        '/representative/warehouse/overview';
static const String warehouseCompanies =
    '/representative/warehouse/companies';
    // UC-225
static String warehouseCompanyMedicines(
  String companyId,
) {
  return '/representative/warehouse/companies/'
      '${Uri.encodeComponent(companyId)}/medicines';
}// UC-227
static String warehouseMedicineDetails(
  String medicineId,
) {
  return '/representative/warehouse/medicines/'
      '${Uri.encodeComponent(medicineId)}';
}// =========================================================
// UC-230 + UC-231
// =========================================================
static const String warehouseItems =
    '/representative/warehouse/items';
    // =========================================================
// UC-232
// =========================================================
static const String warehouseInventoryFile =
    '/representative/warehouse/inventory-file';

// =========================================================
// UC-233 + UC-234
// =========================================================
static String warehouseInventoryFilePdf(
  String fileId,
) {
  return '/representative/warehouse/inventory-file/'
      '${Uri.encodeComponent(fileId)}/pdf';
}// =========================================================
// Pharmacies - UC-235 -> UC-241
// =========================================================
static const String representativePharmacies =
    '/representative/pharmacies';
    // =========================================================
// UC-242 -> UC-245
// =========================================================
static String representativePharmacyDetails(
  String pharmacyId,
) {
  return '/representative/pharmacies/'
      '${Uri.encodeComponent(pharmacyId)}';

}// =========================================================
// Account Management - UC-261 -> UC-266
// =========================================================
static const String representativeAccount =
    '/representative/account';
    static const String
    representativeAccountPassword =
    '/representative/account/password';
    // =========================================================
// Notifications - UC-246 -> UC-260
// =========================================================

static const String representativeNotifications =
    '/representative/notifications';

// UC-249
static String notificationDetails(
  String notificationId,
) {
  return '/representative/notifications/'
      '${Uri.encodeComponent(notificationId)}';
}

// UC-253
static String notificationMarkRead(
  String notificationId,
) {
  return '/representative/notifications/'
      '${Uri.encodeComponent(notificationId)}/read';
}

// UC-254
static const String notificationsMarkAllRead =
    '/representative/notifications/read-all';

// UC-260
static const String notificationsArchive =
    '/representative/notifications/archive';
}