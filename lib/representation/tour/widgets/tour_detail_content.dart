// lib/representation/tour/widgets/tour_detail_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

// Report Bloc
import 'package:travelogue_mobile/core/blocs/report/report_bloc.dart';
import 'package:travelogue_mobile/core/blocs/report/report_event.dart';
import 'package:travelogue_mobile/core/blocs/report/report_state.dart';
import 'package:travelogue_mobile/model/report/report_review_request.dart';

// UserLocal
import 'package:travelogue_mobile/data/data_local/user_local.dart';

// Tour models & widgets
import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_review_model.dart';
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
  final bool showGuideTab;

  const TourDetailContent({
    super.key,
    required this.tour,
    this.guide,
    this.readOnly,
    this.startTime,
    this.isBooked,
      this.showGuideTab = true, 
  });

  // Lấy userId hiện tại từ UserLocal
  String _currentUserIdSafe() {
    try {
      final u = UserLocal().getUser();
      final id = (u.id ?? '').toString();
      return id.trim();
    } catch (_) {
      return '';
    }
  }

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
    final tabs = <Tab>[
      const Tab(text: 'Chi tiết Tour'),
      const Tab(text: 'Lưu ý'),
      if (showGuideTab) const Tab(text: 'Trưởng đoàn'),
      const Tab(text: 'Đánh giá'),
    ];

    final tabViews = <Widget>[
      _buildDetailTab(context),
      _buildMarkdownNotice(context),
      if (showGuideTab) _buildTourGuideInfo(),
      _buildReviewsTab(),
    ];

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
          length: tabs.length,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black45,
                labelStyle: TextStyle(fontSize: 13.5.sp),
                tabs: tabs,
              ),
              SizedBox(
                height: 60.h,
                child: TabBarView(children: tabViews),
              ),
            ],
          ),
        )
      ],
    );
  }

  /* ====================== Tabs ====================== */

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

  /* ====================== Reviews + Report ====================== */

  Widget _buildReviewsTab() {
    final List<TourReviewModel> reviews =
        (tour.reviews ?? []).cast<TourReviewModel>();
    final avg = tour.averageRating;
    final total = tour.totalReviews ?? reviews.length;
    final myId = _currentUserIdSafe();

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Text('Chưa có đánh giá cho tour này',
              style: TextStyle(fontSize: 12.5.sp)),
        ),
      );
    }

    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đang gửi báo cáo...')),
          );
        } else if (state is ReportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Đã gửi báo cáo.')),
          );
        } else if (state is ReportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        children: [
          // Header rating
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
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text('$total đánh giá',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
              ],
            ),
          ),
          SizedBox(height: 1.5.h),

          // List reviews
          ...reviews.map((r) {
            final reviewId = (r.id ?? '').trim();
            final isMine = (r.userId ?? '').trim() == myId;

            return Card(
              elevation: 0,
              margin: EdgeInsets.only(bottom: 1.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.blueGrey.withOpacity(0.05),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
                leading: CircleAvatar(
                  child: Text(
                    (r.userName?.isNotEmpty == true
                            ? r.userName!.substring(0, 1)
                            : '?')
                        .toUpperCase(),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        r.userName ?? 'Ẩn danh',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (!isMine)
                      Builder(
                        builder: (ctx) => Tooltip(
                          message: 'Báo cáo đánh giá',
                          child: InkWell(
                            onTap: () => _openReportSheet(
                              context: ctx, // ✅ dùng ctx thay cho context
                              reviewId: reviewId,
                              userName: r.userName ?? 'Người dùng',
                            ),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.5.w, vertical: 0.6.h),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.outlined_flag,
                                      size: 14.sp, color: Colors.red[700]),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Báo cáo',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Row(
                      children: List.generate(5, (i) {
                        final rating = (r.rating ?? 0).toInt();
                        final filled = rating > i;
                        return Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
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
      ),
    );
  }

  void _openReportSheet({
    required BuildContext context,
    required String reviewId,
    required String userName,
  }) {
    final controller = TextEditingController();
    final List<String> suggestions = [
      'Spam / Quảng cáo',
      'Ngôn ngữ xúc phạm',
      'Sai sự thật',
      'Nội dung không phù hợp',
    ];
    String? selectedReason;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 2.h,
            top: 2.h,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              final bool canSend = (selectedReason != null) ||
                  (controller.text.trim().isNotEmpty);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 12.w,
                      height: 0.8.h,
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18.sp,
                        backgroundColor: Colors.red.withOpacity(0.08),
                        child: Icon(Icons.outlined_flag,
                            color: Colors.red[700], size: 20.sp),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Báo cáo đánh giá của “$userName”',
                          style: TextStyle(
                            fontSize: 15.sp, // to hơn
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.2.h),

                  // Label chọn lý do
                  Text(
                    'Chọn lý do báo cáo',
                    style: TextStyle(
                      fontSize: 13.sp, // to hơn
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 1.2.h),

                  // Chips gợi ý
                  Wrap(
                    spacing: 2.2.w,
                    runSpacing: 1.2.h,
                    children: suggestions.map((reason) {
                      final isSelected = selectedReason == reason;
                      return ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: 3.5.w, vertical: 0.8.h),
                        label: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 12.5.sp, // to hơn
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected ? Colors.red[800] : Colors.black87,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.red.withOpacity(0.18),
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? Colors.red.withOpacity(0.35)
                                : Colors.grey.withOpacity(0.5),
                            width: 1.2,
                          ),
                        ),
                        onSelected: (_) => setState(() {
                          selectedReason = reason;
                        }),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.2.h),

                  // Label mô tả
                  Text(
                    'Mô tả chi tiết (tùy chọn)',
                    style: TextStyle(
                      fontSize: 13.sp, // to hơn
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0.8.h),

                  // TextField
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(fontSize: 12.5.sp),
                    decoration: InputDecoration(
                      hintText: 'Bạn có thể mô tả thêm...',
                      hintStyle:
                          TextStyle(fontSize: 12.5.sp, color: Colors.black45),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.5.w,
                        vertical: 1.6.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.35)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.red[400]!),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.2.h),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.6.h, horizontal: 3.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          child: Text(
                            'Huỷ',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.send,
                              size: 16.sp,
                              color: canSend ? Colors.white : Colors.white70),
                          onPressed: canSend
                              ? () {
                                  final note = controller.text.trim();
                                  late final String reason;

                                  if (selectedReason != null &&
                                      note.isNotEmpty) {
                                    // GHÉP lý do + mô tả
                                    reason =
                                        'Lý do: ${selectedReason!}. Mô tả: $note';
                                  } else {
                                    // Chỉ có 1 trong 2
                                    reason = (selectedReason ?? note);
                                  }

                                  context.read<ReportBloc>().add(
                                        SubmitReportEvent(
                                          ReportReviewRequest(
                                            reviewId: reviewId,
                                            reason: reason,
                                          ),
                                        ),
                                      );
                                  Navigator.of(ctx).pop();
                                }
                              : null,
                          label: Text(
                            'Gửi báo cáo',
                            style: TextStyle(
                              fontSize: 13.5.sp, // to hơn
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(0, 48)),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 1.6.h, horizontal: 3.w),
                            ),
                            elevation:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return 0;
                              }
                              return 3; // nổi hơn khi enable
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.red[200]; // màu disabled
                              }
                              return Colors.red[700]; // màu nổi bật khi enable
                            }),
                            shadowColor:
                                MaterialStateProperty.all(Colors.red[200]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),
                ],
              );
            },
          ),
        );
      },
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

    if (!hasStart && !hasEnd) return const SizedBox.shrink();

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
              address: startAddress,
            ),
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
              address: endAddress,
            ),
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.3.h),
              Text(
                name,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
              if ((address ?? '').isNotEmpty)
                Text(
                  address!,
                  style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
