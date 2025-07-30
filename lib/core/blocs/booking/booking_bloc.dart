import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_event.dart';
import 'package:travelogue_mobile/core/blocs/booking/booking_state.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<CreateBookingTourEvent>(_onCreateBooking);
    on<CreatePaymentLinkEvent>(_onCreatePaymentLink);
    on<CreateBookingAndPaymentEvent>(_onCreateBookingAndPayment);

  }

  /// Xử lý tạo booking tour
  Future<void> _onCreateBooking(
    CreateBookingTourEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    try {
      print('[📢 Bloc] Booking started...');
      final BookingModel? booking = await bookingRepository.createBooking(event.model);

      if (booking != null) {
        print('[✅ Bloc] Booking success: ${booking.id}');
        emit(BookingSuccess(booking));
      } else {
        print('[❌ Bloc] Booking failed: null returned');
        emit(const BookingFailure('Đặt tour thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      print('[‼️ Bloc] Exception: $e');
      emit(BookingFailure(e.toString()));
    }
  }


  Future<void> _onCreatePaymentLink(
    CreatePaymentLinkEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading()); 

    try {
      print('[📢 Bloc] Creating payment link for bookingId: ${event.bookingId}');
      final String? paymentUrl = await bookingRepository.createPaymentLink(event.bookingId);

      if (paymentUrl != null) {
        print('[✅ Bloc] Payment link success: $paymentUrl');
        emit(PaymentLinkSuccess(paymentUrl));
      } else {
        print('[❌ Bloc] Payment link failed');
        emit(const BookingFailure('Tạo liên kết thanh toán thất bại.'));
      }
    } catch (e) {
      print('[‼️ Bloc] Exception while creating payment link: $e');
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onCreateBookingAndPayment(
  CreateBookingAndPaymentEvent event,
  Emitter<BookingState> emit,
) async {
  emit(BookingLoading());

  try {
    print('[📢] Bắt đầu tạo booking...');
    final booking = await bookingRepository.createBooking(event.model);

    if (booking == null) {
      emit(const BookingFailure('Tạo booking thất bại.'));
      return;
    }

    print('[✅] Booking thành công. ID = ${booking.id}');
    print('[📢] Tiếp tục tạo liên kết thanh toán...');

    final paymentUrl = await bookingRepository.createPaymentLink(booking.id);

    if (paymentUrl == null) {
      emit(const BookingFailure('Tạo liên kết thanh toán thất bại.'));
      return;
    }

    print('[✅] Payment link thành công: $paymentUrl');
    emit(BookingWithPaymentSuccess(booking, paymentUrl));
  } catch (e) {
    print('[‼️] Lỗi khi tạo booking và thanh toán: $e');
    emit(BookingFailure(e.toString()));
  }
}

}
