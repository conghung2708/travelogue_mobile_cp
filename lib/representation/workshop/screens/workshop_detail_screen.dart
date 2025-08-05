import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_event.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_state.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';

import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_activity_timeline.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_intro_tab.dart';
import 'package:travelogue_mobile/representation/workshop/widgets/workshop_schedule_tab.dart';

class WorkshopDetailScreen extends StatefulWidget {
  static const String routeName = '/workshop_detail';
  final String workshopId;
  final String? selectedScheduleId;
  final bool readOnly;

  const WorkshopDetailScreen({
    super.key,
    required this.workshopId,
    this.selectedScheduleId,
    this.readOnly = false,
  });

  @override
  State<WorkshopDetailScreen> createState() => _WorkshopDetailScreenState();
}

class _WorkshopDetailScreenState extends State<WorkshopDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabCtl;

  @override
  void initState() {
    super.initState();
    _tabCtl = TabController(length: 3, vsync: this);

    context
        .read<WorkshopBloc>()
        .add(GetWorkshopDetailEvent(workshopId: widget.workshopId));
  }

  @override
  void dispose() {
    _tabCtl.dispose();
    super.dispose();
  }

  List<String> _splitTitle(String name) {
    final words = name.split(' ');
    if (words.length <= 1) return [name, ''];
    final mid = (words.length / 2).ceil();
    return [words.sublist(0, mid).join(' '), words.sublist(mid).join(' ')];
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    }
    return Image.asset(AssetHelper.img_default, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<WorkshopBloc, WorkshopState>(
        builder: (context, state) {
          if (state is WorkshopLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkshopDetailLoaded) {
            final workshop = state.workshop;
            final parts = _splitTitle(workshop.name ?? '');

            return Stack(
              children: [
                Positioned.fill(
                  child: (workshop.schedules.isNotEmpty)
                      ? _buildImage(workshop.schedules.first.imageUrl)
                      : Image.asset(AssetHelper.img_default, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(.35),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Nút Back
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
                        child:
                            Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
                      ),
                    ),
                  ),
                ),
                // Nội dung chi tiết
                _buildDetailContent(workshop, parts),
              ],
            );
          } else if (state is WorkshopError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetailContent(WorkshopDetailModel workshop, List<String> parts) {
    return DraggableScrollableSheet(
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
                  Container(
                    width: 12.w,
                    height: .6.h,
                    margin: EdgeInsets.only(top: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Tiêu đề
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: TitleWithCustoneUnderline(
                      text: '${parts[0]} ',
                      text2: parts[1],
                    ),
                  ),
                  // TabBar
                  TabBar(
                    controller: _tabCtl,
                    indicatorColor: Colors.transparent,
                    labelColor: ColorPalette.primaryColor,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    tabs: const [
                      Tab(text: 'Giới thiệu'),
                      Tab(text: 'Lịch'),
                      Tab(text: 'Hoạt động'),
                    ],
                  ),
                ],
              ),
            ),
            // Tab nội dung
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabCtl,
                physics: const ClampingScrollPhysics(),
                children: [
                  // Giới thiệu
                  WorkshopIntroTab(workshop: workshop),
                  // Lịch
                  WorkshopScheduleTab(
                    workshop: workshop,
                    workshopName: workshop.name ?? '',
                    schedules: widget.selectedScheduleId != null
                        ? workshop.schedules
                            .where((s) =>
                                s.scheduleId == widget.selectedScheduleId)
                            .toList()
                        : workshop.schedules,
                    readOnly: widget.readOnly,
                  ),
                  // Hoạt động
                  WorkshopActivityTimeline(workshop.days),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
