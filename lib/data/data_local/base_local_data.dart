import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';

class BaseLocalData {
  Future<void> initialBox() async {
    await Hive.initFlutter(); 
    await openBoxApp();
  }
  Future<void> openBoxApp() async {
    await Future.wait([
      Hive.openBox(StorageKey.boxGlobal),
      Hive.openBox(StorageKey.boxUser),
      Hive.openBox(StorageKey.boxHotel),
      Hive.openBox(StorageKey.boxRestaurant),
      Hive.openBox(StorageKey.boxHome),
      Hive.openBox(StorageKey.boxExperience),
      Hive.openBox(StorageKey.boxTour),
      Hive.openBox(StorageKey.tourGuides),
    ]);
  }

  static Future<String> get localStoreDir async =>
      '${(await getApplicationSupportDirectory()).path}/hive';
}
