import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/model/information_category_model.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/event/screens/event_detail.dart';
import 'package:travelogue_mobile/representation/event/screens/event_screen.dart';
import 'package:travelogue_mobile/representation/event/widgets/event_category.dart';
import 'package:travelogue_mobile/representation/event/widgets/news_card.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_screen.dart';
import 'package:travelogue_mobile/representation/news/screens/news_screen.dart';
import 'package:travelogue_mobile/representation/widgets/build_slider_image.dart';

class EventContent extends StatefulWidget {
  final bool showCategory;

  const EventContent({super.key, this.showCategory = true});

  @override
  State<EventContent> createState() => _EventContentState();
}

class _EventContentState extends State<EventContent> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final List<NewsModel> listNews = (state.props[0] as List<NewsModel>)
            .where((news) => news.newsCategory == 1)
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showCategory)
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 5)
                      .add(EdgeInsets.only(top: 10.sp)),
                  child: Row(
                    children: eventCategories
                        .map(
                          (e) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () {
                                  if (e.id == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const NewsScreen(),
                                      ),
                                    );
                                  }
                                  if (e.id == 2) {
                                    Navigator.of(context)
                                        .pushNamed(FestivalScreen.routeName);
                                  }
                                  if (e.id == 3) {
                                    Navigator.of(context)
                                        .pushNamed(ExperienceScreen.routeName);
                                  }
                                },
                                child: EventCategory(
                                  image: e.image,
                                  eventCategoryName: e.title,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              listNews.isEmpty
                  ? _pageEmpty
                  : Column(
                      children: [
                        const SizedBox(height: 30),
                        CarouselSlider.builder(
                          itemCount: min(listNews.length, 7),
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ExperienceDetailScreen.routeName,
                                  arguments: listNews[index],
                                );
                              },
                              child: BuildSliderImage(
                                image: listNews[index].imgUrlFirst,
                                index: index,
                                name: listNews[index].title ?? '',
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: buildIndicator(
                            count: min(listNews.length, 7),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: listNews.map((sliderData) {
                            return NewsCard(news: sliderData);
                          }).toList(),
                        )
                      ],
                    )
            ],
          ),
        );
      },
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
            "Chưa có thông tin nào",
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

  Widget buildIndicator({
    required int count,
  }) =>
      AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: count,
        effect: SlideEffect(
          dotWidth: 10.sp,
          dotHeight: 10.sp,
          activeDotColor: Colors.blue,
        ),
      );
}
