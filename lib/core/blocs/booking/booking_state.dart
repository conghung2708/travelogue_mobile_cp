import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final BookingModel booking;
  const BookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingGuideSuccess extends BookingState {
  final BookingModel booking;
  const BookingGuideSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingFailure extends BookingState {
  final String error;
  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PaymentLinkSuccess extends BookingState {
  final String paymentUrl;
  const PaymentLinkSuccess(this.paymentUrl);

  @override
  List<Object?> get props => [paymentUrl];
}

class PaymentLinkGuideSuccess extends BookingState {
  final String paymentUrl;
  const PaymentLinkGuideSuccess(this.paymentUrl);

  @override
  List<Object?> get props => [paymentUrl];
}

class BookingListLoading extends BookingState {}

class BookingListSuccess extends BookingState {
  final List<BookingModel> bookings;
  const BookingListSuccess(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

