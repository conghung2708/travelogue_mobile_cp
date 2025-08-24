import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';

import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/workshop/create_booking_workshop_model.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<CreateBookingTourEvent>(_onCreateBookingTour);
    on<CreateTourGuideBookingEvent>(_onCreateTourGuideBooking);
    on<CreateWorkshopBookingEvent>(_onCreateWorkshopBooking);
    on<CreatePaymentLinkEvent>(_onCreatePaymentLink);
    on<GetAllMyBookingsEvent>(_onGetAllMyBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<ReviewBookingEvent>(_onReviewBooking);
        on<GetMyReviewsEvent>(_onGetMyReviews); 
  }

  /* ========================= TOUR ========================= */

  Future<void> _onCreateBookingTour(
    CreateBookingTourEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final BookingModel? booking =
          await bookingRepository.createBooking(event.model);
      if (booking != null) {
        emit(BookingSuccess(booking));
      } else {
        emit(const BookingFailure('Đặt tour thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /* ========================= GUIDE ========================= */

  Future<void> _onCreateTourGuideBooking(
    CreateTourGuideBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final BookingModel? booking =
          await bookingRepository.createGuideBooking(event.model);
      if (booking != null) {
        emit(BookingGuideSuccess(booking));
      } else {
        emit(const BookingFailure(
            'Đặt hướng dẫn viên thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /* ========================= WORKSHOP ========================= */

  Future<void> _onCreateWorkshopBooking(
    CreateWorkshopBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      // Model-based API
      final BookingModel? booking =
          await bookingRepository.createWorkshopBooking(
        event.model as CreateBookingWorkshopModel,
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

  /* ========================= PAYMENT LINK (dùng chung) ========================= */

  Future<void> _onCreatePaymentLink(
    CreatePaymentLinkEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final String? paymentUrl =
          await bookingRepository.createPaymentLink(event.bookingId);

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

  /* ========================= LIST / HISTORY ========================= */

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

  /* ========================= CANCEL ========================= */

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final fresh = await bookingRepository.getBookingById(event.bookingId);
      if (fresh == null) {
        emit(const BookingFailure('Không lấy được thông tin đơn hàng.'));
        return;
      }

      final result = await bookingRepository.cancelBooking(event.bookingId);
      if (result.ok) {
        emit(CancelBookingSuccess(event.bookingId));
      } else {
        emit(BookingFailure(
            result.message ?? 'Hủy booking thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /* ========================= REVIEW ========================= */

  Future<void> _onReviewBooking(
    ReviewBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const ReviewBookingSubmitting());
    try {
      final r = event.request.rating;
      if (r < 1 || r > 5) {
        emit(const BookingFailure('Điểm đánh giá phải từ 1–5.'));
        return;
      }
      if (event.request.comment.trim().isEmpty) {
        emit(const BookingFailure('Vui lòng nhập nhận xét.'));
        return;
      }

      final result = await bookingRepository.reviewBooking(event.request);
      if (result.ok) {
        emit(ReviewBookingSuccess(message: result.message));
      } else {
        emit(BookingFailure(result.message ?? 'Gửi đánh giá thất bại.'));
      }
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
   Future<void> _onGetMyReviews(
    GetMyReviewsEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final ids =
          await bookingRepository.getMyReviewedBookingIds(rating: event.rating);
      emit(MyReviewsLoaded(ids));
    } catch (e) {

    }
  }
}
