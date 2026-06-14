class UserProfile {
  String? name;
  int? age;
  String? gender;
  String? bloodGroup;

  String? allergies;
  String? conditions;
  String? medications;

  List<Map<String, String>>? emergencyContacts;

  UserProfile({
    this.name,
    this.age,
    this.gender,
    this.bloodGroup,
    this.allergies,
    this.conditions,
    this.medications,
    this.emergencyContacts,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "gender": gender,
      "blood_group": bloodGroup,
      "allergies": allergies,
      "medical_conditions": conditions,
      "medications": medications,
      "emergency_contacts": emergencyContacts,
    };
  }
}
