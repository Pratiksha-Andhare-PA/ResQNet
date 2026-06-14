import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;

  Future<void> sendOTP() async {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid phone number")));
      return;
    }

    final fullPhone = "+91$phone";

    setState(() => loading = true);

    try {
      final result = await Amplify.Auth.signIn(
        username: fullPhone,
        options: const SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
            authFlowType: AuthenticationFlowType.userAuth,
          ),
        ),
      );

      if (result.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithOtpCode) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OTPScreen(phoneNumber: fullPhone)),
        );
      }
    }
    // NEW USER → CREATE ACCOUNT
    on UserNotFoundException {
      try {
        await Amplify.Auth.signUp(
          username: fullPhone,
          password: "TempPassword@123",
          options: SignUpOptions(
            userAttributes: {CognitoUserAttributeKey.phoneNumber: fullPhone},
          ),
        );

        // After signup trigger OTP login
        final result = await Amplify.Auth.signIn(
          username: fullPhone,
          options: const SignInOptions(
            pluginOptions: CognitoSignInPluginOptions(
              authFlowType: AuthenticationFlowType.userAuth,
            ),
          ),
        );

        if (result.nextStep.signInStep ==
            AuthSignInStep.confirmSignInWithOtpCode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(phoneNumber: fullPhone),
            ),
          );
        }
      } catch (e) {
        safePrint(e);
      }
    } on AuthException catch (e) {
      safePrint("Auth error: ${e.message}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      safePrint(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
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
              Text("Login", style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: 30),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter phone number",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixText: "+91 ",
                  prefixStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
