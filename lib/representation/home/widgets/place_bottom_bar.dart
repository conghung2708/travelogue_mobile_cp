import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/craft_village/screens/craft_village.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';
import 'package:travelogue_mobile/representation/restaurent/widgets/restaurents.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:avatar_glow/avatar_glow.dart';

class PlaceBottomBar extends StatefulWidget {
  final LocationModel place;

  const PlaceBottomBar({super.key, required this.place});

  @override
  State<PlaceBottomBar> createState() => _PlaceBottomBarState();
}

class _PlaceBottomBarState extends State<PlaceBottomBar> {
  VietmapController? _controller;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _speakContent() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
      return;
    }

    if (widget.place.content?.isNotEmpty == true) {
      await flutterTts.setLanguage("vi-VN");
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1.0);
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(widget.place.content!);
      flutterTts.setCompletionHandler(() {
        setState(() {
          isSpeaking = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.place.name ?? '',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Hàng "Tỉnh đoàn Tây Ninh" + Nút loa
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage(AssetHelper.img_logo_tay_ninh),
                          ),
                          SizedBox(width: 2.w),
                          const Text(
                            'Tỉnh đoàn Tây Ninh',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                          const Spacer(),
                          AvatarGlow(
                            animate: isSpeaking,
                            glowColor: isSpeaking
                                ? Colors.redAccent
                                : Colors.blueAccent,
                            child: InkWell(
                              onTap: _speakContent,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: isSpeaking
                                        ? [Colors.redAccent, Colors.red]
                                        : [Colors.blueAccent, Colors.blue],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  isSpeaking ? Icons.stop : Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (isSpeaking)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Đang đọc...",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      // Nội dung địa điểm
                      Text(
                        widget.place.content ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),

                // Hình ảnh
                if (widget.place.listImages.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.place.listImages.length,
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _openPhotoGallery(
                              context, widget.place.listImages, index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ImageNetworkCard(
                                url: widget.place.listImages[index],
                                height: 100,
                                width: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // const CraftVillages(),
                // const Restaurents(),
                SizedBox(height: 20.sp),

                // Map
                Container(
                  width: double.infinity,
                  height: 60.sp,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 12.sp)
                      .add(EdgeInsets.only(bottom: 20.sp)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        VietmapGL(
                          myLocationEnabled: false,
                          trackCameraPosition: true,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          styleString:
                              'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=840f8a8247cb32578fc81fec50af42b8ede321173a31804b',
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              widget.place.latitude ?? 10.762622,
                              widget.place.longitude ?? 106.660172,
                            ),
                            zoom: 12,
                          ),
                          onMapCreated: (controller) {
                            setState(() {
                              _controller = controller;
                            });
                          },
                          onMapClick: (point, latpn) {
                            Navigator.pushNamed(
                              context,
                              VietMapLocationScreen.routeName,
                              arguments: LatLng(
                                widget.place.latitude ?? 10.762622,
                                widget.place.longitude ?? 106.660172,
                              ),
                            );
                          },
                        ),
                        if (_controller != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                alignment: Alignment.bottomCenter,
                                height: 30,
                                width: 30,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                latLng: LatLng(
                                  widget.place.latitude ?? 10.762622,
                                  widget.place.longitude ?? 106.660172,
                                ),
                              ),
                            ],
                            mapController: _controller!,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPhotoGallery(
      BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            pageController: PageController(initialPage: initialIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
