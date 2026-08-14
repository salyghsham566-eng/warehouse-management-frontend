class AppEnvironment {
  AppEnvironment._();

  static const bool useRemoteData = bool.fromEnvironment(
    'USE_REMOTE_DATA',
    defaultValue: false,
  );// UC-208
static const String
    evaluationRepeatedPharmaciesDetails =
    '/representative/evaluation/repeated-pharmacies-details';
}