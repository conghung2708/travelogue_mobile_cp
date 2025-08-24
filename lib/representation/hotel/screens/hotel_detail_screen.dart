// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
// import 'package:travelogue_mobile/model/hotel_model.dart';

// class HotelDetailScreen extends StatefulWidget {
//   const HotelDetailScreen({super.key});

//   static const String routeName = '/hotel_detail_screen';

//   @override
//   State<HotelDetailScreen> createState() => _HotelDetailScreenState();
// }

// class _HotelDetailScreenState extends State<HotelDetailScreen> {
//   HotelModel? hotel;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (hotel == null) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is HotelModel) {
//         setState(() {
//           hotel = args;
//         });
//       }
//     }
//   }

//   void _openPhotoGallery(List<String> images, int initialIndex) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.black,
//             iconTheme: const IconThemeData(color: Colors.white),
//           ),
//           backgroundColor: Colors.black,
//           body: PhotoViewGallery.builder(
//             itemCount: images.length,
//             builder: (context, index) {
//               return PhotoViewGalleryPageOptions(
//                 imageProvider: NetworkImage(images[index]),
//                 minScale: PhotoViewComputedScale.contained * 0.8,
//                 maxScale: PhotoViewComputedScale.covered * 2,
//               );
//             },
//             pageController: PageController(initialPage: initialIndex),
//             scrollPhysics: const BouncingScrollPhysics(),
//             backgroundDecoration: const BoxDecoration(color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (hotel == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               hotel!.imgUrlFirst,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: kMediumPadding * 3,
//             left: kMediumPadding,
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Container(
//                 padding: const EdgeInsets.all(kItemPadding),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(kDefaultPadding),
//                 ),
//                 child: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
//               ),
//             ),
//           ),
//           Positioned(
//             top: kMediumPadding * 3,
//             right: kMediumPadding,
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 padding: const EdgeInsets.all(kItemPadding),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(kDefaultPadding),
//                 ),
//                 child: const Icon(FontAwesomeIcons.solidHeart,
//                     size: 18, color: Colors.red),
//               ),
//             ),
//           ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.36,
//             maxChildSize: 0.85,
//             minChildSize: 0.36,
//             builder: (context, scrollController) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: MediaQuery.removePadding(
//                   context: context,
//                   removeTop: true,
//                   child: ListView(
//                     controller: scrollController,
//                     children: [
//                       Center(
//                         child: Container(
//                           height: 5,
//                           width: 60,
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         hotel!.name ?? '',
//                         style: const TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       const Row(
//                         children: [
//                           Icon(Icons.star, color: Colors.orange, size: 20),
//                           Text('4.9 (1,092 Đánh giá)',
//                               style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                       SizedBox(height: 12.sp),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.location_on,
//                               color: Colors.red, size: 20),
//                           const SizedBox(width: 4),
//                           Expanded(
//                               child: Text(hotel!.address ?? '',
//                                   style: const TextStyle(fontSize: 14))),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Hình ảnh khách sạn',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildImageGallery(hotel!.listImages),
//                       const SizedBox(height: 16),
//                       const Text('Mô tả',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text(
//                         hotel!.description ?? '',
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                       const SizedBox(height: 16),
//                       // const Text(
//                       //   'Vị trí',
//                       //   style: TextStyle(
//                       //       fontSize: 18, fontWeight: FontWeight.bold),
//                       // ),
//                       // const SizedBox(height: 8),
//                       // ClipRRect(
//                       //   borderRadius: BorderRadius.circular(12),
//                       //   child: Stack(
//                       //     children: [
//                       //       Image.asset(
//                       //         AssetHelper.img_map,
//                       //         width: double.infinity,
//                       //         height: 200,
//                       //         fit: BoxFit.cover,
//                       //       ),
//                       //       Positioned(
//                       //         bottom: 10,
//                       //         right: 10,
//                       //         child: Container(
//                       //           padding: const EdgeInsets.symmetric(
//                       //               horizontal: 12, vertical: 6),
//                       //           decoration: BoxDecoration(
//                       //             color: Colors.black.withOpacity(0.6),
//                       //             borderRadius: BorderRadius.circular(8),
//                       //           ),
//                       //           child: const Row(
//                       //             children: [
//                       //               Icon(Icons.location_pin,
//                       //                   color: Colors.white, size: 16),
//                       //               SizedBox(width: 4),
//                       //               Text(
//                       //                 'Xem trên bản đồ',
//                       //                 style: TextStyle(
//                       //                   color: Colors.white,
//                       //                   fontSize: 12,
//                       //                   fontWeight: FontWeight.bold,
//                       //                 ),
//                       //               ),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageGallery(List<String> images) {
//     const maxImages = 6;
//     final remaining = images.length - maxImages;

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: images.length > maxImages ? maxImages : images.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () => _openPhotoGallery(images, index),
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 width: 1.sp,
//                 color: Colors.grey.shade300,
//               ),
//             ),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(images[index], fit: BoxFit.cover),
//                 ),
//                 if (index == maxImages - 1 && remaining > 0)
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '+$remaining',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
