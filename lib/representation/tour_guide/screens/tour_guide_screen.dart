import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/tour_guide_card.dart';

class TourGuideScreen extends StatelessWidget {
  const TourGuideScreen({super.key});

  static const String routeName = '/tour-guides';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 2.h,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage(AssetHelper.avatar),
                    radius: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
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
                          "Chọn hướng dẫn viên đồng hành cùng bạn",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.notifications_none,
                      size: 7.w, color: Colors.grey[600]),
                ],
              ),
              SizedBox(height: 3.h),

              // Banner
              Stack(
                children: [
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      image: const DecorationImage(
                        image: AssetImage(AssetHelper.img_nui_ba_den_1),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5.w,
                    bottom: 3.h,
                    right: 5.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "“Mỗi cuộc hành trình là một trang ký ức”",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                        Text(
                          "Hãy chọn người đồng hành phù hợp với bạn!",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),

              const TitleWithCustoneUnderline(
                text: "Các hướng dẫn ",
                text2: "viên",
              ),
              SizedBox(height: 2.h),

              // Masonry Grid
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.h,
                  crossAxisSpacing: 4.w,
                  itemCount: mockTourGuides.length,
                  itemBuilder: (context, index) {
                    final guide = mockTourGuides[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: TourGuideCard(guide: guide),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
