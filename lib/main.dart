import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/data/data_local/base_local_data.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/create_trip_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';
import 'package:travelogue_mobile/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();
      await initializeDateFormatting('vi', null);
      // Keep native splash screen up until app is finished bootstrapping
      // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      widgetsBinding.requestPerformanceMode(DartPerformanceMode.latency);

      // Set size image cache in app
      PaintingBinding.instance.imageCache.maximumSizeBytes =
          1024 * 1024 * 100; // 100 MB

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      );

      await Future.wait([
        Firebase.initializeApp(),
        Hive.initFlutter(),
        BaseLocalData().initialBox(),
      ]);

      // Start app
      runApp(const MyApp());
    },
    (error, stackTrace) async {},
  );
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
    AppBloc().initial();
  }

  @override
  void dispose() {
    super.dispose();
    AppBloc().cleanData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.instance.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
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
            // home: const ExperienceScreen(),
            // home: const FestivalScreen(),
          );
        },
      ),
    );
  }
}
//TRO LY AO, AI
//So thich (yen tinh, co nhieu canh xay, mon an ngon, di bao nhieu ngay)
// ==> nen di dau
//goi y lich trinh (khong can follow)
//Tour guide (phai co chung nhan, biet tieng anh ==> kiem duyet (ben phia tay ninh))
//Quan an , hotel, co so san xuat, dac san (gioi thieu, tiep khach booking) => optional nhung bat buoc.


//Luu su kien ghi bam chi tiet
