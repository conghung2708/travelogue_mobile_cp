// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelogue_mobile/representation/tour/screens/tour_qr_payment_screen.dart';
// import 'package:travelogue_mobile/representation/tour/widgets/pending_payment.dart';

// class PendingPaymentBanner extends StatelessWidget {
//   final PendingPayment data;
//   const PendingPaymentBanner({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
//       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
//       decoration: BoxDecoration(
//         color: Colors.orange.shade100.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange.shade300),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
//           SizedBox(width: 3.w),
//           Expanded(
//             child: Text(
//               "Bạn còn một tour chưa thanh toán.\nNhấn để tiếp tục hoàn tất đặt chỗ ✨",
//               style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, height: 1.5),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => TourQrPaymentScreen(
//                     tour: data.tour,
//                     schedule: data.schedule,
//                     startTime: data.startTime,
//                     adults: data.adults,
//                     children: data.children,
//                     totalPrice: data.totalPrice,
//                     checkoutUrl: data.checkoutUrl,
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//               decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
//               child: Text("Tiếp tục", style: TextStyle(color: Colors.white, fontSize: 12.sp)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
