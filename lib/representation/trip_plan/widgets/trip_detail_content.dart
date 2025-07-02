import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

import 'package:travelogue_mobile/representation/trip_plan/widgets/tour_guide_profile_card.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_overview_header.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/timeline_card_item.dart';

class TripDetailContent extends StatelessWidget {
  final BaseTrip trip;
  final List<DateTime> days;
  final NumberFormat currencyFormat;
  final List locations;
  final List cuisines;
  final List villages;
  final TourGuideTestModel? guide;
  final void Function(BaseTrip updatedTrip)? onUpdated;

  

  const TripDetailContent({
    super.key,
    required this.trip,
    required this.days,
    required this.currencyFormat,
    required this.locations,
    required this.cuisines,
    required this.villages,
      this.guide,
        this.onUpdated,
  });

  final String _travelogueNoticeMarkdown = """
### 📌 **Lưu ý khi tham gia tour khám phá Tây Ninh cùng Travelogue**

Chào mừng bạn đến với hành trình khám phá mảnh đất Tây Ninh – nơi giao thoa giữa núi non hùng vĩ, văn hóa tâm linh đặc sắc và ẩm thực dân dã khó quên. Để chuyến đi diễn ra thuận lợi, an toàn và trọn vẹn, **Travelogue xin gửi đến bạn một số lưu ý quan trọng sau**:

#### 1. 📄 **Giấy tờ tùy thân**
- Vui lòng mang theo **CMND/CCCD** hoặc **hộ chiếu** bản chính để tiện cho việc check-in khách sạn, các điểm tham quan có yêu cầu.
- Đối với trẻ em, cần mang theo **giấy khai sinh bản sao công chứng** nếu không đi cùng cha mẹ.

#### 2. 🧥 **Trang phục và hành trang**
- Tây Ninh có khí hậu nắng nhiều, ban ngày khá nóng, ban đêm dịu nhẹ. Nên chuẩn bị:
  - Quần áo thoáng mát, hút mồ hôi tốt
  - **Áo khoác nhẹ**, **nón**, **kính mát**, **kem chống nắng**
  - Giày thể thao hoặc sandal mềm để thuận tiện di chuyển và leo núi Bà Đen

#### 3. 💊 **Sức khỏe và thuốc cá nhân**
- Nếu bạn có tiền sử **dị ứng**, **cao huyết áp**, **tim mạch**... vui lòng thông báo với trưởng đoàn trước khi khởi hành.
- Mang theo thuốc cá nhân như: thuốc say xe, thuốc cảm, thuốc đau bụng, dầu gió…

#### 4. 🕰 **Đúng giờ – tôn trọng tập thể**
- Tour hoạt động theo lịch trình cụ thể để đảm bảo trải nghiệm tối đa. Vui lòng **có mặt đúng giờ tại điểm hẹn**.
- Nếu đến trễ quá thời gian cho phép, xe sẽ khởi hành để không ảnh hưởng đến tập thể.

#### 5. 📷 **Bảo quản tài sản và thiết bị**
- Giữ cẩn thận ví tiền, điện thoại, máy ảnh. Không nên mang theo quá nhiều tài sản có giá trị.
- Tại các điểm đông người như chùa Bà Đen, khu vực lễ hội… hãy chú ý đến tư trang.

#### 6. 🔕 **Tôn trọng văn hóa – giữ gìn môi trường**
- Tây Ninh là vùng đất tâm linh, xin **ăn mặc kín đáo**, **không nói lớn**, **không xả rác** tại đền chùa.
- Hãy cùng Travelogue **trở thành du khách văn minh** – lịch sự, thân thiện và tôn trọng bản địa.

---

Chuyến đi không chỉ là hành trình thể chất, mà còn là hành trình tâm hồn.  
**Chúc bạn có một trải nghiệm tuyệt vời, đầy năng lượng và bình an cùng Travelogue!**
""";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripOverviewHeader(
          trip: trip,
          days: days,
          currencyFormat: currencyFormat,
           guideStatus: guide?.status,
            onUpdated: onUpdated, 
        ),
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
      itemCount: days.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final day = days[index];
        final items = [
          ...locations.where((e) => _isSameDay(e.startTime, day)),
          ...cuisines.where((e) => _isSameDay(e.startTime, day)),
          ...villages.where((e) => _isSameDay(e.startTime, day)),
        ];
        items.sort((a, b) => a.startTime.compareTo(b.startTime));

        final timeGroups = <String, List<dynamic>>{};
        for (var item in items) {
          final label = _getTimeLabel(item.startTime);
          timeGroups.putIfAbsent(label, () => []).add(item);
        }

  final allWithoutTime = items.every((item) => item.startTime.hour == 0);

return Card(
  margin: EdgeInsets.symmetric(vertical: 1.h),
  color: Colors.blue.shade50,
  child: ExpansionTile(
    maintainState: true,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ngày ${index + 1}',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp)),
        Text(DateFormat('EEEE, dd MMM yyyy', 'vi').format(day),
            style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
      ],
    ),
    children: [
      if (allWithoutTime)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => TimelineCardItem(item: item)).toList(),
          ),
        )
      else
        ..._groupByTimeLabel(items).entries.map((entry) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                    .map((item) => TimelineCardItem(item: item))
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
    if (trip.tourGuide != null) {
      return TourGuideProfileCard(guide: trip.tourGuide!);
    } else {
      return Padding(
        padding: EdgeInsets.all(4.w),
        child: Text(
          '⚠️ Chưa có trưởng đoàn được chọn cho hành trình này.',
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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
