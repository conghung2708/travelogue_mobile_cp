import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_overview_header.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/timeline_card_item.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/tour_guide_profile_card.dart';
import 'package:travelogue_mobile/core/repository/booking_repository.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';

class TripDetailContent extends StatefulWidget {
  final TripPlanDetailModel trip;
  final NumberFormat currencyFormat;

  const TripDetailContent({
    super.key,
    required this.trip,
    required this.currencyFormat,
  });

  @override
  State<TripDetailContent> createState() => _TripDetailContentState();
}

class _TripDetailContentState extends State<TripDetailContent> {
  TourGuideModel? tourGuide;

  final String _travelogueNoticeMarkdown = """
### 📌 **Lưu ý khi tham gia tour khám phá Tây Ninh cùng Travelogue**
- Chuẩn bị trang phục phù hợp với thời tiết
- Mang theo giấy tờ tuỳ thân khi tham gia các hoạt động yêu cầu
- Giữ gìn vệ sinh và bảo vệ môi trường
- Luôn giữ liên lạc với trưởng đoàn trong suốt chuyến đi
""";

  @override
  void initState() {
    super.initState();
    _loadTourGuideFromBooking();
  }

  Future<void> _loadTourGuideFromBooking() async {
    final tripPlanId = widget.trip.id;
    final bookingRepo = BookingRepository();
    final tourGuideRepo = TourGuideRepository();

    final allBookings = await bookingRepo.getAllMyBookings();
    final booking = allBookings.firstWhereOrNull(
      (b) => b.tripPlanId == tripPlanId && b.tourGuideId != null,
    );
    if (booking != null) {
      final guide = await tourGuideRepo.getTourGuideById(booking.tourGuideId!);
      if (guide != null && mounted) {
        setState(() {
          tourGuide = guide;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripOverviewHeader(trip: widget.trip),
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black45,
                labelStyle: TextStyle(fontSize: 13.5.sp),
                tabs: const [
                  Tab(text: 'Chi tiết Tour'),
                  Tab(text: 'Lưu ý'),
                  Tab(text: 'Trưởng đoàn'),
                ],
              ),
              SizedBox(
                height: 60.h,
                child: TabBarView(
                  children: [
                    _buildTimeline(),
                    _buildMarkdownNotice(context),
                    _buildTourGuideInfo(),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      itemCount: widget.trip.days.length,
      itemBuilder: (context, index) {
        final day = widget.trip.days[index];
        final allWithoutTime =
            day.activities.every((a) => a.startTime.hour == 0);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          color: Colors.blue.shade50,
          child: ExpansionTile(
            maintainState: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ngày ${day.dayNumber}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp)),
                Text(day.dateFormatted,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
              ],
            ),
            children: [
              if (allWithoutTime)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: day.activities
                        .map((a) => TimelineCardItem(item: a))
                        .toList(),
                  ),
                )
              else
                ..._groupByTimeLabel(day.activities).entries.map((entry) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontFamily: "Pattaya")),
                        ...entry.value
                            .map((a) => TimelineCardItem(item: a))
                            .toList(),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarkdownNotice(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(3.w),
      child: MarkdownBody(
        data: _travelogueNoticeMarkdown,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: TextStyle(fontSize: 14.sp),
          h2: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          h3: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent),
          listBullet: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget _buildTourGuideInfo() {
    if (tourGuide != null) {
      return TourGuideProfileCard(guide: tourGuide!);
    } else {
      return Padding(
        padding: EdgeInsets.all(4.w),
        child: Text(
          '⚠️ Không tìm thấy trưởng đoàn cho chuyến đi này.',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
        ),
      );
    }
  }

  Map<String, List<dynamic>> _groupByTimeLabel(List<dynamic> items) {
    items.sort((a, b) => a.startTime.compareTo(b.startTime));
    final Map<String, List<dynamic>> grouped = {};
    for (var item in items) {
      final label = _getTimeLabel(item.startTime);
      grouped.putIfAbsent(label, () => []).add(item);
    }
    return grouped;
  }

  String _getTimeLabel(DateTime time) {
    final hour = time.hour;
    if (hour < 11) {
      return '🌅 Buổi sáng';
    }
    if (hour < 13) {
      return '🌞 Buổi trưa';
    }
    if (hour < 18) {
      return '🌇 Buổi chiều';
    }
    return '🌃 Buổi tối';
  }
}
