import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/timeline_card_tour_item.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_guide_profile.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_overview_header.dart';

class TourDetailContent extends StatelessWidget {
  final TourModel tour;
  final TourGuideModel? guide;
  final bool? readOnly;
  final DateTime? departureDate;
  final bool? isBooked;

  const TourDetailContent({
    super.key,
    required this.tour,
    this.guide,
    this.readOnly,
    this.departureDate,
    this.isBooked,
  });

  final String _tourNoteMarkdown = """
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
        TourOverviewHeader(
          tour: tour,
          readOnly: readOnly,
          departureDate: departureDate,
          isBooked: isBooked,
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
  final List<TourDayModel> days = tour.days ?? [];

  return ListView.builder(
    itemCount: days.length,
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      final day = days[index];
      final activities = day.activities ?? [];

      return Card(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          maintainState: true,
          tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          childrenPadding: EdgeInsets.only(bottom: 2.h),
          title: Text(
            'Ngày ${day.dayNumber ?? index + 1}',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          children: activities.map((activity) {
            final imageUrl = activity.imageUrl?.isNotEmpty == true
                ? activity.imageUrl!
                : AssetHelper.img_default;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: TimelineCardTourItem(
                item: activity,
                name: activity.name ?? 'Hoạt động',
                imageUrls: [imageUrl],
                description: activity.description ?? '',
                duration: activity.duration,
                note: activity.notes,
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}


  Widget _buildMarkdownNotice(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(3.w),
      child: MarkdownBody(
        data: _tourNoteMarkdown,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildTourGuideInfo() {
    if (guide != null) {
      return TourGuideProfile(guide: guide!);
    } else {
      return Padding(
        padding: EdgeInsets.all(4.w),
        child: Text(
          '⚠️ Chưa có trưởng đoàn được chọn cho tour này.',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
        ),
      );
    }
  }
}
