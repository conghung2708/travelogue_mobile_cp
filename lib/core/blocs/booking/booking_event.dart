import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingTourEvent extends BookingEvent {
  final CreateBookingTourModel model;
  const CreateBookingTourEvent(this.model);

  @override
  List<Object?> get props => [model];
}

class CreatePaymentLinkEvent extends BookingEvent {
  final String bookingId;
  final bool fromGuide;

  const CreatePaymentLinkEvent(this.bookingId, {this.fromGuide = false});

  @override
  List<Object?> get props => [bookingId, fromGuide];
}

class CreateTourGuideBookingEvent extends BookingEvent {
  final CreateBookingTourGuideModel model;
  const CreateTourGuideBookingEvent(this.model);

  @override
  List<Object?> get props => [model];
}

class GetAllMyBookingsEvent extends BookingEvent {}
