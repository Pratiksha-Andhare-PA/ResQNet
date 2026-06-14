import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:resq_net/screens/confirmation_screen.dart';
import 'package:resq_net/screens/splash_screen.dart';
import 'config/theme.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const ResQNetApp());
}

class ResQNetApp extends StatefulWidget {
  const ResQNetApp({super.key});

  @override
  State<ResQNetApp> createState() => _ResQNetAppState();
}

class _ResQNetAppState extends State<ResQNetApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final authPlugin = AmplifyAuthCognito();

      await Amplify.addPlugin(authPlugin);

      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      safePrint("🔥 Amplify error: $e");

      setState(() {
        _amplifyConfigured = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_amplifyConfigured) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: "ResQNet",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,

          routes: {
            "/confirmation": (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;

              return ConfirmationScreen(hospital: args["hospital"]);
            },
          },

          home: const SplashScreen(),
        );
      },
    );
  }
}
