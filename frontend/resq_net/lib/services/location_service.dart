import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LocationService {
  static const String _baseUrl = "https://nominatim.openstreetmap.org";

  static const Map<String, String> _headers = {"User-Agent": "resq-net-app"};

  /// ======================================
  /// 📍 GET CURRENT GPS LOCATION
  /// ======================================

  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission;

      /// 1️⃣ Check permission
      permission = await Geolocator.checkPermission();

      /// 2️⃣ Ask permission if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      /// 3️⃣ If permanently denied → open settings
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return null;
      }

      /// 4️⃣ Check if GPS is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      /// 5️⃣ Get location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint("Location error: $e");
      return null;
    }
  }

  /// ======================================
  /// 🔎 PLACE AUTOCOMPLETE SEARCH
  /// ======================================
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      if (query.length < 3) return [];

      String modifiedQuery = "$query, Maharashtra, India";
      final encodedQuery = Uri.encodeComponent(modifiedQuery);

      final url =
          "$_baseUrl/search?q=$encodedQuery&format=json&addressdetails=1&limit=5&countrycodes=in";

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data.map<Map<String, dynamic>>((place) {
          return {
            "name": place["display_name"],
            "lat": double.parse(place["lat"]),
            "lng": double.parse(place["lon"]),
          };
        }).toList();
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }

    return [];
  }

  /// ======================================
  /// 🏠 MANUAL ADDRESS → LAT LNG
  /// ======================================
  static Future<Map<String, double>?> getLatLngFromAddress(
    String address,
  ) async {
    try {
      String modifiedQuery = "$address, Maharashtra, India";
      final encodedAddress = Uri.encodeComponent(modifiedQuery);

      final url =
          "$_baseUrl/search?q=$encodedAddress&format=json&limit=1&countrycodes=in";

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.isNotEmpty) {
          return {
            "lat": double.parse(data[0]["lat"]),
            "lng": double.parse(data[0]["lon"]),
          };
        }
      }
    } catch (e) {
      debugPrint("Manual Search Error: $e");
    }

    return null;
  }

  /// ======================================
  /// 🔁 REVERSE GEOCODING
  /// LAT LNG → ADDRESS
  /// ======================================
  static Future<String?> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = "$_baseUrl/reverse?lat=$latitude&lon=$longitude&format=json";

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["display_name"];
      }
    } catch (e) {
      debugPrint("Reverse Geocoding Error: $e");
    }

    return null;
  }
}
