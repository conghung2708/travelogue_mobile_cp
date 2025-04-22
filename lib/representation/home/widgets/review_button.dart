// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelogue_mobile/model/review_base_model.dart';
// import 'package:travelogue_mobile/representation/home/widgets/reviews_screen.dart';

// class ReviewButton<T extends ReviewBase> extends StatelessWidget {
//   final double rating;
//   final List<T> reviews;

//   const ReviewButton({
//     super.key,
//     required this.rating,
//     required this.reviews,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ReviewsScreen<T>(
//                 reviews: reviews,
//                 averageRating: rating,
//               ),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.star, color: Colors.amber, size: 20.sp),
//               SizedBox(width: 2.w),
//               Text(
//                 rating.toStringAsFixed(1),
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(width: 2.w),
//               Icon(Icons.edit_note_rounded,
//                   color: Colors.blueAccent, size: 20.sp),
//               SizedBox(width: 1.w),
//               Text(
//                 "Xem đánh giá",
//                 style: TextStyle(
//                   fontSize: 11.5.sp,
//                   color: Colors.blueAccent,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
