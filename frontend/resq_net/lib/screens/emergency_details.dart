import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmergencyDetailsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String baseUrl; // ✅ PASS THIS

  const EmergencyDetailsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.baseUrl, // ✅ REQUIRED
  });

  @override
  State<EmergencyDetailsScreen> createState() => _EmergencyDetailsScreenState();
}

class _EmergencyDetailsScreenState extends State<EmergencyDetailsScreen> {
  final storage = const FlutterSecureStorage();

  bool loading = true;
  String emergencyFor = "self";

  Map<String, dynamic>? profile;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final allergiesController = TextEditingController();
  final conditionsController = TextEditingController();
  final symptomsController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<String?> getToken() async {
    return await storage.read(key: "cognito_token");
  }

  /// ✅ SAFE URL BUILDER
  Uri buildUri(String path) {
    if (widget.baseUrl.isEmpty) {
      throw Exception("Base URL is empty ❌");
    }
    return Uri.parse("${widget.baseUrl}$path");
  }

  Future<void> fetchProfile() async {
    try {
      final token = await getToken();

      final response = await http.get(
        buildUri("/profile"), // ✅ FIXED
        headers: {"Authorization": token ?? ""},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          profile = data;
        }
      }
    } catch (e) {
      debugPrint("Profile fetch error $e");
    }

    setState(() {
      loading = false;
    });
  }

  bool fieldMissing(String field) {
    if (profile == null) return true;
    return profile![field] == null || profile![field].toString().isEmpty;
  }

  Widget textInput({
    required String label,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildSelfForm() {
    List<Widget> fields = [];

    if (fieldMissing("age")) {
      fields.add(
        textInput(
          label: "Age",
          controller: ageController,
          type: TextInputType.number,
        ),
      );
    }

    if (fieldMissing("gender")) {
      fields.add(textInput(label: "Gender", controller: genderController));
    }

    if (fieldMissing("allergies")) {
      fields.add(
        textInput(label: "Allergies", controller: allergiesController),
      );
    }

    if (fieldMissing("medical_conditions")) {
      fields.add(
        textInput(
          label: "Medical Conditions",
          controller: conditionsController,
        ),
      );
    }

    fields.add(textInput(label: "Symptoms", controller: symptomsController));
    fields.add(
      textInput(label: "Additional Notes", controller: notesController),
    );

    return Column(children: fields);
  }

  Widget buildOtherForm() {
    return Column(
      children: [
        textInput(label: "Patient Name", controller: nameController),
        textInput(
          label: "Age",
          controller: ageController,
          type: TextInputType.number,
        ),
        textInput(label: "Gender", controller: genderController),
        textInput(label: "Allergies", controller: allergiesController),
        textInput(
          label: "Medical Conditions",
          controller: conditionsController,
        ),
        textInput(label: "Symptoms", controller: symptomsController),
        textInput(label: "Additional Notes", controller: notesController),
      ],
    );
  }

  Future<void> submitEmergency() async {
    try {
      final token = await getToken();

      final payload = {
        "emergencyFor": emergencyFor,
        "location": {"lat": widget.latitude, "lng": widget.longitude},
        "patient": {
          "name": nameController.text,
          "age": ageController.text,
          "gender": genderController.text,
          "allergies": allergiesController.text,
          "medical_conditions": conditionsController.text,
        },
        "symptoms": symptomsController.text,
        "notes": notesController.text,
      };

      final response = await http.post(
        buildUri("/createEmergency"), // ✅ FIXED
        headers: {
          "Authorization": token ?? "",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final emergencyId = data["emergencyId"];

        if (!mounted) return;

        Navigator.pushNamed(context, "/hospitals", arguments: emergencyId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed (${response.statusCode})")),
        );
      }
    } catch (e) {
      debugPrint("Create emergency error $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget toggleButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: emergencyFor == "self"
                  ? Colors.red
                  : Colors.grey[300],
            ),
            onPressed: () {
              setState(() => emergencyFor = "self");
            },
            child: const Text("Myself"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: emergencyFor == "other"
                  ? Colors.red
                  : Colors.grey[300],
            ),
            onPressed: () {
              setState(() => emergencyFor = "other");
            },
            child: const Text("Someone Else"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Details")),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Who needs help?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          toggleButtons(),
                          const SizedBox(height: 25),
                          emergencyFor == "self"
                              ? buildSelfForm()
                              : buildOtherForm(),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: submitEmergency,
                              child: const Text("Submit Emergency"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
