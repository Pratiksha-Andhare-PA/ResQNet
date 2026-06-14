import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get emergencyBaseUrl =>
      dotenv.env['EMERGENCY_API_BASE_URL'] ?? '';

  static String get userBaseUrl => dotenv.env['USER_API_BASE_URL'] ?? '';
}
