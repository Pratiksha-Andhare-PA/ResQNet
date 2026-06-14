import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:resq_net/screens/triage_screen.dart';
import '../services/location_service.dart';

class LocationConfirmScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String token;

  const LocationConfirmScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.token, // ✅ ADD HERE
  });

  @override
  State<LocationConfirmScreen> createState() => _LocationConfirmScreenState();
}

class _LocationConfirmScreenState extends State<LocationConfirmScreen> {
  String address = "Fetching address...";
  bool isLoadingAddress = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    final result = await LocationService.getAddressFromLatLng(
      widget.latitude,
      widget.longitude,
    );

    if (!mounted) return;

    setState(() {
      address = result ?? "Unknown location";
      isLoadingAddress = false;
    });
  }

  Future<void> _confirmLocation() async {
    if (isSubmitting) return;

    setState(() => isSubmitting = true);

    try {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text("Creating Emergency...")));

      // print("TOKEN: ${widget.token}");

      // final emergency = await EmergencyService.createEmergency(
      //   latitude: widget.latitude,
      //   longitude: widget.longitude,
      //   severity: "HIGH",
      //   symptoms: ["chest pain"],
      //   token: widget.token, // ✅ FIXED
      // );

      // if (!mounted) return;

      // final emergencyId = emergency["emergencyId"];

      // if (emergencyId == null) {
      //   throw Exception("Emergency ID missing from response");
      // }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuickTriageScreen(
            location: {"lat": widget.latitude, "lng": widget.longitude},
            address: address,
            token: widget.token, // ✅ PASS TOKEN
          ),
        ),
      );
    } catch (e) {
      setState(() => isSubmitting = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng userLocation = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3A5B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Confirm Location",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(initialCenter: userLocation, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.code4care.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 45,
                      height: 45,
                      point: userLocation,
                      child: const Icon(
                        Icons.location_on,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: isLoadingAddress
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0E3A5B)),
                  )
                : Row(
                    children: [
                      const Icon(Icons.place, color: Color(0xFF0E3A5B)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (isLoadingAddress || isSubmitting)
                    ? null
                    : _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E3A5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        "Confirm Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
