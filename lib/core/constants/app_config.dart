// lib/core/constants/app_config.dart
class AppConfig {
  static const bankLookupBaseUrl = 'https://api.banklookup.net';
  static const bankLookupApiKey = String.fromEnvironment('BANKLOOKUP_API_KEY');    // --dart-define
  static const bankLookupApiSecret = String.fromEnvironment('BANKLOOKUP_API_SECRET'); // --dart-define
}
