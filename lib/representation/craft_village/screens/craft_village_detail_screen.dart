import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travelogue_mobile/representation/map/screens/viet_map_location_screen.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' as vietmap;

import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/review_craft_village_test.dart';
import 'package:travelogue_mobile/representation/craft_village/widgets/masonry_item.dart';
import 'package:travelogue_mobile/representation/home/widgets/rating_button_widget.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_state.dart';

class CraftVillageDetailScreen extends StatefulWidget {
  const CraftVillageDetailScreen({super.key});
  static const String routeName = '/craft_village_detail_screen';

  @override
  State<CraftVillageDetailScreen> createState() =>
      _CraftVillageDetailScreenState();
}

class _CraftVillageDetailScreenState extends State<CraftVillageDetailScreen>
    with TickerProviderStateMixin {
  LocationModel? village;
  double currentRating = 4.5;
  late final TabController _tabController;

  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  vietmap.VietmapController? _mapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (village == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is LocationModel) {
        setState(() => village = args);
      }
    }
  }

  Future<void> _speakContent() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
      return;
    }
    if (village?.content?.isNotEmpty == true) {
      await flutterTts.setLanguage("vi-VN");
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1);
      setState(() => isSpeaking = true);
      await flutterTts.speak(village!.content!);
      flutterTts.setCompletionHandler(() {
        setState(() => isSpeaking = false);
      });
    }
  }

  Widget _buildIntroTab(ScrollController sc) => ListView(
        controller: sc,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(village!.name ?? '',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pattaya')),
                    SizedBox(height: 1.h),
                    Row(children: [
                      Icon(Icons.location_on,
                          color: Colors.redAccent, size: 18.sp),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          '${village!.address ?? ''}${village!.districtName != null ? ', ${village!.districtName}' : ''}',
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey[800]),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              RatingButtonWidget(
                rating: currentRating,
                onTap: () async {
                  final res = await Navigator.push<double>(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ReviewsScreen<ReviewCraftVillageTestModel>(
                                reviews: [], averageRating: currentRating)),
                  );
                  if (res != null) {
                    setState(() => currentRating = res);
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Nút Loa đọc
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AvatarGlow(
                animate: isSpeaking,
                glowColor: isSpeaking ? Colors.redAccent : Colors.blueAccent,
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
                        const BoxShadow(
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
            const Padding(
              padding: EdgeInsets.only(top: 4),
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

          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(right: 55.w),
            child: const TitleWithCustoneUnderline(text: 'Giới ', text2: 'thiệu : '),
          ),
          SizedBox(height: 1.h),
          MarkdownBody(
            data: village!.content ?? '',
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(fontSize: 15.sp, color: Colors.black87),
              listBullet: TextStyle(fontSize: 14.sp),
            ),
          ),

          SizedBox(height: 2.5.h),
          Padding(
            padding: EdgeInsets.only(right: 55.w),
            child: const TitleWithCustoneUnderline(
              text: 'Hình ',
              text2: 'ảnh :',
            ),
          ),
          SizedBox(height: 1.h),
          ImageGridPreview(images: village!.listImages),

          SizedBox(height: 2.5.h),
          Padding(
            padding: EdgeInsets.only(right: 45.w),
            child: TitleWithCustoneUnderline(
                text: 'Thông tin ', text2: 'liên hệ :'),
          ),
          SizedBox(height: 1.h),
          if (village!.openTime != null)
            Text('🕒 Giờ mở cửa: ${village!.openTime}',
                style: TextStyle(fontSize: 14.sp)),
          if (village!.closeTime != null)
            Text('🕒 Giờ đóng cửa: ${village!.closeTime}',
                style: TextStyle(fontSize: 14.sp)),

          SizedBox(height: 3.h),

          // Bản đồ
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  vietmap.VietmapGL(
                    myLocationEnabled: false,
                    trackCameraPosition: true,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    styleString:
                        'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=840f8a8247cb32578fc81fec50af42b8ede321173a31804b',
                    initialCameraPosition: vietmap.CameraPosition(
                      target: vietmap.LatLng(
                        village!.latitude ?? 10.762622,
                        village!.longitude ?? 106.660172,
                      ),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                    },
                    onMapClick: (point, latlng) {
                      Navigator.pushNamed(
                        context,
                        VietMapLocationScreen.routeName,
                        arguments: vietmap.LatLng(
                          village!.latitude ?? 10.762622,
                          village!.longitude ?? 106.660172,
                        ),
                      );
                    },
                  ),
                  if (_mapController != null)
                    vietmap.MarkerLayer(
                      markers: [
                        vietmap.Marker(
                          alignment: Alignment.bottomCenter,
                          height: 30,
                          width: 30,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                          latLng: vietmap.LatLng(
                            village!.latitude ?? 10.762622,
                            village!.longitude ?? 106.660172,
                          ),
                        ),
                      ],
                      mapController: _mapController!,
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),
        ],
      );

  Widget _buildWorkshopTab(ScrollController sc) {
    return BlocBuilder<WorkshopBloc, WorkshopState>(
      builder: (context, state) {
        if (state is WorkshopLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkshopLoaded) {
          if (state.workshops.isEmpty) {
            return const Center(child: Text('Chưa có workshop nào.'));
          }
          return MasonryGridView.count(
            controller: sc,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            crossAxisCount: 2,
            mainAxisSpacing: 2.h,
            crossAxisSpacing: 3.w,
            itemCount: state.workshops.length,
            itemBuilder: (_, i) => MasonryItem(workshop: state.workshops[i]),
          );
        } else if (state is WorkshopError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (village == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(children: [
        if (village!.listImages.isNotEmpty)
          Positioned.fill(
              child:
                  Image.network(village!.listImages.first, fit: BoxFit.cover)),
        Positioned(
          top: 0,
          left: 0,
          child: _BackButton(),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.93,
          minChildSize: 0.4,
          builder: (context, sc) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(children: [
                Container(
                  width: 12.w,
                  height: 0.6.h,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10)),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  labelStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  tabs: const [Tab(text: 'Giới thiệu'), Tab(text: 'Workshop')],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildIntroTab(sc), _buildWorkshopTab(sc)],
                  ),
                )
              ]),
            );
          },
        )
      ]),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(FontAwesomeIcons.arrowLeft, size: 20),
          ),
        ),
      ),
    );
  }
}
