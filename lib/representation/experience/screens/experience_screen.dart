import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/experience/widgets/experience_new_card.dart';
import 'package:travelogue_mobile/representation/experience/widgets/experience_slide_card.dart';
import 'package:travelogue_mobile/representation/widgets/custom_page_appbar.dart';

class ExperienceScreen extends StatefulWidget {
  static const routeName = "/experience_screen";

  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomPageAppBar(
        title: 'Trải nghiệm tại Tây Ninh',
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          final List<NewsModel> experiences =
              (state.props[0] as List<NewsModel>)
                  .where((news) => news.newsCategory == 3)
                  .toList();

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: experiences.isEmpty
                ? _pageEmpty
                : ListView(
                    children: [
                      SizedBox(height: 2.h),
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 23.h,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.85,
                          aspectRatio: 16 / 9,
                          autoPlayInterval: const Duration(seconds: 4),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                        ),
                        items: experiences.take(7).map((news) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ExperienceSlideCard(
                                news: news,
                                categoryName: "Trải nghiệm",
                              );
                            },
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 1.h),

                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _currentCarouselIndex,
                          count: min(7, experiences.length),
                          effect: ExpandingDotsEffect(
                            dotHeight: 10.sp,
                            dotWidth: 10.sp,
                            spacing: 8,
                            activeDotColor: Colors.blueAccent,
                            dotColor: Colors.grey.shade300,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Experience List
                      ...experiences.map(
                        (news) => ExperienceNewsCard(
                          news: news,
               
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ExperienceDetailScreen.routeName,
                              arguments: news,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget get _pageEmpty {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50.sp),
          ImageHelper.loadFromAsset(
            AssetHelper.img_search_not_found,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            "Chưa có trải nghiệm nào.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
