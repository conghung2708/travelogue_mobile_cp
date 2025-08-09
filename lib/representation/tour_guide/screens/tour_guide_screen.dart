import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_event.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/auth_helper.dart';
import 'package:travelogue_mobile/core/helpers/string_helper.dart';

import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_booking_confirmation_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/tour_guide_card.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/filter_guide_sheet.dart';

class TourGuideScreen extends StatefulWidget {
  const TourGuideScreen({super.key});
  static const String routeName = '/tour-guides';

  @override
  State<TourGuideScreen> createState() => _TourGuideScreenState();
}

class _TourGuideScreenState extends State<TourGuideScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (_) => FilterGuideSheet(
        onApplyFilter: (TourGuideFilterModel filter) {
          context.read<TourGuideBloc>().add(FilterTourGuideEvent(filter));
        },
      ),
    );
  }

  Future<Map<String, int>?> _pickPeopleCount() async {
    final ValueNotifier<int> adults = ValueNotifier<int>(1);
    final ValueNotifier<int> children = ValueNotifier<int>(0);

    return showDialog<Map<String, int>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chọn số lượng người',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                _buildStyledCounter('Người lớn', adults),
                SizedBox(height: 2.h),
                _buildStyledCounter('Trẻ em', children),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Huỷ',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'adults': adults.value,
                          'children': children.value,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.2.h),
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyledCounter(String label, ValueNotifier<int> counter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
        Row(
          children: [
            _circleIconButton(Icons.remove, () {
              if (label == 'Người lớn') {
                if (counter.value > 1) counter.value--;
              } else {
                if (counter.value > 0) counter.value--;
              }
            }),
            SizedBox(width: 3.w),
            ValueListenableBuilder<int>(
              valueListenable: counter,
              builder: (_, value, __) => Text(
                '$value',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(width: 3.w),
            _circleIconButton(Icons.add, () => counter.value++),
          ],
        ),
      ],
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Future<void> _pickPeopleAndDateThenContinue(TourGuideModel guide) async {
    final people = await _pickPeopleCount();
    if (people != null) {
      final now = DateTime.now();
      final picked = await showDateRangePicker(
        context: context,
        firstDate: now,
        lastDate: DateTime(now.year + 2),
        locale: const Locale('vi', 'VN'),
      );

      if (picked != null) {
        Navigator.pushNamed(
          context,
          GuideBookingConfirmationScreen.routeName,
          arguments: {
            'guide': guide,
            'startDate': picked.start,
            'endDate': picked.end,
            'adults': people['adults'],
            'children': people['children'],
          },
        );
      }
    }
  }

  void _confirmBooking(TourGuideModel guide) {
    if (!isLoggedIn()) {
      Navigator.pushNamed(
        context,
        LoginScreen.routeName,
        arguments: {'redirectRoute': TourGuideScreen.routeName},
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        titlePadding: EdgeInsets.only(top: 3.h, left: 5.w, right: 5.w),
        actionsPadding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w),
        title: Center(
          child: Text(
            "Xác nhận đặt hướng dẫn viên",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 7.h,
              backgroundColor: Colors.grey[200],
              backgroundImage: guide.avatarUrl != null &&
                      guide.avatarUrl!.isNotEmpty
                  ? NetworkImage(guide.avatarUrl!)
                  : const AssetImage(AssetHelper.img_default) as ImageProvider,
            ),
            SizedBox(height: 2.h),
            Text(
              "Bạn chắc chắn muốn đặt\n${guide.userName ?? 'người này'} làm hướng dẫn viên?",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: Gradients.defaultGradientBackground,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: ColorPalette.primaryColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _pickPeopleAndDateThenContinue(guide);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.4.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                "Đặt Ngay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Huỷ bỏ",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 2.h,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header chào user (không hard-code, không có booking folder)
              BlocBuilder<AuthenicateBloc, AuthenicateState>(
                builder: (context, authState) {
                  final String rawName = (authState.props.isNotEmpty
                      ? authState.props[0] as String
                      : '');
                  final String displayName = rawName.isEmpty
                      ? 'Bạn'
                      : (StringHelper().formatUserName(rawName) ?? 'Bạn');

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: const AssetImage(AssetHelper.avatar),
                        radius: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Xin chào, $displayName",
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Pattaya",
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Chọn hướng dẫn viên đồng hành cùng bạn",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 3.h),

             
              Stack(
                children: [
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      image: const DecorationImage(
                        image: AssetImage(AssetHelper.img_nui_ba_den_1),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5.w,
                    bottom: 3.h,
                    right: 5.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "“Mỗi cuộc hành trình là một trang ký ức”",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                        Text(
                          "Hãy chọn người đồng hành phù hợp với bạn!",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 2.h),

              const TitleWithCustoneUnderline(
                text: "Các hướng dẫn ",
                text2: "viên",
              ),

              SizedBox(height: 2.h),

          
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: _openFilterSheet,
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_outlined,
                              color: ColorPalette.primaryColor, size: 18.sp),
                          SizedBox(width: 1.w),
                          Text(
                            'Bộ lọc',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

          
              Expanded(
                child: BlocBuilder<TourGuideBloc, TourGuideState>(
                  builder: (context, state) {
                    if (state is TourGuideLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TourGuideLoaded) {
                      final guides = state.guides;
                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 4.w,
                        itemCount: guides.length,
                        itemBuilder: (context, index) {
                          final guide = guides[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: TourGuideCard(
                              guide: guide,
                              onBookNow: () => _confirmBooking(guide),
                            ),
                          );
                        },
                      );
                    }

                    if (state is TourGuideError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
