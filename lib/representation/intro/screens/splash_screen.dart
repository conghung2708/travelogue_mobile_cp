import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travelogue_mobile/data/data_local/global_local.dart';

import 'package:travelogue_mobile/representation/intro/screens/intro_screen.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   redirectIntroScreen();
  // }

  // void redirectIntroScreen() async {
  //   final ignoreIntroScreen = LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
  //   await Future.delayed(const Duration(milliseconds: 2000));
  //   if(ignoreIntroScreen != null && ignoreIntroScreen) {
  //     Navigator.of(context).pushNamed(MainScreen.routeName);
  //   } else {
  //     LocalStorageHelper.setValue('ignoreIntroScreen', true);
  //     Navigator.of(context).pushNamed(IntroScreen.routeName);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/animations/animation_123.json',
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.4,
          fit: BoxFit.contain,
        ),
      ),
      splashIconSize: MediaQuery.of(context).size.width * 0.6,
      nextScreen: GlobalLocal().checkOpenFirstApp
          ? const MainScreen()
          : const IntroScreen(),
    );
  }
}
