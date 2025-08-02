import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';
class BookingRepository {
  Future<BookingModel?> createBooking(CreateBookingTourModel model) async {
    print('[📤 CREATE BOOKING] Sending model: ${model.toJson()}');

    final response = await BaseRepository().postRoute(
      gateway: Endpoints.createBookingTour,
      data: model.toJson(),
    );

    print('[📥 CREATE BOOKING] Status: ${response.statusCode}');
    print('[📥 CREATE BOOKING] Data: ${response.data}');

    if (response.statusCode == StatusCode.ok &&
        response.data != null &&
        response.data['data'] != null) {
      try {
        final dynamic rawData = response.data['data'];
        if (rawData is Map<String, dynamic>) {
          final booking = BookingModel.fromJson(rawData);
          print('[✅ PARSE SUCCESS - OBJECT] Booking ID: ${booking.id}');
          return booking;
        }
        if (rawData is List && rawData.isNotEmpty) {
          final booking = BookingModel.fromJson(rawData[0]);
          print('[✅ PARSE SUCCESS - LIST] Booking ID: ${booking.id}');
          return booking;
        }

        print('[⚠️ Booking Error] Unexpected data format: $rawData');
        return null;
      } catch (e) {
        print('[❌ PARSE ERROR] $e');
        return null;
      }
    } else {
      print('[⚠️ Booking Error] API response invalid');
      return null;
    }
  }
Future<String?> createPaymentLink(String bookingId) async {
  final endpoint = '${Endpoints.createPaymentLink}?bookingId=$bookingId';
  print('[📤 CREATE PAYMENT LINK] URL: $endpoint');

  final response = await BaseRepository().postRoute(
    gateway: endpoint,
    data: {},
  );

  print('[📥 PAYMENT LINK] Status: ${response.statusCode}');
  print('[📥 PAYMENT LINK] Data: ${response.data}');

  if (response.statusCode == StatusCode.ok && response.data != null) {
    try {
      final data = response.data['data'];
      final url = data['checkoutUrl']; 
      print('[✅ PAYMENT CHECKOUT URL CREATED] $url');
      return url;
    } catch (e) {
      print('[❌ PARSE PAYMENT LINK ERROR] $e');
      return null;
    }
  } else {
    print('[❌ PAYMENT LINK FAILED]');
    return null;
  }
}

Future<BookingModel?> createGuideBooking(CreateBookingTourGuideModel model) async {
  print('[📤 CREATE GUIDE BOOKING] Sending model: ${model.toJson()}');

  final response = await BaseRepository().postRoute(
    gateway: Endpoints.createBookingTourGuide, 
    data: model.toJson(),
  );

  print('[📥 GUIDE BOOKING] Status: ${response.statusCode}');
  print('[📥 GUIDE BOOKING] Data: ${response.data}');

  if (response.statusCode == StatusCode.ok &&
      response.data != null &&
      response.data['data'] != null) {
    try {
      final dynamic rawData = response.data['data'];
      if (rawData is Map<String, dynamic>) {
        final booking = BookingModel.fromJson(rawData);
        print('[✅ PARSE SUCCESS - OBJECT] Booking ID: ${booking.id}');
        return booking;
      }
      if (rawData is List && rawData.isNotEmpty) {
        final booking = BookingModel.fromJson(rawData[0]);
        print('[✅ PARSE SUCCESS - LIST] Booking ID: ${booking.id}');
        return booking;
      }

      print('[⚠️ Booking Error] Unexpected data format: $rawData');
      return null;
    } catch (e) {
      print('[❌ PARSE ERROR] $e');
      return null;
    }
  } else {
    print('[⚠️ Booking Error] API response invalid');
    return null;
  }
}

Future<List<BookingModel>> getAllMyBookings() async {
  final response = await BaseRepository().getRoute(
    Endpoints.getMyBookings,
  );

  print('[📥 GET MY BOOKINGS] Status: ${response.statusCode}');
  print('[📥 GET MY BOOKINGS] Data: ${response.data}');

  if (response.statusCode == StatusCode.ok &&
      response.data != null &&
      response.data['data'] != null &&
      response.data['data'] is List) {
    try {
      final List<dynamic> list = response.data['data'];
      final bookings = list
          .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
          .toList();
      print('[✅ PARSE SUCCESS] Total bookings: ${bookings.length}');
      return bookings;
    } catch (e) {
      print('[❌ PARSE BOOKINGS ERROR] $e');
      return [];
    }
  } else {
    print('[❌ GET BOOKINGS FAILED]');
    return [];
  }
}




}
