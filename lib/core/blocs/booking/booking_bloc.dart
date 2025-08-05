import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<CreateBookingTourEvent>(_onCreateBooking);
    on<CreateTourGuideBookingEvent>(_onCreateTourGuideBooking);
    on<CreateWorkshopBookingEvent>(_onCreateWorkshopBooking);
    on<CreatePaymentLinkEvent>(_onCreatePaymentLink);
    on<GetAllMyBookingsEvent>(_onGetAllMyBookings);

  }

  Future<void> _onCreateBooking(
    CreateBookingTourEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    try {
      final BookingModel? booking = await bookingRepository.createBooking(event.model);
      if (booking != null) {
        emit(BookingSuccess(booking));
      } else {
        emit(const BookingFailure('Đặt tour thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onCreateTourGuideBooking(
    CreateTourGuideBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    try {
      final BookingModel? booking = await bookingRepository.createGuideBooking(event.model);
      if (booking != null) {
        emit(BookingGuideSuccess(booking));
      } else {
        emit(const BookingFailure('Đặt hướng dẫn viên thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onCreatePaymentLink(
    CreatePaymentLinkEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    try {
      final String? paymentUrl = await bookingRepository.createPaymentLink(event.bookingId);

      if (paymentUrl != null) {
        if (event.fromGuide) {
          emit(PaymentLinkGuideSuccess(paymentUrl));
        } else {
          emit(PaymentLinkSuccess(paymentUrl));
        }
      } else {
        emit(const BookingFailure('Tạo liên kết thanh toán thất bại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onGetAllMyBookings(
  GetAllMyBookingsEvent event,
  Emitter<BookingState> emit,
) async {
  emit(BookingListLoading());

  try {
    final bookings = await bookingRepository.getAllMyBookings();
    emit(BookingListSuccess(bookings));
  } catch (e) {
    emit(BookingFailure(e.toString()));
  }
}
  Future<void> _onCreateWorkshopBooking(
    CreateWorkshopBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    try {
      final booking = await bookingRepository.createWorkshopBooking(
        workshopId: event.workshopId,
        workshopScheduleId: event.workshopScheduleId,
        promotionCode: event.promotionCode,
        adultCount: event.adultCount,
        childrenCount: event.childrenCount,
      );

      if (booking != null) {
        emit(WorkshopBookingSuccess(booking));
      } else {
        emit(const BookingFailure('Đặt workshop thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}

