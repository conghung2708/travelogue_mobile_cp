import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WorkshopImageCarousel extends StatelessWidget {
  final String workshopId;
  final List<String> images;
  const WorkshopImageCarousel(
      {super.key, required this.workshopId, required this.images});

  @override
  Widget build(BuildContext context) => CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder: (_, i, __) => Hero(
          tag: '${workshopId}_img_$i',
          child: Image.asset(images[i], fit: BoxFit.cover, width: 100.w),
        ),
        options: CarouselOptions(
          height: 30.h,
          viewportFraction: 1,
          enableInfiniteScroll: false,
        ),
      );
}
