import '../dev/dev_accounts.dart';

abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static bool get hasBackend => apiBaseUrl.isNotEmpty;

  static const String apiRealCalls = String.fromEnvironment('API_REAL_CALLS');

  static const String supportPhone = String.fromEnvironment(
    'SUPPORT_PHONE',
    defaultValue: DevAccounts.enabled ? '+91 00000 00000' : '',
  );

  static const bool ondcDemoLinking = bool.fromEnvironment(
    'ONDC_DEMO_LINKING',
    defaultValue: true,
  );

  static const String storeUrl = String.fromEnvironment('STORE_URL');
}
