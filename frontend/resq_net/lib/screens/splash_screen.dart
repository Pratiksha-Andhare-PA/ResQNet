import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:resq_net/screens/login.dart';
import 'package:resq_net/screens/sos_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 4));

    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (!mounted) return;

      if (session.isSignedIn) {
        final cognitoSession = session as CognitoAuthSession;

        final idToken = cognitoSession.userPoolTokensResult.value.idToken.raw;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SOSScreen(token: idToken), // ✅ PASS TOKEN
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3A5B),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.health_and_safety, color: Colors.white, size: 80),

            const SizedBox(height: 20),

            const Text(
              "ResQNet",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
