import 'package:travelogue_mobile/model/tour/tour_model.dart';

/// BookingModel: immutable, friendly for UI & BE interop
class BookingModel {
  final String id;
  final String userId;
  final String? tourId;
  final String? tourScheduleId;
  final String? tourGuideId;
  final String? tripPlanId;
  final String? workshopId;
  final String? workshopScheduleId;
  final String? paymentLinkId;

  /// BE có thể trả "1"/"2"/"3" hoặc text. Ta giữ dạng String để không lệch schema.
  final String status;
  final String? statusText;

  final String bookingType;
  final String? bookingTypeText;

  final DateTime bookingDate;
  final DateTime? cancelledAt;

  final String? promotionId;

  /// Giá có thể là số hoặc string -> đã chuẩn hoá qua _toDouble
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  /// field phụ trợ client
  final TourModel? tour;

  const BookingModel({
    required this.id,
    required this.userId,
    this.tourId,
    this.tourScheduleId,
    this.tourGuideId,
    this.tripPlanId,
    this.workshopId,
    this.workshopScheduleId,
    this.paymentLinkId,
    required this.status,
    this.statusText,
    required this.bookingType,
    this.bookingTypeText,
    required this.bookingDate,
    this.cancelledAt,
    this.promotionId,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    this.tour,
  });

  // ---------- JSON helpers ----------
  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    // "1,250,000" | "1.250.000" | "1250000" | "1250000.5"
    final digits = v.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(digits) ?? 0.0;
  }

  static DateTime? _parseDateNullable(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  static DateTime _parseDateRequired(dynamic v, {String fieldName = 'date'}) {
    if (v == null) {
      throw FormatException('$fieldName is missing');
    }
    final s = v.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      throw FormatException('$fieldName is invalid: $s');
    }
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      tourId: json['tourId']?.toString(),
      tourScheduleId: json['tourScheduleId']?.toString(),
      tourGuideId: json['tourGuideId']?.toString(),
      tripPlanId: json['tripPlanId']?.toString(),
      workshopId: json['workshopId']?.toString(),
      workshopScheduleId: json['workshopScheduleId']?.toString(),
      paymentLinkId: json['paymentLinkId']?.toString(),

      status: json['status']?.toString() ?? 'UNKNOWN',
      statusText: json['statusText']?.toString(),

      bookingType: json['bookingType']?.toString() ?? 'UNKNOWN',
      bookingTypeText: json['bookingTypeText']?.toString(),

      bookingDate: _parseDateRequired(json['bookingDate'], fieldName: 'bookingDate'),
      cancelledAt: _parseDateNullable(json['cancelledAt']),

      promotionId: json['promotionId']?.toString(),

      originalPrice: _toDouble(json['originalPrice']),
      discountAmount: _toDouble(json['discountAmount']),
      finalPrice: _toDouble(json['finalPrice']),

      tour: null, // client-only
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tourId': tourId,
      'tourScheduleId': tourScheduleId,
      'tourGuideId': tourGuideId,
      'tripPlanId': tripPlanId,
      'workshopId': workshopId,
      'workshopScheduleId': workshopScheduleId,
      'paymentLinkId': paymentLinkId,
      'status': status,
      'statusText': statusText,
      'bookingType': bookingType,
      'bookingTypeText': bookingTypeText,
      'bookingDate': bookingDate.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'promotionId': promotionId,
      'originalPrice': originalPrice,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
      // 'tour' không gửi lên BE
    };
  }

  // ---------- copyWith ----------
  BookingModel copyWith({
    String? id,
    String? userId,
    String? tourId,
    String? tourScheduleId,
    String? tourGuideId,
    String? tripPlanId,
    String? workshopId,
    String? workshopScheduleId,
    String? paymentLinkId,
    String? status,
    String? statusText,
    String? bookingType,
    String? bookingTypeText,
    DateTime? bookingDate,
    DateTime? cancelledAt,
    String? promotionId,
    double? originalPrice,
    double? discountAmount,
    double? finalPrice,
    TourModel? tour,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tourId: tourId ?? this.tourId,
      tourScheduleId: tourScheduleId ?? this.tourScheduleId,
      tourGuideId: tourGuideId ?? this.tourGuideId,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      workshopId: workshopId ?? this.workshopId,
      workshopScheduleId: workshopScheduleId ?? this.workshopScheduleId,
      paymentLinkId: paymentLinkId ?? this.paymentLinkId,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      bookingType: bookingType ?? this.bookingType,
      bookingTypeText: bookingTypeText ?? this.bookingTypeText,
      bookingDate: bookingDate ?? this.bookingDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      promotionId: promotionId ?? this.promotionId,
      originalPrice: originalPrice ?? this.originalPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      tour: tour ?? this.tour,
    );
  }

  // ---------- Convenience for UI ----------
  /// Map về code số cho dễ lọc/tab: 0: hết hạn, 1: paid, 2: completed, 3: canceled
  int get statusCode {
    final s = status.trim().toLowerCase();
    final t = (statusText ?? '').trim().toLowerCase();

    // Ưu tiên numeric nếu có
    final n = int.tryParse(s);
    if (n != null) {
      // Một số BE dùng 2 + "bị hủy" -> coi như 3
      if (n == 2 && t == 'bị hủy') return 3;
      return n;
    }

    // Map text fallback
    if (s == 'pending') return 0;
    if (s == 'confirmed') return 1;
    if (s == 'completed') return 2;
    if (s == 'bị hủy' || t == 'bị hủy' || s == 'canceled' || t == 'canceled') return 3;

    // Dựa theo statusText nếu status mơ hồ
    if (t == 'pending') return 0;
    if (t == 'confirmed') return 1;
    if (t == 'completed') return 2;
    if (t == 'bị hủy' || t == 'canceled') return 3;

    return 0; // default -> hết hạn/unknown
  }

  /// Text hiển thị VN cho UI
  String get statusTextUi {
    switch (statusCode) {
      case 0:
        return 'Hết hạn thanh toán';
      case 1:
        return 'Đã thanh toán';
      case 2:
        return 'Đã hoàn tất';
      case 3:
        return 'Đã hủy';
      default:
        return statusText ?? 'Không rõ';
    }
  }

  bool get isPaid => statusCode == 1;
  bool get isCompleted => statusCode == 2;
  bool get isCanceled => statusCode == 3;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BookingModel(id=$id, status=$status/$statusText, bookingType=$bookingType, finalPrice=$finalPrice)';
}
