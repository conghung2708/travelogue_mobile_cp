import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/representation/user/screens/my_reports_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/core/repository/authenication_repository.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

import 'package:travelogue_mobile/representation/booking/screens/my_booking_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/edit_profile_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/location_favorite_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/privacy_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/support_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tay_ninh_predictor_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/tour_guide_request_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/withdraw_request_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  static const routeName = '/user_profile_screen';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _loading = true;
  String? _error;
  late var _user = UserLocal().getUser();

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  Future<void> _refreshUser() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      final fetched = await AuthenicationRepository().fetchCurrentUser();
      setState(() {
        _user = fetched;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Không lấy được thông tin tài khoản: $e')),
      //   );
      // }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = (_user.userWalletAmount ?? 0).toDouble();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshUser,
        color: const Color(0xFF1565C0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 5.h),
              _buildProfileHeader(context),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: WalletCard(
                  balanceText: _formatVND(wallet),
                  isLoading: _loading,
                  onRefresh: _refreshUser,
                  // ✅ Kiểm tra số dư trước khi cho rút
                  // if (wallet < _minWithdraw) {
                  //   _showMinBalanceDialog(
                  //     context,
                  //     current: wallet,
                  //     requiredAmount: _minWithdraw,
                  //   );
                  //   return;
                  // }
                  onWithdraw: () async {
                    final changed = await Navigator.pushNamed(
                      context,
                      WithdrawRequestScreen.routeName,
                      arguments: WithdrawRequestArgs(balance: wallet),
                    );
                    if (changed == true) {
                        print("Có hoạt động");
                      _refreshUser();
                    }
                  },
                ),
              ),
              SizedBox(height: 2.h),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                  child: Column(
                    children: [
                      if (_error != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFB3B3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 1.h),
                      _buildMenuItem(
                        Icons.receipt_long_outlined,
                        "Quản lý đơn hàng",
                        context: context,
                        onTap: () => _openOrderManager(context),
                      ),
                      _buildMenuItem(
                        Icons.account_balance_wallet_outlined,
                        "Yêu cầu rút tiền",
                        context: context,
                        // if (walletNow < _minWithdraw) {
                        //   _showMinBalanceDialog(
                        //     context,
                        //     current: walletNow,
                        //     requiredAmount: _minWithdraw,
                        //   );
                        //   return;
                        // }
                        onTap: () async {
                          final walletNow =
                              (_user.userWalletAmount ?? 0).toDouble();
                          final changed = await Navigator.pushNamed(
                            context,
                            WithdrawRequestScreen.routeName,
                            arguments: WithdrawRequestArgs(balance: walletNow),
                          );
                          if (changed == true) {
                            print("Có hoạt động");
                            _refreshUser();
                          }
                        },
                      ),
                      _buildMenuItem(
                        Icons.privacy_tip_outlined,
                        "Quyền riêng tư",
                        context: context,
                        onTap: () {
                          Navigator.pushNamed(context, PrivacyScreen.routeName);
                        },
                      ),
                      // _buildMenuItem(
                      //   Icons.badge_outlined,
                      //   "Gia nhập đội ngũ hướng dẫn viên",
                      //   context: context,
                      //   onTap: () {
                      //     Navigator.pushNamed(
                      //         context, TourGuideRequestScreen.routeName);
                      //   },
                      // ),
                      _buildMenuItem(
                        Icons.badge_outlined,
                        "Quản lý báo cáo",
                        context: context,
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyReportsScreen.routeName);
                        },
                      ),
                      _buildMenuItem(
                        Icons.favorite_border,
                        "Địa điểm yêu thích",
                        context: context,
                        onTap: () {
                          Navigator.pushNamed(
                              context, FavoriteLocationScreen.routeName);
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
                      // _buildMenuItem(
                      //   Icons.travel_explore_outlined,
                      //   "Gợi ý điểm đến Tây Ninh",
                      //   context: context,
                      //   onTap: () {
                      //     Navigator.pushNamed(
                      //         context, TayNinhPredictorScreen.routeName);
                      //   },
                      // ),
                      _buildMenuItem(
                        Icons.logout,
                        "Đăng xuất",
                        isLogout: true,
                        context: context,
                        onTap: () {
                          _showLogoutDialog(
                            context,
                            onLogoutSuccess: () {
                              AppBloc.authenicateBloc
                                  .add(LogoutEvent(context: context));
                            },
                          );
                        },
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            context,
                            imagePath: AssetHelper.img_facebook,
                            url: 'https://www.facebook.com/TinhDoanTayNinh',
                          ),
                          SizedBox(width: 4.w),
                          _buildSocialIcon(
                            context,
                            imagePath: AssetHelper.img_youtube,
                            url: 'https://www.youtube.com/@tuoitretayninh4761',
                          ),
                          SizedBox(width: 4.w),
                          _buildSocialIcon(
                            context,
                            imagePath: AssetHelper.img_web,
                            url: 'https://goyoungtayninh.vn/',
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final user = _user;
    final avatarProvider =
        (_user.avatarUrl != null && _user.avatarUrl!.isNotEmpty)
            ? NetworkImage(_user.avatarUrl!)
            : const AssetImage(AssetHelper.img_avatar) as ImageProvider;
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
              child: CircleAvatar(
                radius: 55,
                backgroundImage: avatarProvider,
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () async {
                  final changed = await Navigator.pushNamed(
                      context, EditProfileScreen.routeName);
                  if (changed == true && mounted) {
                    setState(() {
                      _user = UserLocal().getUser();
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4)
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
        SizedBox(height: 1.2.h),
        Text(
          user.fullName ?? user.userName ?? user.username ?? 'Người dùng',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: .6.h),
        Text(
          user.email ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        SizedBox(height: 1.2.h),
        OutlinedButton(
          onPressed: () async {
            final changed =
                await Navigator.pushNamed(context, EditProfileScreen.routeName);
            if (changed == true && mounted) {
              setState(() {
                _user = UserLocal().getUser();
              });
            }
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
    required VoidCallback onTap,
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
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
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

  Future<void> _openOrderManager(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final bookings = await BookingRepository().getAllMyBookings();
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushNamed(
          context,
          MyBookingScreen.routeName,
          arguments: bookings,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tải được đơn hàng: $e')),
        );
      }
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final ok = await launchUrlString(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở liên kết')),
      );
    }
  }

  void _showLogoutDialog(
    BuildContext context, {
    required VoidCallback onLogoutSuccess,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          title: SizedBox(
            height: 160,
            width: double.infinity,
            child: Lottie.asset(
              'assets/animations/sad_face.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                Text(
                  "Rời chuyến đi rồi sao?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Travelogue sẽ nhớ bạn lắm.\nBạn chắc chắn muốn đăng xuất và tạm xa những hành trình khám phá chứ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text("Ở lại",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, size: 18, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                onLogoutSuccess();
              },
              label: const Text("Tạm biệt",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // ✅ Chữ trắng
                  )),
            ),
          ],
        );
      },
    );
  }

  // ---- Dialog: số dư chưa đủ ----
  // void _showMinBalanceDialog(
  //   BuildContext context, {
  //   required num current,
  //   required num requiredAmount,
  // }) {
  //   final primary = const Color(0xFF1565C0);
  //   showDialog(
  //     context: context,
  //     builder: (_) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // header gradient + icon
  //           Container(
  //             height: 120,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [primary.withOpacity(.95), primary],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               borderRadius:
  //                   const BorderRadius.vertical(top: Radius.circular(18)),
  //             ),
  //             child: const Center(
  //               child: CircleAvatar(
  //                 radius: 34,
  //                 backgroundColor: Colors.white,
  //                 child: Icon(Icons.info_rounded,
  //                     size: 34, color: Color(0xFF1565C0)),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
  //             child: Text(
  //               'Số dư chưa đủ để rút',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: primary,
  //                 fontWeight: FontWeight.w800,
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Text(
  //               'Bạn cần tối thiểu ${_formatVND(requiredAmount)} để thực hiện yêu cầu rút tiền.\n'
  //               'Số dư hiện tại: ${_formatVND(current)}.',
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(fontSize: 14),
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     style: OutlinedButton.styleFrom(
  //                       foregroundColor: primary,
  //                       side: BorderSide(color: primary),
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10)),
  //                     ),
  //                     child: const Text(
  //                       'Đã hiểu',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: primary,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10)),
  //                     ),
  //                     child: const Text('Đóng'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String _formatVND(num value) {
    final s = value.toStringAsFixed(0);
    final rev = s.split('').reversed.join();
    final parts = <String>[];
    for (var i = 0; i < rev.length; i += 3) {
      parts.add(rev.substring(i, (i + 3).clamp(0, rev.length)));
    }
    return '${parts.join('.').split('').reversed.join()} đ';
  }
}

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.balanceText,
    required this.onWithdraw,
    required this.onRefresh,
    required this.isLoading,
  });

  final String balanceText;
  final VoidCallback onWithdraw;
  final Future<void> Function() onRefresh;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1565C0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ví của tôi',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  balanceText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: primary.withOpacity(.16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PillIconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 18),
                  onTap: isLoading ? null : () => onRefresh(),
                  tooltip: 'Làm mới',
                ),
                Container(
                  width: 1,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: primary.withOpacity(.15),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6, left: 2),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onWithdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(56, 32),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Rút', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillIconButton extends StatelessWidget {
  const _PillIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final Widget icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      triggerMode: tooltip == null
          ? TooltipTriggerMode.manual
          : TooltipTriggerMode.longPress,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: icon,
        ),
      ),
    );
  }
}
