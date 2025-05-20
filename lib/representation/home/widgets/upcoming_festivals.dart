import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/model/event_model.dart';

import 'package:travelogue_mobile/representation/home/widgets/festival_card.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class UpcomingFestivals extends StatefulWidget {
  final List<EventModel> festivals;

  const UpcomingFestivals({super.key, required this.festivals});

  @override
  State<UpcomingFestivals> createState() => _UpcomingFestivalsState();
}

class _UpcomingFestivalsState extends State<UpcomingFestivals> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming = widget.festivals.where((f) {
      return f.startDate?.isAfter(now) ?? false;
    }).toList();

    if (upcoming.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWithCustoneUnderline(
          text: 'Sự kiện',
          text2: ' sắp diễn ra',
        ),
        SizedBox(height: 15.sp),
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: min(upcoming.length, 7),
          itemBuilder: (context, index, realIndex) {
            final fest = upcoming[index];
            return FestivalHomeCard(fest: fest);
          },
          options: CarouselOptions(
            height: 18.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },  
          ),
        ),
        SizedBox(height: 1.5.h),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: min(upcoming.length, 7),
            effect: SlideEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor: Colors.blueAccent,
              dotColor: Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}
