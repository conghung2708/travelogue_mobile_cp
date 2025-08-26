class BookingParticipantModel {
  final String? id;
  final String? bookingId;
  final int type;
  final int quantity;
  final double pricePerParticipant;
  final String fullName;
  final int gender;
  final String? genderText;
  final DateTime dateOfBirth;

  const BookingParticipantModel({
    this.id,
    this.bookingId,
    required this.type,
    this.quantity = 0,
    this.pricePerParticipant = 0.0,
    required this.fullName,
    required this.gender,
    this.genderText,
    required this.dateOfBirth,
  });

 
  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  static double _toDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    final s = v.toString();
    final cleaned = s.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? fallback;
  }

  static DateTime _parseDateRequired(dynamic v, {DateTime? fallback}) {
    if (v == null) return fallback ?? DateTime(1900, 1, 1);
    final parsed = DateTime.tryParse(v.toString());
    return parsed ?? (fallback ?? DateTime(1900, 1, 1));
  }

  factory BookingParticipantModel.fromJson(Map<String, dynamic> json) {
    return BookingParticipantModel(
      id: json['id']?.toString(),
      bookingId: json['bookingId']?.toString(),
      type: _toInt(json['type']),
      quantity: _toInt(json['quantity']),
      pricePerParticipant: _toDouble(json['pricePerParticipant']),
      fullName: json['fullName']?.toString() ?? '',
      gender: _toInt(json['gender']),
      genderText: json['genderText']?.toString(),
      dateOfBirth: _parseDateRequired(json['dateOfBirth']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'type': type,
      'quantity': quantity,
      'pricePerParticipant': pricePerParticipant,
      'fullName': fullName,
      'gender': gender,
      'genderText': genderText,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }
}
