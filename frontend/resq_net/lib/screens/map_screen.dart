import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final String token;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.token,
    this.address,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _address;
  bool _loadingAddress = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    if (widget.address != null) {
      setState(() {
        _address = widget.address;
        _loadingAddress = false;
      });
      return;
    }

    final address = await LocationService.getAddressFromLatLng(
      widget.latitude,
      widget.longitude,
    );

    if (!mounted) return;

    setState(() {
      _address = address ?? "Address not found";
      _loadingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3A5B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Select Location",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      body: Column(
        children: [
          /// MAP
          Expanded(
            child: FlutterMap(
              options: MapOptions(initialCenter: location, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.code4care',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ADDRESS CARD
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _loadingAddress
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0E3A5B)),
                  )
                : Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF0E3A5B)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _address ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          /// CONFIRM BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E3A5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "lat": widget.latitude,
                    "lng": widget.longitude,
                    "address": _address,
                  });
                },
                child: const Text(
                  "Select Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
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
