import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  // Weather
  static String get openWeatherKey => dotenv.env['OPEN_WEATHER_KEY'] ?? '';

  // Vietmap
  static String get vietmapKey => dotenv.env['VIETMAP_KEY'] ?? '';

  // Firebase
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // BankLookup
  static String get bankKey => dotenv.env['BANKLOOKUP_API_KEY'] ?? '';
  static String get bankSecret => dotenv.env['BANKLOOKUP_API_SECRET'] ?? '';
}
