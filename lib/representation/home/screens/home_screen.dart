// home_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/config/app_env.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/news/widgets/highlight_stack.dart';
import 'package:travelogue_mobile/representation/news/widgets/spotlight_news.dart';
import 'package:weather/weather.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/home/home_bloc.dart';
import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';

import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/core/helpers/string_helper.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/model/place_category.dart';

import 'package:travelogue_mobile/representation/home/screens/search_screen.dart';
import 'package:travelogue_mobile/representation/home/widgets/app_bar_container.dart';
import 'package:travelogue_mobile/representation/home/widgets/rotating_suprise_button.dart';
import 'package:travelogue_mobile/representation/home/widgets/upcoming_festivals.dart';
import 'package:travelogue_mobile/representation/home/widgets/hot_location.dart';

import 'package:travelogue_mobile/representation/experience/widgets/experience_new_card.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Weather? _weather;
  late WeatherFactory wf;
  late AnimationController _sunController;
  final double lat = 11.3495;
  final double lon = 106.1099;
  int indexTypeLocation = -1;

  @override
  void initState() {
    super.initState();
    AppBloc.homeBloc.add(const GetAllLocationEvent());

    final apiKey = AppEnv.openWeatherKey;
    wf = WeatherFactory(apiKey, language: Language.VIETNAMESE);
    _getWeather();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }

  void _getWeather() async {
    try {
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      setState(() => _weather = w);
    } catch (e) {
      debugPrint("Lỗi lấy thời tiết: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppBarContainerWidget(
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding,
          ),
          child: ValueListenableBuilder(
            valueListenable: Hive.box(StorageKey.boxUser)
                .listenable(keys: [StorageKey.account]),
            builder: (context, box, _) {
              final local = UserLocal().getUser();
              final String userName =
                  (local.fullName?.trim().isNotEmpty == true)
                      ? local.fullName!.trim()
                      : (local.userName ?? '');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chào ${userName.isEmpty ? 'Bạn' : (StringHelper().formatUserName(userName) ?? 'Bạn')}!',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "Pattaya",
                            ),
                          ),
                          const SizedBox(height: kDefaultPadding),
                          Row(
                            children: [
                              AnimatedBuilder(
                                animation: _sunController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _sunController.value * 2 * pi,
                                    child: const Icon(
                                      Icons.wb_sunny_outlined,
                                      color: Colors.amberAccent,
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Tây Ninh chờ bạn khám phá !',
                                    textStyle: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    speed: const Duration(milliseconds: 60),
                                  ),
                                ],
                                totalRepeatCount: 999,
                                pause: const Duration(milliseconds: 2000),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (userName.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.bell,
                              size: kDefaultIconSize,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: Builder(
                                  builder: (context) {
                                    final local = UserLocal().getUser();
                                    final avatarUrl = local.avatarUrl;
                                    if (avatarUrl != null &&
                                        avatarUrl.isNotEmpty) {
                                      return Image.network(
                                        avatarUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            ImageHelper.loadFromAsset(
                                          AssetHelper.img_avatar,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                    return ImageHelper.loadFromAsset(
                                      AssetHelper.img_avatar,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_weather != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.network(
                            'https://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.cloud,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_weather!.temperature?.celsius?.toStringAsFixed(0)}°C',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              '${_weather!.weatherDescription}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // search
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMediumPadding),
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(SearchScreen.routeName),
                    child: const AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm địa điểm...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(kTopPadding),
                            child: Icon(FontAwesomeIcons.magnifyingGlass,
                                color: Colors.black, size: kDefaultIconSize),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF5F99A9), width: 0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(kItemPadding)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF5F99A9), width: 0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(kItemPadding)),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: kItemPadding),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                    
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kMediumPadding),
                          child: placeCategories.isNotEmpty
                              ? SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: placeCategories.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final category = placeCategories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          AppBloc.homeBloc.add(
                                            FilterLocationByCategoryEvent(
                                              category: category.title,
                                            ),
                                          );
                                          setState(() {
                                            indexTypeLocation = index;
                                          });
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color:
                                                category.color.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: indexTypeLocation == index
                                                  ? category.color
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                category.image,
                                                width: 28,
                                                height: 28,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                category.title,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Center(
                                  child: Text('Không có danh mục địa điểm'),
                                ),
                        ),

                    
                        BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state is GetHomeSuccess) {
                              final List<LocationModel> listLocation =
                                  state.locations;
                              final List<EventModel> listEvents = state.events;

                              return Column(
                                children: [
                                  const SizedBox(height: kDefaultPadding),
                                  HotLocations(places: listLocation),
                                  const SizedBox(height: kDefaultPadding),
                                  UpcomingFestivals(festivals: listEvents),
                                  const SizedBox(height: kDefaultPadding),
                                ],
                              );
                            }
                            return const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),

                       
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Divider(
                            color: Colors.black12.withOpacity(.2),
                          ),
                        ),

                       
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kMediumPadding,
                            right: kMediumPadding,
                            top: kDefaultPadding,
                            bottom: 4,
                          ),
                          child: Row(
                            children: [
                              const TitleWithCustoneUnderline(
                                text: "Bản tin ",
                                text2: "nổi bật 🌟",
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        BlocBuilder<NewsBloc, NewsState>(
                          builder: (context, state) {
                            final List<NewsModel> allNews =
                                (state.props.isNotEmpty &&
                                        state.props[0] is List<NewsModel>)
                                    ? (state.props[0] as List<NewsModel>)
                                    : <NewsModel>[];

                            final List<NewsModel> highlighted = allNews
                                .where((e) => e.isHighlighted == true)
                                .toList();

                            if (allNews.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            if (highlighted.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kMediumPadding, vertical: 8),
                                child: _EmptyInfo(
                                  text: 'Chưa có bản tin nổi bật.',
                                ),
                              );
                            }

                            final firstSpotlight = highlighted.first;
                            final remain = highlighted.skip(1).toList();

                            return Column(
                              children: [
                                // Spotlight
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: SpotlightNews(
                                    news: firstSpotlight,
                                    onTap: () => _openDetail(firstSpotlight),
                                  ),
                                ),
                                SizedBox(height: 1.6.h),

                                
                                if (remain.isNotEmpty) ...[
                                  HighlightStack(highlighted: remain),
                                  SizedBox(height: 1.6.h),
                                ],

                                // Danh sách TẤT CẢ tin
                                // Padding(
                                //   padding:
                                //       EdgeInsets.symmetric(horizontal: 4.w),
                                //   child: Column(
                                //     children: allNews.map((n) {
                                //       return ExperienceNewsCard(
                                //         news: n,
                                //         onTap: () => _openDetail(n),
                                //       );
                                //     }).toList(),
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: kDefaultPadding * 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const RotatingSurpriseButton(),
            
          ],
        ),
      ),
    );
  }

  void _openDetail(NewsModel n) {
    Navigator.pushNamed(
      context,
      ExperienceDetailScreen.routeName,
      arguments: n,
    );
  }
}



class _EmptyInfo extends StatelessWidget {
  final String text;
  const _EmptyInfo({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}








