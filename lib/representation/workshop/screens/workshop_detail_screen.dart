// workshop_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_schedule_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_activity_test_model.dart';

import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_activity_timeline.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_bottom_bar.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_intro_tab.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_schedule_tab.dart';

class WorkshopDetailScreen extends StatefulWidget {
  static const String routeName = '/workshop_detail';
  final WorkshopTestModel workshop;
  const WorkshopDetailScreen({super.key, required this.workshop});

  @override
  State<WorkshopDetailScreen> createState() => _WorkshopDetailScreenState();
}

class _WorkshopDetailScreenState extends State<WorkshopDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabCtl;
  late final List<WorkshopScheduleTestModel> schedules;
  late final List<WorkshopActivityTestModel> activities;

  @override
  void initState() {
    super.initState();
    schedules = workshopSchedules
        .where((e) => e.workshopId == widget.workshop.id && e.isActive)
        .toList();
    activities = workshopActivities
        .where((a) => a.workshopId == widget.workshop.id && a.isActive)
        .toList();
    _tabCtl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtl.dispose();
    super.dispose();
  }

  String _priceRange() {
    if (schedules.isEmpty) return 'Liên hệ';
    final minA =
        schedules.map((e) => e.adultPrice).reduce((a, b) => a < b ? a : b);
    final maxA =
        schedules.map((e) => e.adultPrice).reduce((a, b) => a > b ? a : b);
    return minA == maxA
        ? '${minA ~/ 1000}K'
        : '${minA ~/ 1000}K – ${maxA ~/ 1000}K';
  }

  List<String> _splitTitle(String name) {
    final words = name.split(' ');
    if (words.length <= 1) return [name, ''];
    final mid = (words.length / 2).ceil();
    return [words.sublist(0, mid).join(' '), words.sublist(mid).join(' ')];
  }

  @override
  Widget build(BuildContext context) {
    final parts = _splitTitle(widget.workshop.name);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ----- HERO IMAGE -----
          Positioned.fill(
            child: widget.workshop.imageList.isEmpty
                ? const SizedBox()
                : Image.asset(widget.workshop.imageList.first,
                    fit: BoxFit.cover),
          ),
          // dark gradient top
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(.35), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // back button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.85),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
                ),
              ),
            ),
          ),
          // ----- SHEET -----
          DraggableScrollableSheet(
            initialChildSize: .46,
            minChildSize: .46,
            maxChildSize: .93,
            builder: (_, sc) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: CustomScrollView(
                controller: sc,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // handle
                        Container(
                          width: 12.w,
                          height: .6.h,
                          margin: EdgeInsets.only(top: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // title
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: TitleWithCustoneUnderline(
                            text: '${parts[0]} ',
                            text2: parts[1],
                          ),
                        ),
                        // tab bar
                        TabBar(
                          controller: _tabCtl,
                          indicatorColor: Colors.transparent,
                          labelColor: ColorPalette.primaryColor,
                          unselectedLabelColor: Colors.grey.shade600,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.sp),
                          tabs: const [
                            Tab(text: 'Giới thiệu'),
                            Tab(text: 'Lịch'),
                            Tab(text: 'Hoạt động'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // tab content
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: TabBarView(
                      controller: _tabCtl,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        WorkshopIntroTab(
                          workshop: widget.workshop,
                          village: widget.workshop.craftVillage,
                        ),
                        WorkshopScheduleTab(
                          workshop: widget.workshop,
                          schedules: schedules,
                        ),
                        WorkshopActivityTimeline(activities),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: WorkshopBottomBar(price: _priceRange()),
    );
  }
}
