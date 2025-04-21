import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';

class GlobalLocal {
  final Box box = Hive.box(StorageKey.boxGlobal);

  // Getter
  bool get checkOpenFirstApp {
    return box.get(
      StorageKey.checkOpenFirstApp,
      defaultValue: false,
    );
  }

  // Setter
  void setCheckOpenApp() {
    box.put(StorageKey.checkOpenFirstApp, true);
  }

  // Clean
  void clear() {
    box.clear();
  }
}
