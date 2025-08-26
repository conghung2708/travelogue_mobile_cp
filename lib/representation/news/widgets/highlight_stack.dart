import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/experience/widgets/experience_slide_card.dart';

class HighlightStack extends StatefulWidget {
  final List<NewsModel> highlighted; // isHighlighted == true
  const HighlightStack({super.key, required this.highlighted});

  @override
  State<HighlightStack> createState() => _HighlightStackState();
}

class _HighlightStackState extends State<HighlightStack> {
  int activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.highlighted.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.highlighted.length,
          itemBuilder: (context, index, realIndex) {
            final news = widget.highlighted[index];
            return ExperienceSlideCard(
              news: news,
              categoryName: (news.categoryName ?? 'Tin tức').trim(),
            );
          },
          options: CarouselOptions(
            height: 24.h,
            autoPlay: true,
            viewportFraction: 0.78,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            onPageChanged: (index, reason) {
              setState(() => activeIndex = index);
            },
          ),
        ),
        SizedBox(height: 1.h),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: widget.highlighted.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey.shade300,
          ),
          onDotClicked: (index) async {
         
            await _controller.onReady;
            await _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}