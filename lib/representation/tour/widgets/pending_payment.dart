// import 'package:travelogue_mobile/model/tour/tour_model.dart';
// import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

// class PendingPayment {
//   final TourModel tour;
//   final TourScheduleModel schedule;
//   final DateTime startTime;
//   final int adults;
//   final int children;
//   final num totalPrice;
//   final String checkoutUrl;

//   const PendingPayment({
//     required this.tour,
//     required this.schedule,
//     required this.startTime,
//     required this.adults,
//     required this.children,
//     required this.totalPrice,
//     required this.checkoutUrl,
//   });

//   static PendingPayment? fromArgs(Map<String, dynamic>? args) {
//     if (args == null || args['pendingPayment'] != true) return null;
//     try {
//       return PendingPayment(
//         tour: TourModel.fromJson(args['tour']),
//         schedule: TourScheduleModel.fromJson(args['schedule']),
//         startTime: DateTime.parse(args['startTime']),
//         adults: args['adults'],
//         children: args['children'],
//         totalPrice: args['totalPrice'],
//         checkoutUrl: args['paymentLink'],
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   bool get isExpired => DateTime.now().difference(startTime).inMinutes >= 5;
// }
