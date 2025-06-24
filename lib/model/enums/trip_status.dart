enum TripStatus {
  noGuide,       
  planning,       
  finalized,     
  booked,
  deleted         
}


extension TripStatusExtension on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.noGuide:
        return 'Chưa chọn Hướng Dẫn Viên';
      case TripStatus.planning:
        return 'Đang lên kế hoạch';
      case TripStatus.finalized:
        return 'Đã hoàn tất lịch trình';
      case TripStatus.booked:
        return 'Đã đặt tour thành công';
          case TripStatus.deleted:
        return 'Đã xoá tour thành công';  
    }
  }

  static TripStatus fromIndex(int index) {
    return TripStatus.values[index];
  }
}
