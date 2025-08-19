enum TripStatus {
  draft,
  sketch,
  booked
}       



extension TripStatusExtension on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.draft:
        return 'Bản nháp';
      case TripStatus.sketch:
        return 'Đang lên kế hoạch';
      case TripStatus.booked:
        return 'Đã đặt tour thành công';
    }
  }

  static TripStatus fromIndex(int index) {
    return TripStatus.values[index];
  }
}
