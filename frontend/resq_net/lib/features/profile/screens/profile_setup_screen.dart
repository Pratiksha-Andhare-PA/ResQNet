import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:resq_net/screens/sos_screen.dart';
import 'package:resq_net/features/profile/services/profile_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();

  String? gender;
  String? bloodGroup;

  final allergiesController = TextEditingController();
  final conditionsController = TextEditingController();
  final medicationsController = TextEditingController();

  bool isLoading = false;

  List<Map<String, TextEditingController>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    fetchPhoneNumber();
    addContact(); // default 1 contact field
  }

  Future<void> fetchPhoneNumber() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final phoneAttr = attributes.firstWhere(
        (attr) => attr.userAttributeKey.key == "phone_number",
      );

      setState(() {
        phoneController.text = phoneAttr.value;
      });
    } catch (e) {
      safePrint("Phone fetch error: $e");
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
        title: const Text("Medical Profile"),
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
              const Text(
                "Basic Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: nameController,
                label: "Full Name *",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: ageController,
                label: "Age",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: phoneController,
                label: "Phone Number",
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              _buildDropdown(
                label: "Gender",
                value: gender,
                items: ["male", "female", "other"],
                onChanged: (value) {
                  setState(() => gender = value);
                },
              ),

              const SizedBox(height: 12),

              _buildDropdown(
                label: "Blood Group",
                value: bloodGroup,
                items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
                onChanged: (value) {
                  setState(() => bloodGroup = value);
                },
              ),

              const SizedBox(height: 28),

              const Text(
                "Medical Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: allergiesController,
                label: "Allergies",
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: conditionsController,
                label: "Medical Conditions",
              ),

              const SizedBox(height: 12),

              _buildTextField(
                controller: medicationsController,
                label: "Current Medications",
              ),

              const SizedBox(height: 28),

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
                    _buildTextField(
                      controller: contact["name"]!,
                      label: "Contact Name",
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: contact["phone"]!,
                      label: "Contact Phone",
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveProfile,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Profile",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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

  void saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    List contacts = emergencyContacts.map((contact) {
      return {"name": contact["name"]!.text, "phone": contact["phone"]!.text};
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
    print(body);

    try {
      await ProfileService().saveProfile(body);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully")),
      );

      final session = await Amplify.Auth.fetchAuthSession();
      final cognitoSession = session as CognitoAuthSession;
      final idToken = cognitoSession.userPoolTokensResult.value.idToken.raw;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SOSScreen(token: idToken)),
      );
    } catch (e) {
      safePrint("PROFILE SAVE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }
}
