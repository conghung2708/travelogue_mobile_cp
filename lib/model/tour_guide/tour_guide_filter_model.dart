class TourGuideFilterModel {
  final String? userName;
  final DateTime? startDate; // inclusive
  final DateTime? endDate; // inclusive
  final int? minRating; // 1..5
  final int? maxRating; // 1..5
  final int? gender; // tuỳ BE (0/1 hoặc 1/2)
  final double? minPrice;
  final double? maxPrice;

  const TourGuideFilterModel({
    this.userName,
    this.startDate,
    this.endDate,
    this.minRating,
    this.maxRating,
    this.gender,
    this.minPrice,
    this.maxPrice,
  });

  /// Tạo bản sao với các field thay đổi
  TourGuideFilterModel copyWith({
    String? userName,
    DateTime? startDate,
    DateTime? endDate,
    int? minRating,
    int? maxRating,
    int? gender,
    double? minPrice,
    double? maxPrice,
    bool clearUserName = false,
    bool clearDates = false,
    bool clearRating = false,
    bool clearGender = false,
    bool clearPrice = false,
  }) {
    return TourGuideFilterModel(
      userName: clearUserName ? null : (userName ?? this.userName),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      minRating: clearRating ? null : (minRating ?? this.minRating),
      maxRating: clearRating ? null : (maxRating ?? this.maxRating),
      gender: clearGender ? null : (gender ?? this.gender),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  /// Định dạng ngày theo yyyy-MM-dd (hay dùng cho query filter BE)
  String _fmtDate(DateTime d) {
    // chỉ lấy phần ngày, không timezone
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};

    // FullName
    final name = userName?.trim();
    if (name != null && name.isNotEmpty) {
      params['FullName'] = name;
    }

    // Dates: swap nếu ngược, format yyyy-MM-dd
    DateTime? s = startDate;
    DateTime? e = endDate;
    if (s != null && e != null && s.isAfter(e)) {
      final tmp = s;
      s = e;
      e = tmp;
    }
    if (s != null) params['StartDate'] = _fmtDate(s);
    if (e != null) params['EndDate'] = _fmtDate(e);

    // Rating: clamp 1..5, swap nếu min > max
    int? minR = minRating;
    int? maxR = maxRating;
    if (minR != null) minR = minR.clamp(0, 5);
    if (maxR != null) maxR = maxR.clamp(0, 5);
    if (minR != null && maxR != null && minR > maxR) {
      final tmp = minR;
      minR = maxR;
      maxR = tmp;
    }
    if (minR != null) params['MinRating'] = minR;
    if (maxR != null) params['MaxRating'] = maxR;

    // Gender (để nguyên theo BE)
    if (gender != null) params['Gender'] = gender;

    // Price: swap nếu min > max
    double? minP = minPrice;
    double? maxP = maxPrice;
    if (minP != null && maxP != null && minP > maxP) {
      final tmp = minP;
      minP = maxP;
      maxP = tmp;
    }
    if (minP != null) params['MinPrice'] = minP;
    if (maxP != null) params['MaxPrice'] = maxP;

    return params;
  }

  Map<String, dynamic> toJson() => toQueryParams();
}
