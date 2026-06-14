import 'package:flutter/material.dart';
import '../services/hospital_service.dart';
import 'confirmation_screen.dart';
import 'dart:async';

class HospitalsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final String emergencyId;

  const HospitalsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.emergencyId,
  });

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  List<Map<String, dynamic>> hospitals = [];

  /// ✅ AI TRIAGE
  Map<String, dynamic>? triageData;
  bool aiProcessed = false;

  bool isLoading = true;
  String? error;

  bool isSelecting = false;

  Timer? aiPollingTimer;

  final HospitalService _hospitalService = HospitalService();

  @override
  void initState() {
    super.initState();
    loadHospitals();
    startAiPolling();
  }

  Future<void> loadHospitals() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await _hospitalService.fetchRankedHospitals(
        widget.emergencyId,
      );

      if (!mounted) return;

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        result,
      );

      final Map<String, dynamic> emergency = Map<String, dynamic>.from(
        responseData["emergency"] ?? {},
      );

      final List<Map<String, dynamic>> hospitalList =
          List<Map<String, dynamic>>.from(
            (responseData["hospitals"] ?? []) as List,
          );

      /// ✅ SORTING LOGIC
      hospitalList.sort((a, b) {
        final severity = emergency["severity"] ?? "MEDIUM";

        /// HIGH / CRITICAL => prioritize ICU + ambulance
        if (severity == "HIGH" || severity == "CRITICAL") {
          int scoreA =
              ((a["icuAvailable"] == true) ? 10 : 0) +
              ((a["ambulancesAvailable"] ?? 0) as int);

          int scoreB =
              ((b["icuAvailable"] == true) ? 10 : 0) +
              ((b["ambulancesAvailable"] ?? 0) as int);

          return scoreB.compareTo(scoreA);
        }

        /// LOW / MEDIUM => nearest first
        final distA = (a["distance"] ?? 999).toDouble();
        final distB = (b["distance"] ?? 999).toDouble();

        return distA.compareTo(distB);
      });

      setState(() {
        triageData = emergency;
        aiProcessed = emergency["aiProcessed"] == true;
        hospitals = hospitalList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void startAiPolling() {
    aiPollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final aiData = await _hospitalService.fetchAiStatus(widget.emergencyId);

        if (!mounted) return;

        final processed = aiData["aiProcessed"] == true;

        if (processed) {
          aiPollingTimer?.cancel();

          setState(() {
            aiProcessed = true;

            triageData = aiData;
          });

          await loadHospitals();
        }
      } catch (_) {}
    });
  }

  /// ✅ AI TRIAGE CARD
  Widget triageCard() {
    if (triageData == null) {
      return const SizedBox();
    }

    /// AI STILL PROCESSING
    if (!aiProcessed) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "AI assessment is being prepared. You can still select a hospital immediately.",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final severity = triageData!["severity"] ?? "UNKNOWN";

    Color severityColor = Colors.orange;

    if (severity == "CRITICAL") {
      severityColor = Colors.red;
    } else if (severity == "HIGH") {
      severityColor = Colors.deepOrange;
    } else if (severity == "LOW") {
      severityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(Icons.health_and_safety, color: severityColor),
              const SizedBox(width: 8),
              const Text(
                "AI Emergency Assessment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// SEVERITY BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              severity,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// SCORE
          Text(
            "Severity Score: ${triageData!["severityScore"] ?? 0}/100",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          /// CONDITION
          Text(
            "Possible Condition",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 4),

          Text(triageData!["possibleCondition"] ?? "Unknown"),

          const SizedBox(height: 14),

          /// ACTION
          Text(
            "Recommended Action",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 4),

          Text(triageData!["recommendedAction"] ?? ""),
        ],
      ),
    );
  }

  Widget hospitalCard(Map<String, dynamic> hospital) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HOSPITAL NAME
          Row(
            children: [
              const Icon(Icons.local_hospital, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hospital["name"] ?? "Unknown Hospital",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// DISTANCE
          Text(
            "Distance: ${hospital["distance"] ?? "?"} km",
            style: const TextStyle(color: Colors.black87),
          ),

          const SizedBox(height: 10),

          /// AVAILABILITY
          const Text(
            "Availability",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          /// BEDS
          Row(
            children: [
              const Icon(Icons.bed, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                "General Beds: ${hospital["availableBeds"] ?? "N/A"}",
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// ICU
          Row(
            children: [
              const Icon(Icons.favorite, size: 18, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                hospital["icuAvailable"] == true
                    ? "ICU Available"
                    : "No ICU Beds",
                style: TextStyle(
                  color: hospital["icuAvailable"] == true
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// AMBULANCE
          Row(
            children: [
              const Icon(Icons.local_shipping, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                "Ambulances: ${hospital["ambulancesAvailable"] ?? 0}",
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// SELECT BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSelecting
                  ? null
                  : () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Confirm Selection"),
                          content: Text(
                            "Proceed with ${hospital["name"] ?? "this hospital"}?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Confirm"),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      setState(() => isSelecting = true);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        await _hospitalService.selectHospital(
                          emergencyId: widget.emergencyId,
                          hospitalId: hospital["hospitalId"],
                          hospitalName: hospital["name"],
                        );

                        if (!mounted) return;

                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ConfirmationScreen(hospital: hospital),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context);

                        setState(() => isSelecting = false);

                        String message = "Something went wrong";

                        if (e.toString().contains("409")) {
                          message = "Hospital already selected";
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E3A5B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Select Hospital",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0E3A5B)),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadHospitals,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (hospitals.isEmpty) {
      return const Center(child: Text("No hospitals found nearby"));
    }

    return RefreshIndicator(
      onRefresh: loadHospitals,
      child: ListView.builder(
        itemCount: hospitals.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return triageCard();
          }

          return hospitalCard(hospitals[index - 1]);
        },
      ),
    );
  }

  @override
  void dispose() {
    aiPollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3A5B),
        centerTitle: true,
        title: const Text(
          "Nearby Hospitals",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: buildBody(),
    );
  }
}
