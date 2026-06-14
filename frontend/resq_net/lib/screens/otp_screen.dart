import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:resq_net/screens/sos_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  int seconds = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  Future<void> verifyOTP() async {
    try {
      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: otpController.text.trim(),
      );

      if (result.isSignedIn) {
        final session = await Amplify.Auth.fetchAuthSession();

        final cognitoSession = session as CognitoAuthSession;

        final idToken = cognitoSession.userPoolTokensResult.value.idToken.raw;

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SOSScreen(token: idToken)),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  Future<void> resendOTP() async {
    try {
      await Amplify.Auth.resendSignUpCode(username: widget.phoneNumber);

      setState(() {
        seconds = 30;
      });

      startTimer();
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Verify OTP",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter OTP",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  counterStyle: TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: verifyOTP,
                child: const Text("Verify OTP"),
              ),

              const SizedBox(height: 20),

              seconds == 0
                  ? TextButton(
                      onPressed: resendOTP,
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Text(
                      "Resend in $seconds s",
                      style: const TextStyle(color: Colors.white70),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
