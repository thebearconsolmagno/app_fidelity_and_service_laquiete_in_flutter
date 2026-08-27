
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );
  static const String systemUser = String.fromEnvironment('SYSTEM_USER');
  static const String systemPass = String.fromEnvironment('SYSTEM_PASS');
}
