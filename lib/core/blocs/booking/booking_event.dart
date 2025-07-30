import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';

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
  const CreatePaymentLinkEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId]; 
}

class CreateBookingAndPaymentEvent extends BookingEvent {
  final CreateBookingTourModel model;

  const CreateBookingAndPaymentEvent(this.model);

  @override
  List<Object?> get props => [model];
}

