import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

/// BookingModel: immutable, friendly for UI & BE interop
class BookingModel {
  final String id;
  final String userId;
  final String? userName;

  final String? tourId;
  final String? tourName;
  final String? tourScheduleId;
  final DateTime? departureDate;

  final String? tourGuideId;
  final String? tourGuideName;

  final String? tripPlanId;
  final String? tripPlanName;

  final String? workshopId;
  final String? workshopName;
  final String? workshopScheduleId;

  final String? paymentLinkId;

  /// BE có thể trả số hoặc text, giữ String để không lệch schema
  final String status;
  final String? statusText;

  final String bookingType;
  final String? bookingTypeText;

  final DateTime bookingDate;
  final DateTime? cancelledAt;

  final DateTime? startDate;
  final DateTime? endDate;

  final String? promotionId;

  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  // contact info
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final String? contactAddress;

  final List<BookingParticipantModel> participants;

  /// client-only
  final TourModel? tour;

  const BookingModel({
    required this.id,
    required this.userId,
    this.userName,
    this.tourId,
    this.tourName,
    this.tourScheduleId,
    this.departureDate,
    this.tourGuideId,
    this.tourGuideName,
    this.tripPlanId,
    this.tripPlanName,
    this.workshopId,
    this.workshopName,
    this.workshopScheduleId,
    this.paymentLinkId,
    required this.status,
    this.statusText,
    required this.bookingType,
    this.bookingTypeText,
    required this.bookingDate,
    this.cancelledAt,
    this.startDate,
    this.endDate,
    this.promotionId,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.contactAddress,
    this.participants = const [],
    this.tour,
  });

  // ---------- JSON helpers ----------
  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
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
      userName: json['userName']?.toString(),
      tourId: json['tourId']?.toString(),
      tourName: json['tourName']?.toString(),
      tourScheduleId: json['tourScheduleId']?.toString(),
      departureDate: json['departureDate'] != null ? DateTime.tryParse(json['departureDate'].toString()) : null,
      tourGuideId: json['tourGuideId']?.toString(),
      tourGuideName: json['tourGuideName']?.toString(),
      tripPlanId: json['tripPlanId']?.toString(),
      tripPlanName: json['tripPlanName']?.toString(),
      workshopId: json['workshopId']?.toString(),
      workshopName: json['workshopName']?.toString(),
      workshopScheduleId: json['workshopScheduleId']?.toString(),
      paymentLinkId: json['paymentLinkId']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusText: json['statusText']?.toString(),
      bookingType: json['bookingType']?.toString() ?? 'UNKNOWN',
      bookingTypeText: json['bookingTypeText']?.toString(),
      bookingDate: _parseDateRequired(json['bookingDate'], fieldName: 'bookingDate'),
      cancelledAt: _parseDateNullable(json['cancelledAt']),
      startDate: _parseDateNullable(json['startDate']),
      endDate: _parseDateNullable(json['endDate']),
      promotionId: json['promotionId']?.toString(),
      originalPrice: _toDouble(json['originalPrice']),
      discountAmount: _toDouble(json['discountAmount']),
      finalPrice: _toDouble(json['finalPrice']),
      contactName: json['contactName']?.toString(),
      contactEmail: json['contactEmail']?.toString(),
      contactPhone: json['contactPhone']?.toString(),
      contactAddress: json['contactAddress']?.toString(),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => BookingParticipantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tour: null, // client-only
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'tourId': tourId,
      'tourName': tourName,
      'tourScheduleId': tourScheduleId,
      'departureDate': departureDate?.toIso8601String(),
      'tourGuideId': tourGuideId,
      'tourGuideName': tourGuideName,
      'tripPlanId': tripPlanId,
      'tripPlanName': tripPlanName,
      'workshopId': workshopId,
      'workshopName': workshopName,
      'workshopScheduleId': workshopScheduleId,
      'paymentLinkId': paymentLinkId,
      'status': status,
      'statusText': statusText,
      'bookingType': bookingType,
      'bookingTypeText': bookingTypeText,
      'bookingDate': bookingDate.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'promotionId': promotionId,
      'originalPrice': originalPrice,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'contactAddress': contactAddress,
      'participants': participants.map((e) => e.toJson()).toList(),
      // 'tour' không gửi lên BE
    };
  }

  // ---------- copyWith ----------
  BookingModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? tourId,
    String? tourName,
    String? tourScheduleId,
    DateTime? departureDate,
    String? tourGuideId,
    String? tourGuideName,
    String? tripPlanId,
    String? tripPlanName,
    String? workshopId,
    String? workshopName,
    String? workshopScheduleId,
    String? paymentLinkId,
    String? status,
    String? statusText,
    String? bookingType,
    String? bookingTypeText,
    DateTime? bookingDate,
    DateTime? cancelledAt,
    DateTime? startDate,
    DateTime? endDate,
    String? promotionId,
    double? originalPrice,
    double? discountAmount,
    double? finalPrice,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    String? contactAddress,
    List<BookingParticipantModel>? participants,
    TourModel? tour,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      tourId: tourId ?? this.tourId,
      tourName: tourName ?? this.tourName,
      tourScheduleId: tourScheduleId ?? this.tourScheduleId,
      departureDate: departureDate ?? this.departureDate,
      tourGuideId: tourGuideId ?? this.tourGuideId,
      tourGuideName: tourGuideName ?? this.tourGuideName,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      tripPlanName: tripPlanName ?? this.tripPlanName,
      workshopId: workshopId ?? this.workshopId,
      workshopName: workshopName ?? this.workshopName,
      workshopScheduleId: workshopScheduleId ?? this.workshopScheduleId,
      paymentLinkId: paymentLinkId ?? this.paymentLinkId,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      bookingType: bookingType ?? this.bookingType,
      bookingTypeText: bookingTypeText ?? this.bookingTypeText,
      bookingDate: bookingDate ?? this.bookingDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      promotionId: promotionId ?? this.promotionId,
      originalPrice: originalPrice ?? this.originalPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      contactAddress: contactAddress ?? this.contactAddress,
      participants: participants ?? this.participants,
      tour: tour ?? this.tour,
    );
  }

  // ---------- Convenience for UI ----------
  static const int kPending = 0;
  static const int kConfirmed = 1;
  static const int kCancelledUnpaid = 2;
  static const int kCancelledPaid = 3;
  static const int kCancelledByProvider = 4;
  static const int kCompleted = 5;
  static const int kExpired = 6;

  /// Ép về mã trạng thái gốc của BE (0..6).
  int get rawStatus {
    // 1) ưu tiên numeric từ `status`
    final n = int.tryParse(status.trim());
    if (n != null) return n;

    // 2) fallback theo text (vi + en)
    final s = status.trim().toLowerCase();
    final t = (statusText ?? '').trim().toLowerCase();
    bool has(String needle) => s.contains(needle) || t.contains(needle);

    if (has('pending')) return kPending;
    if (has('confirmed') || has('đã thanh toán') || has('paid')) return kConfirmed;
    if (has('bị hủy chưa') || has('bị huỷ chưa') || has('cancelledunpaid')) return kCancelledUnpaid;
    if (has('bị hủy đã')   || has('bị huỷ đã')   || has('cancelledpaid'))   return kCancelledPaid;
    if (has('bị hủy bởi')  || has('bị huỷ bởi')  || has('cancelledbyprovider')) return kCancelledByProvider;
    if (has('completed') || has('đã hoàn thành') || has('đã hoàn tất')) return kCompleted;
    if (has('expired') || has('hết hạn')) return kExpired;

    // Trường hợp BE chỉ trả "bị huỷ" chung:
    if (has('bị hủy') || has('bị huỷ') || has('canceled') || has('cancelled')) {
      return kCancelledUnpaid;
    }
    return kPending;
  }

  // Nhóm tiện ích
  bool get isPending => rawStatus == kPending;
  bool get isConfirmed => rawStatus == kConfirmed;
  bool get isCancelledUnpaid => rawStatus == kCancelledUnpaid;
  bool get isCancelledPaid => rawStatus == kCancelledPaid;
  bool get isCancelledByProvider => rawStatus == kCancelledByProvider;
  bool get isCompleted => rawStatus == kCompleted;
  bool get isExpired => rawStatus == kExpired;
  bool get isCancelledAny => isCancelledUnpaid || isCancelledPaid || isCancelledByProvider;

  /// Dùng cho lọc theo 4 tab trong UI:
  /// 0 = Hết hạn (gộp Pending + Expired)
  /// 1 = Đã thanh toán (Confirmed)
  /// 2 = Đã hoàn thành (Completed)
  /// 3 = Đã huỷ (2/3/4)
  int get tabCode {
    if (isConfirmed) return 1;
    if (isCompleted) return 2;
    if (isCancelledAny) return 3;
    return 0; // pending/expired
  }

  /// Text hiển thị chi tiết
  String get statusTextUi {
    switch (rawStatus) {
      case kPending:
        return 'Hết hạn thanh toán';
      case kConfirmed:
        return 'Đã thanh toán';
      case kCancelledUnpaid:
        return 'Bị huỷ chưa thanh toán';
      case kCancelledPaid:
        return 'Bị huỷ đã thanh toán';
      case kCancelledByProvider:
        return 'Bị huỷ bởi nhà cung cấp';
      case kCompleted:
        return 'Đã hoàn thành';
      case kExpired:
        return 'Hết hạn';
      default:
        return statusText ?? 'Không rõ';
    }
  }

  // alias cũ
  int get statusCode => tabCode; // 0..3
  bool get isPaid => isConfirmed;
  bool get isCanceled => isCancelledAny;
}
