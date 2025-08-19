import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';

class SelectTourGuideScreen extends StatefulWidget {
  static const String routeName = '/select-tour-guide';

  const SelectTourGuideScreen({super.key});

  @override
  State<SelectTourGuideScreen> createState() => _SelectTourGuideScreenState();
}

class _SelectTourGuideScreenState extends State<SelectTourGuideScreen> {
  final PageController _controller = PageController();
  TripPlanDetailModel? tripDetail;
  List<TourGuideModel> guides = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (tripDetail != null) return;

    if (args is TripPlanDetailModel) {
      tripDetail = args;
      _fetchTourGuides();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _fetchTourGuides() async {
    if (tripDetail == null) return;

    final filter = TourGuideFilterModel(
      startDate: tripDetail!.startDate,
      endDate: tripDetail!.endDate,
    );

    final result = await TourGuideRepository().filterTourGuides(filter);

    setState(() {
      guides = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (guides.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Không tìm thấy hướng dẫn viên phù hợp\ntrong khoảng ngày bạn chọn.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Image.asset(
                          AssetHelper.img_tay_ninh_login,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black87, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child:
                              Container(color: Colors.black.withOpacity(0.2)),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 42.sp,
                              backgroundImage: (guide.avatarUrl != null &&
                                      guide.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(guide.avatarUrl!)
                                  : AssetImage(AssetHelper.avatar)
                                      as ImageProvider,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          _buildInfoCard(guide),
                          SizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildGlassButton(
                                  Icons.close, 'Bỏ qua', Colors.redAccent, () {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }),
                              _buildGlassButton(
                                  Icons.check, 'Chọn', Colors.green, () {
                                Navigator.pop(context, guide);
                              }),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          SmoothPageIndicator(
                            controller: _controller,
                            count: guides.length,
                            effect: WormEffect(
                              dotHeight: 1.2.h,
                              dotWidth: 2.5.w,
                              activeDotColor: Colors.white,
                              dotColor: Colors.white30,
                            ),
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(TourGuideModel guide) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                guide.userName ?? 'Không rõ tên',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 0.5.h),
              if (guide.sexText != null)
                Text(
                  guide.sexText!,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 16.sp,
                      color: i < (guide.averageRating ?? 0).round()
                          ? Colors.amber
                          : Colors.grey.shade300,
                    ),
                  ),
                  if ((guide.totalReviews ?? 0) > 0)
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Text(
                        '(${guide.totalReviews} đánh giá)',
                        style:
                            TextStyle(fontSize: 11.sp, color: Colors.black54),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 1.h),
              if (guide.introduction != null && guide.introduction!.isNotEmpty)
                Text(
                  guide.introduction!,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 1.2.h),
              if (guide.email != null)
                Text(
                  guide.email!,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              if (guide.address != null)
                Text(
                  guide.address!,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              if (guide.price != null)
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Chip(
                    backgroundColor: Colors.green.shade50,
                    label: Text(
                      'Giá: ${guide.price!.toStringAsFixed(0)}đ/ngày',
                      style:
                          TextStyle(color: Colors.green[700], fontSize: 13.sp),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 24.sp),
                    ),
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(label, style: TextStyle(color: color, fontSize: 13.sp)),
              ],
            ),
          );
        },
      ),
    );
  }
}
