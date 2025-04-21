import 'package:hive_flutter/hive_flutter.dart';

// Lớp LocalStorageHelper giúp quản lý việc lưu trữ dữ liệu cục bộ sử dụng Hive
class LocalStorageHelper {
  // Constructor riêng tư để áp dụng mô hình Singleton
  LocalStorageHelper._internal();

  // Đối tượng duy nhất của lớp LocalStorageHelper (Singleton pattern)
  static final LocalStorageHelper _shared = LocalStorageHelper._internal();

  // Factory constructor giúp trả về đối tượng đã có sẵn
  factory LocalStorageHelper() {
    return _shared;
  }

  // Biến lưu trữ Box của Hive, nơi lưu trữ dữ liệu dạng key-value
  Box<dynamic>? hiveBox;

  // Phương thức bất đồng bộ để khởi tạo LocalStorageHelper và mở Box với tên 'Travelogue'
  static void initLocalStorageHelper() async {
    // Mở Box 'Travelogue' và gán vào biến hiveBox
    _shared.hiveBox = await Hive.openBox('Travelogue');
  }

  // Phương thức lấy giá trị từ Hive Box dựa trên key
  static dynamic getValue(String key) {
    // Trả về giá trị từ Hive Box tương ứng với key, nếu không có trả về null
    return _shared.hiveBox?.get(key);
  }

  // Phương thức lưu giá trị vào Hive Box với key và giá trị tương ứng
  static void setValue(String key, dynamic val) {
    // Lưu giá trị vào Hive Box với key
    _shared.hiveBox?.put(key, val);
  }
}
