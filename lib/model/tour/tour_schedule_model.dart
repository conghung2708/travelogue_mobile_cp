class TourScheduleModel {
  final String? scheduleId;
  final DateTime? departureDate;
  final int? maxParticipant;
  final int? currentBooked;
  final int? totalDays;
  final double? adultPrice;
  final double? childrenPrice;

  TourScheduleModel({
    this.scheduleId,
    this.departureDate,
    this.maxParticipant,
    this.currentBooked,
    this.totalDays,
    this.adultPrice,
    this.childrenPrice,
  });

  factory TourScheduleModel.fromJson(Map<String, dynamic> json) {
    return TourScheduleModel(
      scheduleId: json['scheduleId'] as String?,
      departureDate: json['departureDate'] != null
          ? DateTime.tryParse(json['departureDate'] as String)
          : null,
      maxParticipant: json['maxParticipant'] is int
          ? json['maxParticipant'] as int
          : int.tryParse(json['maxParticipant']?.toString() ?? ''),
      currentBooked: json['currentBooked'] is int
          ? json['currentBooked'] as int
          : int.tryParse(json['currentBooked']?.toString() ?? ''),
      totalDays: json['totalDays'] is int
          ? json['totalDays'] as int
          : int.tryParse(json['totalDays']?.toString() ?? ''),
      adultPrice: (json['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (json['childrenPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
        'departureDate': departureDate?.toIso8601String(),
        'maxParticipant': maxParticipant,
        'currentBooked': currentBooked,
        'totalDays': totalDays,
        'adultPrice': adultPrice,
        'childrenPrice': childrenPrice,
      };
}
