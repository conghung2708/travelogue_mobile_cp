import 'package:equatable/equatable.dart';

// Tour booking
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';

// Guide booking
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';

// Workshop booking
import 'package:travelogue_mobile/model/workshop/create_booking_workshop_model.dart';

// Review booking
import 'package:travelogue_mobile/model/booking/review_booking_request.dart';

/// Base
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

/// ====== TOUR ======
class CreateBookingTourEvent extends BookingEvent {
  final CreateBookingTourModel model;
  const CreateBookingTourEvent(this.model);

  @override
  List<Object?> get props => [model];
}

/// ====== PAYMENT LINK (tour/guide/workshop dùng chung) ======
class CreatePaymentLinkEvent extends BookingEvent {
  final String bookingId;
  /// Đánh dấu nếu phát sinh từ flow Guide để phát state riêng (tuỳ UI).
  final bool fromGuide;

  const CreatePaymentLinkEvent(this.bookingId, {this.fromGuide = false});

  @override
  List<Object?> get props => [bookingId, fromGuide];
}

/// ====== GUIDE ======
class CreateTourGuideBookingEvent extends BookingEvent {
  final CreateBookingTourGuideModel model;
  const CreateTourGuideBookingEvent(this.model);

  @override
  List<Object?> get props => [model];
}

/// ====== WORKSHOP ======
class CreateWorkshopBookingEvent extends BookingEvent {
  final CreateBookingWorkshopModel model;
  const CreateWorkshopBookingEvent(this.model);

  @override
  List<Object?> get props => [model];
}

/// ====== LIST / HISTORY ======
class GetAllMyBookingsEvent extends BookingEvent {
  const GetAllMyBookingsEvent();
}

/// ====== CANCEL ======
class CancelBookingEvent extends BookingEvent {
  final String bookingId;
  const CancelBookingEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

/// ====== REVIEW ======
class ReviewBookingEvent extends BookingEvent {
  final ReviewBookingRequest request;
  const ReviewBookingEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class GetMyReviewsEvent extends BookingEvent {
  final int? rating;
  const GetMyReviewsEvent({this.rating});

  @override
  List<Object?> get props => [rating];
}