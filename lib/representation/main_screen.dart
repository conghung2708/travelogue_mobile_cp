import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/core/blocs/main/main_state.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/login_redirect_helper.dart';
import 'package:travelogue_mobile/representation/home/screens/home_screen.dart';
import 'package:travelogue_mobile/representation/event/screens/event_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const TourGuideScreen(),
    const TourScreen(),
    const EventScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        int _currentIndex = state.props[0] as int;

        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) async {
              if (index == 4) {
                final isLoggedIn = await LoginRedirectHelper.requireLogin(
                  context: context,
                  redirectTabIndex: index,
                );
                if (!isLoggedIn) {
                  return;
                }
              }

              AppBloc.mainBloc.add(OnChangeIndexEvent(indexChange: index));
            },
            selectedItemColor: ColorPalette.primaryColor,
            unselectedItemColor: ColorPalette.primaryColor.withOpacity(0.2),
            items: [
              _buildNavItem(FontAwesomeIcons.house, "Trang chủ"),
              _buildNavItem(FontAwesomeIcons.peopleRoof, "HDV"),
              _buildNavItem(FontAwesomeIcons.squarePen, "Tour"),
              _buildNavItem(FontAwesomeIcons.solidCalendarDays, "Thông tin"),
              _buildNavItem(FontAwesomeIcons.solidUser, "Cài đặt"),
            ],
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _buildNavItem(IconData icon, String title) {
    return SalomonBottomBarItem(
      icon: Icon(icon, size: 20),
      title: Text(title),
    );
  }
}
