// import 'package:flutter/material.dart';
// import 'package:travelogue_mobile/model/information_category_model.dart';
// import 'package:travelogue_mobile/model/news_model.dart';
// import 'event_detail.dart';
//
// class EventByCategory extends StatelessWidget {
//   final EventCategoryModel category;
//
//   const EventByCategory({super.key, required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(200.0),
//         child: ClipPath(
//           clipper: WaveClipper(),
//           child: AppBar(
//             flexibleSpace: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.4),
//                     Colors.black.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 image: DecorationImage(
//                   image: AssetImage(category.image),
//                   fit: BoxFit.cover,
//                   opacity: 0.5,
//                 ),
//               ),
//             ),
//             title: Text(
//               category.title,
//               style: const TextStyle(
//                 fontSize: 22.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             centerTitle: true,
//             elevation: 0,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: tayNinhSliderDatas.map((sliderData) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(
//                   EventDetailScreen.routeName,
//                   arguments: sliderData,
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(
//                     vertical: 10.0, horizontal: 10.0),
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Event image
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(sliderData.image),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // Event details
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             sliderData.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                               color: Colors.black,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 5.0),
//                           Text(
//                             sliderData.publishedDate,
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14.0,
//                             ),
//                           ),
//                           const SizedBox(height: 10.0),
//                           Text(
//                             sliderData.description,
//                             style: const TextStyle(
//                               color: Colors.black87,
//                               fontSize: 14.0,
//                             ),
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
//
// // Custom wave clipper for AppBar
// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0.0, 0.0);
//     path.lineTo(0.0, size.height - 30);
//     path.quadraticBezierTo(
//         size.width / 4, size.height, size.width / 2, size.height - 20);
//     path.quadraticBezierTo(
//         size.width * 3 / 4, size.height - 40, size.width, size.height - 30);
//     path.lineTo(size.width, 0.0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
