class AppEnvironment {
  AppEnvironment._();

  static const bool useRemoteData = bool.fromEnvironment(
    'USE_REMOTE_DATA',
    defaultValue: false,
  );
}