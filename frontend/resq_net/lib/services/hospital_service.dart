import '../config/app_config.dart';
import 'api_service.dart';

class HospitalService {
  final ApiService _api = ApiService(AppConfig.emergencyBaseUrl);

  /// 🔹 FETCH RANKED HOSPITALS
  Future<Map<String, dynamic>> fetchRankedHospitals(String emergencyId) async {
    try {
      final response = await _api.get(
        "/hospitals/ranked?emergencyId=$emergencyId",
      );

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print("Hospital fetch error: $e");

      return {"emergency": {}, "hospitals": []};
    }
  }

  /// 🔹 FETCH AI STATUS
  Future<Map<String, dynamic>> fetchAiStatus(String emergencyId) async {
    try {
      final response = await _api.get("/emergency/$emergencyId");
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print("AI status fetch error: $e");
      return {};
    }
  }

  /// 🔹 SELECT HOSPITAL
  Future<void> selectHospital({
    required String emergencyId,
    required String hospitalId,
    required String hospitalName,
  }) async {
    try {
      await _api.post("/emergency/selectHospital", {
        "emergencyId": emergencyId,
        "hospitalId": hospitalId,
        "hospitalName": hospitalName,
      });
    } catch (e) {
      print("Select hospital error: $e");
      rethrow;
    }
  }
}
