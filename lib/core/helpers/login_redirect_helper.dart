import 'package:flutter/material.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';

class LoginRedirectHelper {
  /// Check login status. If not logged in, navigate to LoginScreen.
  /// Returns `true` if login was successful, otherwise `false`.
  static Future<bool> requireLogin({
    required BuildContext context,
    required int? redirectTabIndex,
  }) async {
    if (UserLocal().isLoggedIn) return true;

    final result = await Navigator.pushNamed(
      context,
      LoginScreen.routeName,
      arguments: {
        'redirectTabIndex': redirectTabIndex,
      },
    );

    return result == true;
  }
}
