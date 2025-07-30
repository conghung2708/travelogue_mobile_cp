class TourGuideFilterModel {
  final String? userName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minRating;
  final int? maxRating;
  final int? gender;
  final double? minPrice;
  final double? maxPrice;

  TourGuideFilterModel({
    this.userName,
    this.startDate,
    this.endDate,
    this.minRating,
    this.maxRating,
    this.gender,
    this.minPrice,
    this.maxPrice,
  });
Map<String, dynamic> toQueryParams() {
  final Map<String, dynamic> params = {};

  if (userName != null && userName!.trim().isNotEmpty) {
    params['FullName'] = userName!.trim();
  }

  if (startDate != null) {
    params['StartDate'] = startDate!.toIso8601String();
  }
  if (endDate != null) {
    params['EndDate'] = endDate!.toIso8601String();
  }
  if (minRating != null) params['MinRating'] = minRating;
  if (maxRating != null) params['MaxRating'] = maxRating;
  if (gender != null) params['Gender'] = gender;
  if (minPrice != null) params['MinPrice'] = minPrice;
  if (maxPrice != null) params['MaxPrice'] = maxPrice;

  return params;
}



  Map<String, dynamic> toJson() => toQueryParams();
}
