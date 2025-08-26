class TourGuideFilterModel {
  final String? userName;
  final DateTime? startDate; 
  final DateTime? endDate; 
  final int? minRating; 
  final int? maxRating; 
  final int? gender; 
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

  
  String _fmtDate(DateTime d) {
    
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};


    final name = userName?.trim();
    if (name != null && name.isNotEmpty) {
      params['FullName'] = name;
    }


    DateTime? s = startDate;
    DateTime? e = endDate;
    if (s != null && e != null && s.isAfter(e)) {
      final tmp = s;
      s = e;
      e = tmp;
    }
    if (s != null) params['StartDate'] = _fmtDate(s);
    if (e != null) params['EndDate'] = _fmtDate(e);


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

    if (gender != null) params['Gender'] = gender;

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
