import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  static Future<String> getIdToken() async {
    try {
      final session =
          await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

      final tokens = session.userPoolTokensResult.value;

      return tokens.idToken.raw;
    } catch (e) {
      safePrint("Token fetch error: $e");
      throw Exception("Unable to fetch token");
    }
  }
}
