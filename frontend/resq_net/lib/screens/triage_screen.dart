import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resq_net/screens/hospitals_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuickTriageScreen extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final Map<String, double> location;
  final String address;
  final String token;

  const QuickTriageScreen({
    super.key,
    required this.location,
    required this.address,
    required this.token,
    this.userProfile,
  });

  @override
  State<QuickTriageScreen> createState() => _QuickTriageScreenState();
}

class _QuickTriageScreenState extends State<QuickTriageScreen> {
  String patientType = "self";
  Set<String> selectedSymptoms = {};
  String? ageGroup;
  String ambulance = "unsure";
  bool? conscious;
  bool? breathing;
  bool isSubmitting = false;

  final List<String> symptoms = [
    "Chest Pain",
    "Accident",
    "Unconscious",
    "Breathing Problem",
    "Bleeding",
    "Stroke Signs",
  ];

  @override
  void initState() {
    super.initState();
    _autoFillFromProfile();
  }

  void _autoFillFromProfile() {
    if (widget.userProfile != null && patientType == "self") {
      final age = widget.userProfile!['age'];
      if (age != null) {
        if (age < 13)
          ageGroup = "child";
        else if (age < 60)
          ageGroup = "adult";
        else
          ageGroup = "elderly";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLandscape
            ? Row(children: [Expanded(child: _buildForm())])
            : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Who is this for?"),
        _choiceChips(["Myself", "Someone else"], patientType, (val) {
          setState(() {
            patientType = val;
            _autoFillFromProfile();
          });
        }),

        const SizedBox(height: 20),

        /// SYMPTOMS
        _sectionTitle("What is happening? *"),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptoms.map((s) {
            final isSelected = selectedSymptoms.contains(s);

            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected
                      ? selectedSymptoms.remove(s)
                      : selectedSymptoms.add(s);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0E3A5B) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF0E3A5B),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    Text(
                      s,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// AGE GROUP
        _sectionTitle("Age Group"),
        DropdownButtonFormField<String>(
          value: ageGroup,
          selectedItemBuilder: (context) {
            return [
              "Child (0-12)",
              "Adult (13-59)",
              "Elderly (60+)",
              "Unknown",
            ].map((label) {
              return Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
          items:
              [
                {"label": "Child (0-12)", "value": "child"},
                {"label": "Adult (13-59)", "value": "adult"},
                {"label": "Elderly (60+)", "value": "elderly"},
                {"label": "Unknown", "value": "unknown"},
              ].map((e) {
                return DropdownMenuItem(
                  value: e["value"],
                  child: Text(e["label"]!),
                );
              }).toList(),
          onChanged: (val) => setState(() => ageGroup = val),
          decoration: _inputDecoration(),
        ),

        const SizedBox(height: 20),

        /// CONDITION
        _sectionTitle("Condition"),
        _conditionSelector("Is the person conscious?", conscious, (v) {
          setState(() => conscious = v);
        }),
        _conditionSelector("Is breathing normal?", breathing, (v) {
          setState(() => breathing = v);
        }),

        const SizedBox(height: 20),

        /// TRANSPORT
        _sectionTitle("Transport"),
        DropdownButtonFormField<String>(
          value: ambulance,
          selectedItemBuilder: (context) {
            return ["🚑 Need Ambulance", "🚗 Own Transport", "❓ Not Sure"].map((
              label,
            ) {
              return Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
          items:
              [
                {"label": "🚑 Need Ambulance", "value": "ambulance"},
                {"label": "🚗 Own Transport", "value": "self"},
                {"label": "❓ Not Sure", "value": "unsure"},
              ].map((e) {
                return DropdownMenuItem(
                  value: e["value"],
                  child: Text(e["label"]!),
                );
              }).toList(),
          onChanged: (v) => setState(() => ambulance = v!),
          decoration: _inputDecoration(),
        ),

        const SizedBox(height: 30),

        /// SUBMIT
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Get Nearby Hospitals",
                    style: TextStyle(color: Color(0xFF0E3A5B), fontSize: 17),
                  ),
          ),
        ),
      ],
    );
  }

  /// API CALL
  Future<void> _submit() async {
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one symptom")),
      );
      return;
    }

    setState(() => isSubmitting = true); // ✅ START LOADING

    final payload = {
      "location": widget.location,
      "patientType": patientType,
      "symptoms": selectedSymptoms.toList(),
      "ageGroup": ageGroup ?? "unknown",
      "conscious": conscious,
      "breathing": breathing,
      "ambulancePreference": ambulance,
      "severity": "PENDING",
      "aiProcessed": false,
    };

    try {
      // print("BASE URL: ${dotenv.env['EMERGENCY_API_BASE_URL']}");
      final response = await http.post(
        Uri.parse("${dotenv.env['EMERGENCY_API_BASE_URL']}/emergency"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      final emergencyId = data["emergencyId"];

      if (emergencyId == null) {
        throw Exception("Emergency ID missing");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HospitalsScreen(
            latitude: widget.location["lat"]!,
            longitude: widget.location["lng"]!,
            address: widget.address,
            emergencyId: emergencyId,
          ),
        ),
      );
    } catch (e) {
      setState(() => isSubmitting = false); // ❌ STOP LOADER ON ERROR

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// UI HELPERS

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _choiceChips(
    List<String> options,
    String selected,
    Function(String) onTap,
  ) {
    return Wrap(
      spacing: 8,
      children: options.map((o) {
        final value = o == "Myself" ? "self" : "someone_else";
        final isSelected = selected == value;

        return GestureDetector(
          onTap: () => onTap(value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0E3A5B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF0E3A5B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                Text(
                  o,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _conditionSelector(
    String title,
    bool? value,
    Function(bool?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 6),
        Row(
          children: [
            _pill("Yes", true, value, onChanged),
            const SizedBox(width: 8),
            _pill("No", false, value, onChanged),
            const SizedBox(width: 8),
            _pill("Not Sure", null, value, onChanged),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _pill(
    String text,
    bool? val,
    bool? groupVal,
    Function(bool?) onChanged,
  ) {
    final isSelected = groupVal == val;

    return GestureDetector(
      onTap: () => onChanged(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0E3A5B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0E3A5B) : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(Icons.check_circle, size: 14, color: Colors.white),
              ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(border: OutlineInputBorder());
  }
}
