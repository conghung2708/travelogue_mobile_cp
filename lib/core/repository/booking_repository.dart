import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';
import 'package:travelogue_mobile/model/booking/review_booking_request.dart';
import 'package:travelogue_mobile/model/tour_guide/create_booking_tour_guide_model.dart';
import 'package:travelogue_mobile/model/workshop/create_booking_workshop_model.dart';

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

  Future<BookingModel?> createGuideBooking(
      CreateBookingTourGuideModel model) async {
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

  Future<BookingModel?> createWorkshopBooking(
    CreateBookingWorkshopModel model,
  ) async {
    final body = model.toJson();
    print('[📤 CREATE WORKSHOP BOOKING] Sending body: $body');

    final response = await BaseRepository().postRoute(
      gateway: Endpoints.createBookingWorkshop,
      data: body,
    );

    print('[📥 CREATE WORKSHOP BOOKING] Status: ${response.statusCode}');
    print('[📥 CREATE WORKSHOP BOOKING] Data: ${response.data}');

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

// BookingRepository.cancelBooking
  Future<({bool ok, String? message})> cancelBooking(String id) async {
    final endpoint = '${Endpoints.cancelBooking}/$id/cancel';
    print('[📤 CANCEL BOOKING] PUT $endpoint');

    // ❌ bỏ data: {}
    final res = await BaseRepository().putRoute(gateway: endpoint);

    print('[📥 CANCEL BOOKING] Status: ${res.statusCode}');
    print('[📥 CANCEL BOOKING] Data: ${res.data}');

    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final m = res.data as Map;
      final ok = (m['succeeded'] ?? m['Succeeded']) == true;
      final msg = (m['message'] ?? m['Message'])?.toString();
      return (ok: ok, message: msg);
    }
    final msg = (res.data is Map)
        ? ((res.data['message'] ?? res.data['Message'])?.toString())
        : null;
    return (ok: false, message: msg);
  }

// core/repository/booking_repository.dart
  Future<BookingModel?> getBookingById(String id) async {
    final endpoint = '${Endpoints.getBookingById}/$id';
    print('[📤 GET BOOKING] $endpoint');

    final res = await BaseRepository().getRoute(endpoint);

    print('[📥 GET BOOKING] Status: ${res.statusCode}');
    print('[📥 GET BOOKING] Data: ${res.data}');

    if (res.statusCode == StatusCode.ok &&
        res.data != null &&
        res.data['data'] is Map<String, dynamic>) {
      try {
        return BookingModel.fromJson(res.data['data'] as Map<String, dynamic>);
      } catch (e) {
        print('[❌ PARSE BOOKING ERROR] $e');
        return null;
      }
    }
    return null;
  }

  Future<({bool ok, String? message})> reviewBooking(
      ReviewBookingRequest req) async {
    print('[📤 REVIEW BOOKING] POST ${Endpoints.reviewBooking}');
    print('[📤 REVIEW BOOKING] Body: ${req.toJson()}');

    final res = await BaseRepository().postRoute(
      gateway: Endpoints.reviewBooking,
      data: req.toJson(),
    );

    print('[📥 REVIEW BOOKING] Status: ${res.statusCode}');
    print('[📥 REVIEW BOOKING] Data: ${res.data}');

    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final rawMap = Map<String, dynamic>.from(res.data as Map);
      final result = ReviewBookingResult.fromMap(rawMap);
      return (ok: result.succeeded, message: result.message);
    }

    final msg = (res.data is Map)
        ? ((res.data['message'] ?? res.data['Message'])?.toString())
        : null;
    return (ok: false, message: msg ?? 'Đánh giá thất bại.');
  }

   Future<Set<String>> getMyReviewedBookingIds({int? rating}) async {
    final String url = (rating == null)
        ? Endpoints.getMyReviews              
        : '${Endpoints.getMyReviews}?rating=$rating';

    final res = await BaseRepository().getRoute(url);

    if (res.statusCode == StatusCode.ok &&
        res.data is Map &&
        (res.data['data'] is List)) {
      final List<dynamic> list = res.data['data'];
      final ids = <String>{};
      for (final item in list) {
        if (item is Map && item['bookingId'] is String) {
          ids.add(item['bookingId'] as String);
        }
      }
      return ids;
    }
    return <String>{};
  }
}
