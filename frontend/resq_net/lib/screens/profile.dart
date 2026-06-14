import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:resq_net/features/profile/screens/profile_setup_screen.dart';
import 'package:resq_net/features/profile/screens/profile_view_screen.dart';
import 'package:resq_net/features/profile/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  bool profileExists = false;

  Map<String, dynamic>? profileData;
  String phone = "";

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  Future<void> initProfile() async {
    try {
      // Get current Cognito user
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final phoneAttr = attributes.firstWhere(
        (attr) => attr.userAttributeKey.key == "phone_number",
      );
      phone = phoneAttr.value;

      // Fetch profile from backend
      final profile = await ProfileService().getProfile();

      if (profile != null) {
        profileExists = true;
        profileData = profile;
      } else {
        profileExists = false;
      }
    } catch (e) {
      safePrint("Error fetching profile: $e");
      profileExists = false; // fallback to setup screen
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If profile not created, show setup screen
    if (!profileExists) {
      return const ProfileSetupScreen();
    }

    // Profile exists, show view screen
    return ProfileViewScreen(profile: profileData!);
  }
}
