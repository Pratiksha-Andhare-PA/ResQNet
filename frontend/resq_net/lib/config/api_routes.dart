import 'app_config.dart';

class ApiRoutes {
  /// Emergency APIs
  static String createEmergency() => "${AppConfig.emergencyBaseUrl}/emergency";

  static String getHospitals(String emergencyId) =>
      "${AppConfig.emergencyBaseUrl}/hospitals/ranked?emergencyId=$emergencyId";

  /// User APIs
  static String getUserProfile() => "${AppConfig.userBaseUrl}/users/profile";

  static String updateUserProfile() => "${AppConfig.userBaseUrl}/users/profile";
}
