import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../../screens/login.dart';
import 'profile_edit_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProfileViewScreen({super.key, required this.profile});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late Map<String, dynamic> profile;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  Future<void> logout() async {
    await Amplify.Auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  /// ✅ Parse emergency contacts safely
  List getContacts() {
    final raw = profile["emergency_contacts"];

    if (raw == null) return [];

    if (raw is List) return raw;

    if (raw is String) {
      try {
        return jsonDecode(raw);
      } catch (e) {
        return [];
      }
    }

    return [];
  }

  /// ✅ Helper: check value exists
  bool hasValue(dynamic value) {
    return value != null &&
        value.toString().trim().isNotEmpty &&
        value.toString() != "null";
  }

  String formatList(dynamic value) {
    if (value == null) return "";

    if (value is List) {
      return value.join(", ");
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = getContacts();

    return Scaffold(
      backgroundColor: const Color(0xFF0E3A5B),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF0E3A5B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: logout,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 BASIC INFO
            if (hasValue(profile["name"]) ||
                hasValue(profile["age"]) ||
                hasValue(profile["gender"]) ||
                hasValue(profile["blood_group"])) ...[
              _sectionTitle("Basic Information"),
              const SizedBox(height: 10),

              if (hasValue(profile["name"]))
                _tile(Icons.person, "Name", profile["name"]),

              if (hasValue(profile["age"]))
                _tile(Icons.cake, "Age", profile["age"].toString()),

              if (hasValue(profile["gender"]))
                _tile(Icons.wc, "Gender", profile["gender"]),

              if (hasValue(profile["blood_group"]))
                _tile(Icons.bloodtype, "Blood Group", profile["blood_group"]),

              const SizedBox(height: 20),
            ],

            /// 🔹 MEDICAL INFO
            if (hasValue(profile["allergies"]) ||
                hasValue(profile["medical_conditions"]) ||
                hasValue(profile["medications"])) ...[
              _sectionTitle("Medical Information"),
              const SizedBox(height: 10),

              if (hasValue(profile["allergies"]))
                _tile(
                  Icons.warning,
                  "Allergies",
                  formatList(profile["allergies"]),
                ),

              if (hasValue(profile["medical_conditions"]))
                _tile(
                  Icons.local_hospital,
                  "Conditions",
                  formatList(profile["medical_conditions"]),
                ),

              if (hasValue(profile["medications"]))
                _tile(
                  Icons.medication,
                  "Medications",
                  formatList(profile["medications"]),
                ),

              const SizedBox(height: 20),
            ],

            /// 🔹 EMERGENCY CONTACTS
            if (contacts.isNotEmpty) ...[
              _sectionTitle("Emergency Contacts"),
              const SizedBox(height: 10),

              ...contacts.map((c) {
                if (!hasValue(c["name"]) && !hasValue(c["phone"])) {
                  return const SizedBox();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.contact_phone, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c["name"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (hasValue(c["phone"]))
                              Text(
                                c["phone"],
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),
            ],

            /// 🔹 EDIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileEditScreen(profile: profile),
                    ),
                  );

                  if (updated != null) {
                    setState(() {
                      profile = updated;
                    });
                  }
                },
                child: const Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 🔹 Modern List Tile UI (like real apps)
  Widget _tile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0E3A5B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
