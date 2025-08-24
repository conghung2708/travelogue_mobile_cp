import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/data/data_local/base_local_data.dart';
import 'package:travelogue_mobile/routes.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await runZonedGuarded(() async {
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();

    print("🔄 App init start...");

    await initializeDateFormatting('vi', null);
    print("✅ Date formatting ok");

    widgetsBinding.requestPerformanceMode(DartPerformanceMode.latency);

    PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 100;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    // Load .env
    try {
      await dotenv.load(fileName: ".env");
      print("✅ .env loaded");
    } catch (e) {
      print("❌ .env load error: $e");
    }

    // Init Firebase
    try {
      await Firebase.initializeApp();
      print("✅ Firebase init ok");
    } catch (e) {
      print("❌ Firebase init error: $e");
    }

    // Init Hive
    try {
      await Hive.initFlutter();
      print("✅ Hive init ok");
    } catch (e) {
      print("❌ Hive init error: $e");
    }

    // Init Local Data
    try {
      await BaseLocalData().initialBox();
      print("✅ BaseLocalData init ok");
    } catch (e) {
      print("❌ BaseLocalData init error: $e");
    }

    print("🚀 RunApp starting...");
    runApp(const MyApp());
  }, (error, stackTrace) async {
    print("❌ Uncaught error: $error");
  });
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}

Future<void> checkLocationServices() async {
  bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationEnabled) {
    await Geolocator.openLocationSettings();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AppBloc.instance.initial();
  }

  @override
  void dispose() {
    AppBloc.instance.cleanData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.instance.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return ShowCaseWidget(
            builder: (context) => MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Travelogue',
              theme: ThemeData(
                fontFamily: 'Roboto',
                primaryColor: ColorPalette.primaryColor,
                scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: ColorPalette.primaryColor,
                ),
                useMaterial3: true,
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'Roboto',
                    ),
              ),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('vi', 'VN'),
                Locale('en', 'US'),
              ],
              locale: const Locale('vi', 'VN'),
              routes: routes,
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
