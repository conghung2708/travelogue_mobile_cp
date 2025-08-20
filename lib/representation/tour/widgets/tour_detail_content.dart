// lib/representation/tour/widgets/tour_detail_content.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/timeline_card_tour_item.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_guide_profile.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_overview_header.dart';

class TourDetailContent extends StatelessWidget {
  final TourModel tour;
  final TourGuideModel? guide;
  final bool? readOnly;
  final DateTime? startTime;
  final bool? isBooked;

  const TourDetailContent({
    super.key,
    required this.tour,
    this.guide,
    this.readOnly,
    this.startTime,
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
          startTime: startTime,
          isBooked: isBooked,
        ),
        DefaultTabController(
          length: 4, 
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
                  Tab(text: 'Đánh giá'), 
                ],
              ),
              SizedBox(
                height: 60.h,
                child: TabBarView(
                  children: [
                    _buildDetailTab(context), 
                    _buildMarkdownNotice(context),
                    _buildTourGuideInfo(),
                    _buildReviewsTab(), 
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDetailTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          _StartEndStrip(
            startName: tour.startLocation?.name,
            startAddress: tour.startLocation?.address,
            endName: tour.endLocation?.name,
            endAddress: tour.endLocation?.address,
          ),
          SizedBox(height: 1.h),
          _buildTimeline(),
        ],
      ),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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


  Widget _buildReviewsTab() {
    final reviews = tour.reviews ?? [];
    final avg = tour.averageRating;
    final total = tour.totalReviews ?? reviews.length;

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Text('Chưa có đánh giá cho tour này',
              style: TextStyle(fontSize: 12.5.sp)),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      children: [

        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.star_rate_rounded,
                  size: 22.sp, color: Colors.amber[800]),
              SizedBox(width: 2.w),
              Text(
                '${avg?.toStringAsFixed(1) ?? '-'} / 5.0',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text('$total đánh giá',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),

        ...reviews.map((r) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.only(bottom: 1.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.blueGrey.withOpacity(0.05),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
              leading: CircleAvatar(
                child: Text((r.userName?.isNotEmpty == true
                    ? r.userName!.substring(0, 1)
                    : '?')),
              ),
              title: Text(r.userName ?? 'Ẩn danh',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.5.h),
                  Row(
                    children: List.generate(5, (i) {
                      final filled = (r.rating ?? 0) > i;
                      return Icon(
                        filled ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 16.sp,
                        color: Colors.amber[700],
                      );
                    }),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(r.comment ?? ''),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _StartEndStrip extends StatelessWidget {
  final String? startName;
  final String? startAddress;
  final String? endName;
  final String? endAddress;

  const _StartEndStrip({
    required this.startName,
    required this.startAddress,
    required this.endName,
    required this.endAddress,
  });

  @override
  Widget build(BuildContext context) {
    final hasStart = (startName ?? '').isNotEmpty;
    final hasEnd = (endName ?? '').isNotEmpty;

    if (!hasStart && !hasEnd) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (hasStart)
            _LocRow(
                icon: Icons.flag_circle_rounded,
                label: 'Điểm bắt đầu',
                name: startName!,
                address: startAddress),
          if (hasStart && hasEnd)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.6.h),
              child: Divider(height: 0, color: Colors.green.withOpacity(0.2)),
            ),
          if (hasEnd)
            _LocRow(
                icon: Icons.check_circle_rounded,
                label: 'Điểm kết thúc',
                name: endName!,
                address: endAddress),
        ],
      ),
    );
  }
}

class _LocRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String name;
  final String? address;

  const _LocRow({
    required this.icon,
    required this.label,
    required this.name,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700]),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 0.3.h),
              Text(name,
                  style: TextStyle(
                      fontSize: 13.sp, fontWeight: FontWeight.w700)),
              if ((address ?? '').isNotEmpty)
                Text(address!,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
