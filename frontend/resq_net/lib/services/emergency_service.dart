import '../config/app_config.dart';
import 'api_service.dart';

class EmergencyService {
  final ApiService _api = ApiService(AppConfig.emergencyBaseUrl);

  Future<Map<String, dynamic>> createEmergency({
    required double latitude,
    required double longitude,
    required String severity,
    required List<String> symptoms,
    required String ageGroup,
    required bool? conscious,
    required bool? breathing,
    required String ambulancePreference,
  }) async {
    final response = await _api.post("/emergency", {
      "location": {"lat": latitude, "lng": longitude},
      "severity": severity,
      "symptoms": symptoms,
      "ageGroup": ageGroup,
      "conscious": conscious,
      "breathing": breathing,
      "ambulancePreference": ambulancePreference,
    });

    return response;
  }
}
