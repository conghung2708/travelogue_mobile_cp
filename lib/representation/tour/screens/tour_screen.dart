import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_suggestion_test_model.dart';

class TourScreen extends StatelessWidget {
  const TourScreen({super.key});

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
                  Icon(Icons.notifications_active, color: Colors.grey[700], size: 6.w),
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
              Text(
                "Gợi ý dành cho bạn",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),

              CarouselSlider.builder(
                itemCount: mockTours.length,
                itemBuilder: (context, index, realIdx) {
                  final tour = mockTours[index];
                  return TourCard(tour: tour);
                },
                options: CarouselOptions(
                  height: 40.h,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Cá nhân hoá chuyến đi của bạn",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.5.h),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/custom-tour'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.explore, color: Colors.white, size: 6.w),
                      SizedBox(width: 3.w),
                      Text(
                        "Khám phá theo sở thích",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  final TourSuggestionTestModel tour;

  const TourCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Image.asset(
            tour.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 40.h,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          left: 5.w,
          bottom: 4.h,
          right: 5.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tour.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.8.h),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 4.w),
                  SizedBox(width: 1.w),
                  Text(
                    "5.0  •  ${tour.destinations.length} địa điểm",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(height: 1.8.h),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward, size: 5.w),
                label: Text("Xem chi tiết", style: TextStyle(fontSize: 12.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
