import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/user/screens/edit_profile_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/location_favorite_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/privacy_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/support_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tay_ninh_predictor_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tour_guide_request_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  static const routeName = '/user_profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildMenuItem(
                      Icons.privacy_tip_outlined,
                      "Quyền riêng tư",
                      context: context,
                      onTap: () {
                        Navigator.pushNamed(context, PrivacyScreen.routeName);
                      },
                    ),
                    _buildMenuItem(
  Icons.badge_outlined,
  "Đăng ký hướng dẫn viên",
  context: context,
  onTap: () {
    Navigator.pushNamed(context, TourGuideRequestScreen.routeName);
  },
),

                    _buildMenuItem(
                      Icons.favorite_border,
                      "Địa điểm yêu thích",
                      context: context,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          FavoriteLocationScreen.routeName,
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.help_outline,
                      "Trợ giúp & Hỗ trợ",
                      context: context,
                      onTap: () {
                        Navigator.pushNamed(context, SupportScreen.routeName);
                      },
                    ),
                    _buildMenuItem(
                      Icons.travel_explore_outlined,
                      "Gợi ý điểm đến Tây Ninh",
                      context: context,
                      onTap: () {
                        Navigator.pushNamed(
                            context, TayNinhPredictorScreen.routeName);
                      },
                    ),

                    // _buildMenuItem(Icons.language, "Ngôn ngữ", context: context),
                    _buildMenuItem(
                      Icons.logout,
                      "Đăng xuất",
                      isLogout: true,
                      context: context,
                      onTap: () {
                        _showLogoutDialog(context, onLogoutSuccess: () {
                          Navigator.of(context).pop();
                          AppBloc.authenicateBloc
                              .add(LogoutEvent(context: context));
                        });
                      },
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                          context,
                          imagePath: AssetHelper.img_facebook,
                          url: 'https://www.facebook.com/TinhDoanTayNinh',
                        ),
                        const SizedBox(width: 16),
                        _buildSocialIcon(
                          context,
                          imagePath: AssetHelper.img_youtube,
                          url: 'https://www.youtube.com/@tuoitretayninh4761',
                        ),
                        const SizedBox(width: 16),
                        _buildSocialIcon(
                          context,
                          imagePath: AssetHelper.img_web,
                          url: 'https://goyoungtayninh.vn/',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    BuildContext context, {
    required String imagePath,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(context, url),
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          width: 27.sp,
          height: 27.sp,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.cyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(AssetHelper.img_avatar),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  // Handle avatar edit
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit,
                      size: 18, color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          UserLocal().getUser().fullName ?? '',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          UserLocal().getUser().email ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, EditProfileScreen.routeName);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            foregroundColor: Colors.white,
          ),
          child: const Text("Chỉnh sửa thông tin"),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    bool isLogout = false,
    required BuildContext context,
    required Function() onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLogout ? Colors.red.shade50 : Colors.blue.shade50,
          child: Icon(icon, color: isLogout ? Colors.red : Colors.blueAccent),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final bool launched = await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở liên kết')),
      );
    }
  }

  void _showLogoutDialog(
    BuildContext context, {
    required Function() onLogoutSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: onLogoutSuccess,
              child: const Text("Có"),
            ),
          ],
        );
      },
    );
  }
}
