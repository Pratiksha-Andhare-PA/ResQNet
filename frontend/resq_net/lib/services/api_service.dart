import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class ApiService {
  final String baseUrl;

  /// Constructor → pass base URL dynamically
  ApiService(this.baseUrl);

  /// Timeout duration
  static const Duration _timeout = Duration(seconds: 15);

  /// Get Cognito ID Token
  Future<String?> _getToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session is CognitoAuthSession) {
        final tokens = session.userPoolTokensResult.valueOrNull;

        if (tokens != null) {
          return tokens.idToken.raw;
        }
      }
    } catch (e) {
      safePrint("🔴 TOKEN ERROR: $e");
    }

    return null;
  }

  /// Common Headers
  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// Handle Response
  dynamic _handleResponse(http.Response response) {
    safePrint("📡 STATUS: ${response.statusCode}");
    safePrint("📦 BODY: ${response.body}");

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded; // ✅ can be Map OR List
    } else {
      throw Exception(
        decoded?["message"] ?? "Request failed (${response.statusCode})",
      );
    }
  }

  /// GET REQUEST
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    safePrint("➡️ GET: $url");

    try {
      final response = await http
          .get(url, headers: await _headers())
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  /// POST REQUEST
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("$baseUrl$endpoint");

    safePrint("➡️ POST: $url");
    safePrint("📤 BODY: $body");

    try {
      final response = await http
          .post(url, headers: await _headers(), body: jsonEncode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  /// PUT REQUEST (Optional but useful)
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("$baseUrl$endpoint");

    safePrint("➡️ PUT: $url");

    try {
      final response = await http
          .put(url, headers: await _headers(), body: jsonEncode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("PUT error: $e");
    }
  }

  /// DELETE REQUEST (Optional)
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    safePrint("➡️ DELETE: $url");

    try {
      final response = await http
          .delete(url, headers: await _headers())
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("DELETE error: $e");
    }
  }
}
