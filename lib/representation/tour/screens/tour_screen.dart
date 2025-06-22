import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour_suggestion_test_model.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage(AssetHelper.avatar),
                    radius: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào, Hưng",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Pattaya",
                        ),
                      ),
                      Text(
                        "Khám phá hành trình tuyệt vời",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.notifications_active,
                      color: Colors.grey[700], size: 6.w),
                ],
              ),
              SizedBox(height: 2.5.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm tour...",
                    prefixIcon: Icon(Icons.search, size: 6.w),
                    suffixIcon: Icon(Icons.filter_list, size: 6.w),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                text: "Chuyến đi ",
                text2: "cá nhân",
              ),
              SizedBox(height: 2.h),
              Container(
                height: 20.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                  image: DecorationImage(
                    image: AssetImage(AssetHelper.img_ex_ba_den),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.w),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.black.withOpacity(0.15),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            child: Icon(Icons.auto_awesome,
                                color: Colors.deepPurple, size: 6.w),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: const [
                                            Colors.cyanAccent,
                                            Colors.blueAccent
                                          ],
                                          stops: [
                                            (_controller.value - 0.3)
                                                .clamp(0.0, 1.0),
                                            _controller.value.clamp(0.0, 1.0)
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(0, 0, bounds.width,
                                              bounds.height),
                                        );
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: Text(
                                        "Tạo hành trình riêng của bạn",
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Pattaya",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "Cá nhân hóa trải nghiệm du lịch theo sở thích, thời gian và ngân sách của bạn.",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 1.2.h),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyTripPlansScreen.routeName);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.2.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.w),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.lightBlueAccent,
                                          Colors.blueAccent
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      "Bắt đầu ngay",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                text: "Các tour ",
                text2: "gợi ý",
              ),
              SizedBox(height: 2.h),
              Expanded(child: TourMasonryGrid(tours: mockTours)),
            ],
          ),
        ),
      ),
    );
  }
}

class TourMasonryGrid extends StatelessWidget {
  final List<TourSuggestionTestModel> tours;
  const TourMasonryGrid({super.key, required this.tours});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2.h,
      crossAxisSpacing: 4.w,
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final height = (20 + random.nextInt(10)).h;
        return SizedBox(
          height: height,
          child: TourCard(tour: tours[index]),
        );
      },
    );
  }
}

class TourCard extends StatelessWidget {
  final TourSuggestionTestModel tour;
  const TourCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              tour.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 3.w,
            bottom: 3.h,
            right: 3.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 4.w),
                    SizedBox(width: 1.w),
                    Text(
                      "${tour.destinations.length} địa điểm",
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
