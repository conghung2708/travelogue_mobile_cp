import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/model/enums/tour_guide_status_enum.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';

class SelectTourGuideScreen extends StatefulWidget {
  static const String routeName = '/select-tour-guide';

  const SelectTourGuideScreen({super.key});

  @override
  State<SelectTourGuideScreen> createState() => _SelectTourGuideScreenState();
}

class _SelectTourGuideScreenState extends State<SelectTourGuideScreen> {
  final PageController _controller = PageController();
  late TripPlan trip;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is TripPlan) {
      trip = args;
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: mockTourGuides.length,
            itemBuilder: (context, index) {
              final guide = mockTourGuides[index];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      guide.avatarUrl,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.darken,
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
                          CircleAvatar(
                            radius: 42.sp,
                            backgroundImage: AssetImage(guide.avatarUrl),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 2.h),
                          _buildInfoCard(guide),
                          SizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildGlassButton(
                                Icons.close,
                                'Bỏ qua',
                                Colors.redAccent,
                                () => _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              _buildGlassButton(
                                Icons.check,
                                'Chọn',
                                Colors.green,
                                () {
                                  final updatedGuide = TourGuideTestModel(
                                    id: guide.id,
                                    name: guide.name,
                                    age: guide.age,
                                    gender: guide.gender,
                                    avatarUrl: guide.avatarUrl,
                                    bio: guide.bio,
                                    tags: guide.tags,
                                    rating: guide.rating,
                                    reviewsCount: guide.reviewsCount,
                                    price: guide.price,
                                    status: TourGuideStatus.pending,
                                  );

                                  trip.tourGuide = updatedGuide;
                                  trip.statusEnum = TripStatus.planning;
                                  Navigator.pop(context, trip);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          SmoothPageIndicator(
                            controller: _controller,
                            count: mockTourGuides.length,
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

  Widget _buildInfoCard(TourGuideTestModel guide) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              const BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '${guide.name}, ${guide.age}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 16.sp,
                    color:
                        i < guide.rating ? Colors.amber : Colors.grey.shade300,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                guide.bio,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: guide.tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: TextStyle(fontSize: 14.sp)),
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13.sp),
          )
        ],
      ),
    );
  }
}
