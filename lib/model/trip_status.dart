enum TripStatus {
  noGuide,        // 0
  planning,       // 1
  finalized       // 2 (nếu cần sau này)
}

extension TripStatusExtension on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.noGuide:
        return 'Chưa chọn Hướng Dẫn Viên';
      case TripStatus.planning:
        return 'Đang lên kế hoạch';
      case TripStatus.finalized:
        return 'Đã hoàn tất';
    }
  }
  
  static TripStatus fromIndex(int index) {
    return TripStatus.values[index];
  }
}
