import 'package:resq_net/config/app_config.dart';
import 'package:resq_net/services/api_service.dart';

class ProfileService {
  final api = ApiService(AppConfig.userBaseUrl);

  /// Save or update user profile
  Future<Map<String, dynamic>?> saveProfile(Map<String, dynamic> body) async {
    final response = await api.post("/users/profile", body);

    // Expecting response to be { "profile": {...} }
    //if (response == null) return null;
    return response['profile'] != null
        ? Map<String, dynamic>.from(response['profile'])
        : null;
  }

  /// Get profile from backend
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await api.get("/users/profile");

      if (response['profile'] == null) {
        return null;
      }

      return Map<String, dynamic>.from(response['profile']);
    } catch (e) {
      throw Exception("Failed to fetch profile: $e");
    }
  }
}
