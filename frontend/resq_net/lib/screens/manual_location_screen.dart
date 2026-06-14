import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resq_net/screens/location_confirm_screen.dart';
import '../services/location_service.dart';
import 'map_screen.dart';

class ManualLocationScreen extends StatefulWidget {
  final String token;

  const ManualLocationScreen({super.key, required this.token});

  @override
  State<ManualLocationScreen> createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> suggestions = [];
  bool isLoading = false;
  Timer? _debounce;

  void _searchLocation(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) {
        setState(() => suggestions = []);
        return;
      }

      setState(() => isLoading = true);

      final results = await LocationService.searchPlaces(query);

      if (!mounted) return;

      setState(() {
        suggestions = results;
        isLoading = false;
      });
    });
  }

  void _openMap(double lat, double lng, String address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          latitude: lat,
          longitude: lng,
          address: address,
          token: widget.token,
        ),
      ),
    );

    // if (result != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => HospitalsScreen(
    //         latitude: result["lat"],
    //         longitude: result["lng"],
    //         address: result["address"],
    //       ),
    //     ),
    //   );
    // }

    if (result != null && result["lat"] != null && result["lng"] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LocationConfirmScreen(
            latitude: result["lat"],
            longitude: result["lng"],
            token: widget.token, // ✅ PASS TOKEN
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3A5B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Enter Location",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          /// SEARCH FIELD
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFF0E3A5B)),
                hintText: "Search location...",
                border: InputBorder.none,
              ),
              onChanged: _searchLocation,
            ),
          ),

          /// LOADING INDICATOR
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircularProgressIndicator(color: Color(0xFF0E3A5B)),
            ),

          /// SUGGESTIONS
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final place = suggestions[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF0E3A5B),
                    ),
                    title: Text(
                      place["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.5,
                      ),
                    ),
                    onTap: () {
                      _openMap(place["lat"], place["lng"], place["name"]);
                    },
                  ),
                );
              },
            ),
          ),

          /// FALLBACK SEARCH BUTTON
          if (!isLoading && suggestions.isEmpty && _controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await LocationService.getLatLngFromAddress(
                      _controller.text,
                    );

                    if (result != null) {
                      _openMap(
                        result["lat"]!,
                        result["lng"]!,
                        _controller.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E3A5B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Search location on map",
                    style: TextStyle(
                      fontSize: 15,
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
