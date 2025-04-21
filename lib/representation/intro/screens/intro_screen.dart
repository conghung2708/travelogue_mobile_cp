import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/data/data_local/global_local.dart';

import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/widgets/build_item_intro_screen.dart';
import 'package:travelogue_mobile/representation/widgets/button_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const routeName = 'intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();

  final StreamController<int> _pageStreamController =
      StreamController<int>.broadcast();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _pageStreamController.add(_pageController.page!.toInt());
    });

    GlobalLocal().setCheckOpenApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold luc nao cung nam o ngoai cung
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: const [
                BuildItemIntroScreen(
                    alignmentGeometry: Alignment.center,
                    image: AssetHelper.intro1,
                    title: 'Tham quan Núi Bà Đen',
                    description:
                        'Khám phá đỉnh núi cao nhất miền Nam với cảnh quan tuyệt đẹp và các hoạt động leo núi, cáp treo.'),
                BuildItemIntroScreen(
                  alignmentGeometry: Alignment.center,
                  image: AssetHelper.intro2,
                  title: 'Ma Thiên Lãnh',
                  description:
                      'Khám phá Ma Thiên Lãnh – vùng núi hoang sơ, kỳ bí với cảnh đẹp hùng vĩ và không khí mát mẻ quanh năm.',
                ),
                BuildItemIntroScreen(
                    alignmentGeometry: Alignment.center,
                    image: AssetHelper.intro3,
                    title: 'Hồ Dầu Tiếng',
                    description:
                        'Thưởng thức vẻ đẹp của hồ nước ngọt lớn nhất Tây Ninh, lý tưởng cho các hoạt động dã ngoại và câu cá.'),
              ],
            ),
            Positioned(
              left: MediaQuery.of(context).size.width *
                  0.05, // Responsive padding
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotWidth: MediaQuery.of(context).size.width * 0.02,
                        dotHeight: MediaQuery.of(context).size.width * 0.02,
                        activeDotColor: ColorPalette.primaryColor,
                      ),
                    ),
                  ),
                  StreamBuilder<int>(
                    initialData: 0,
                    stream: _pageStreamController.stream,
                    builder: (context, snapshot) {
                      return Expanded(
                        flex: 4,
                        child: ButtonWidget(
                          title: snapshot.data != 2 ? 'Tiếp theo' : 'Bắt đầu',
                          onTap: () {
                            if (_pageController.page != 2) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(MainScreen.routeName);
                            }
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
