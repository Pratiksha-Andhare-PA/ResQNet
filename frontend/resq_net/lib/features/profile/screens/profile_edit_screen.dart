import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProfileEditScreen({super.key, required this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController ageController;

  String? gender;
  String? bloodGroup;

  late TextEditingController allergiesController;
  late TextEditingController conditionsController;
  late TextEditingController medicationsController;

  List<Map<String, TextEditingController>> emergencyContacts = [];

  bool isLoading = false;

  String listToText(dynamic value) {
    if (value == null) return "";

    if (value is List) {
      return value.join(", ");
    }

    return value.toString();
  }

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;

    nameController = TextEditingController(text: profile["name"]);
    ageController = TextEditingController(
      text: profile["age"]?.toString() ?? "",
    );

    gender = profile["gender"];
    bloodGroup = profile["blood_group"];

    allergiesController = TextEditingController(
      text: listToText(profile["allergies"]),
    );

    conditionsController = TextEditingController(
      text: listToText(profile["medical_conditions"]),
    );

    medicationsController = TextEditingController(
      text: listToText(profile["medications"]),
    );

    /// ✅ LOAD EXISTING CONTACTS
    final rawContacts = profile["emergency_contacts"];

    List contacts = [];

    if (rawContacts is List) {
      contacts = rawContacts;
    } else if (rawContacts is String) {
      try {
        contacts = jsonDecode(rawContacts);
      } catch (_) {}
    }

    if (contacts.isNotEmpty) {
      for (var c in contacts) {
        emergencyContacts.add({
          "name": TextEditingController(text: c["name"] ?? ""),
          "phone": TextEditingController(text: c["phone"] ?? ""),
        });
      }
    } else {
      addContact(); // default
    }
  }

  void addContact() {
    setState(() {
      emergencyContacts.add({
        "name": TextEditingController(),
        "phone": TextEditingController(),
      });
    });
  }

  void removeContact(int index) {
    setState(() {
      emergencyContacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3A5B),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF0E3A5B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 BASIC INFO
              const Text(
                "Basic Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _field(
                nameController,
                "Full Name *",
                validator: (v) {
                  if (v == null || v.isEmpty) return "Name required";
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _field(ageController, "Age", keyboard: TextInputType.number),

              const SizedBox(height: 12),

              _dropdown("Gender", gender, ["male", "female", "other"], (v) {
                setState(() => gender = v);
              }),

              const SizedBox(height: 12),

              _dropdown(
                "Blood Group",
                bloodGroup,
                ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
                (v) {
                  setState(() => bloodGroup = v);
                },
              ),

              const SizedBox(height: 28),

              /// 🔹 MEDICAL INFO
              const Text(
                "Medical Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _field(allergiesController, "Allergies"),

              const SizedBox(height: 12),

              _field(conditionsController, "Medical Conditions"),

              const SizedBox(height: 12),

              _field(medicationsController, "Medications"),

              const SizedBox(height: 28),

              /// 🔹 CONTACTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Emergency Contacts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: addContact,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...List.generate(emergencyContacts.length, (index) {
                final contact = emergencyContacts[index];

                return Column(
                  children: [
                    _field(contact["name"]!, "Contact Name"),
                    const SizedBox(height: 8),
                    _field(
                      contact["phone"]!,
                      "Contact Phone",
                      keyboard: TextInputType.phone,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => removeContact(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),

              const SizedBox(height: 30),

              /// 🔹 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: updateProfile,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Profile"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        floatingLabelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
    );
  }

  void updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final contacts = emergencyContacts.map((c) {
      return {"name": c["name"]!.text, "phone": c["phone"]!.text};
    }).toList();

    final body = {
      "name": nameController.text,
      "age": ageController.text.isEmpty ? null : int.parse(ageController.text),

      "gender": gender?.toLowerCase(),

      "blood_group": bloodGroup,

      "allergies": allergiesController.text.trim().isEmpty
          ? []
          : allergiesController.text.split(',').map((e) => e.trim()).toList(),

      "medical_conditions": conditionsController.text.trim().isEmpty
          ? []
          : conditionsController.text.split(',').map((e) => e.trim()).toList(),

      "medications": medicationsController.text.trim().isEmpty
          ? []
          : medicationsController.text.split(',').map((e) => e.trim()).toList(),

      "emergency_contacts": contacts,
    };

    print("PROFILE BODY:");
    print(jsonEncode(body));

    await ProfileService().saveProfile(body);

    setState(() => isLoading = false);

    Navigator.pop(context, body);
  }
}
