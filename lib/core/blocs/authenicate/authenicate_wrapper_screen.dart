import 'package:flutter/material.dart';
import 'package:travelogue_mobile/data/data_local/base_local_data.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  Future<bool> _checkLogin() async {
    await BaseLocalData().initialBox();
    return UserLocal().getAccessToken.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final token = UserLocal().getAccessToken;
    print('🔥 ACCESS TOKEN IN WRAPPER: $token');
    return FutureBuilder(
      future: _checkLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        return snapshot.data! ? const MainScreen() : const LoginScreen();
      },
    );
  }
}
