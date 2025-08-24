import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourGuideDetailScreen extends StatefulWidget {
  static const routeName = '/tour-guide-detail';
  final TourGuideModel guide;

  const TourGuideDetailScreen({super.key, required this.guide});

  @override
  State<TourGuideDetailScreen> createState() => _TourGuideDetailScreenState();
}

class _TourGuideDetailScreenState extends State<TourGuideDetailScreen> {
  bool _expandedIntro = false;

  ImageProvider _avatar() {
    final url = widget.guide.avatarUrl;
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return const AssetImage(AssetHelper.avatar);
  }

  String _priceText() {
    final price = widget.guide.price;
    if (price == null) return 'Liên hệ';
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
        .format(price);
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;
    final name = guide.userName ?? 'Hướng dẫn viên';
    final rating = (guide.averageRating ?? 0).clamp(0, 5).toDouble();
    final reviews = guide.totalReviews ?? 0;
    final sexText = guide.sexText;
    final address = guide.address;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: ColorPalette.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 36.h,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsetsDirectional.only(start: 4.w, bottom: 1.h),
              title: innerBoxIsScrolled
                  ? Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh nền
                  Image(image: _avatar(), fit: BoxFit.cover),
                  // gradient phủ dưới ảnh
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.02)),
            PhysicalModel(
              color: const Color(0xFFF6F8FB),
              elevation: 3,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerCard(name, rating, reviews),
                    SizedBox(height: 2.2.h),
                    _quickChips(
                      priceText: '${_priceText()}/ngày',
                      sexText: sexText,
                      address: address,
                    ),
                    SizedBox(height: 2.2.h),
                    _sectionTitle('Giới thiệu'),
                    SizedBox(height: 0.8.h),
                    _introBox(
                      (guide.introduction != null &&
                              guide.introduction!.trim().isNotEmpty)
                          ? guide.introduction!
                          : '''Xin chào bạn đã ghé thăm hồ sơ của tôi.
Tôi luôn sẵn sàng đồng hành để khám phá những góc nhìn thú vị của địa phương.
Chưa có đủ thông tin cá nhân ở đây, nhưng tôi cam kết trải nghiệm an toàn và nhiệt tình.
Hành trình của bạn là ưu tiên của tôi — lắng nghe, linh hoạt và chu đáo.
Hẹn gặp bạn trong chuyến đi sắp tới để tạo nên ký ức đáng nhớ!''',
                    ),
                    SizedBox(height: 2.2.h),
                    _sectionTitle('Kinh nghiệm & Thế mạnh'),
                    SizedBox(height: 0.8.h),
                    _badgeWrap(const [
                      'Am hiểu địa phương',
                      'Nhiệt tình – thân thiện',
                      'Điều phối nhóm tốt',
                      'Chụp hình đẹp',
                      'Lịch trình linh hoạt',
                    ]),
                    SizedBox(height: 2.2.h),
                    _sectionTitle('Hình ảnh'),
                    SizedBox(height: 0.8.h),
                    _miniGallery(_avatar()),
                    SizedBox(height: 2.2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard(String name, double rating, int reviews) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF22D3EE)],
              ),
            ),
            padding: const EdgeInsets.all(2.2),
            child: CircleAvatar(
              radius: 6.6.h,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 6.2.h,
                backgroundImage: _avatar(),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Row(
                  children: [
                    _StarRow(rating: rating),
                    SizedBox(width: 1.2.w),
                    Text(
                      '${rating.toStringAsFixed(1)} (${NumberFormat('#,###').format(reviews)})',
                      style:
                          TextStyle(fontSize: 11.5.sp, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: Gradients.defaultGradientBackground,
                    boxShadow: [
                      BoxShadow(
                        color: ColorPalette.primaryColor.withOpacity(0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Text(
                    '${_priceText()} / ngày',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickChips({
    required String priceText,
    String? sexText,
    String? address,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chip(
            icon: Icons.attach_money_rounded,
            label: priceText,
            tone: ChipTone.primary),
        if (sexText != null && sexText.isNotEmpty)
          _chip(icon: Icons.wc_rounded, label: sexText, tone: ChipTone.neutral),
        if (address != null && address.isNotEmpty)
          _chip(
              icon: Icons.location_on_outlined,
              label: address,
              tone: ChipTone.neutral),
      ],
    );
  }

  Widget _introBox(String intro) {
    final maxLines = _expandedIntro ? null : 4;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            intro,
            maxLines: maxLines,
            overflow:
                _expandedIntro ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 13.5.sp, height: 1.5, color: Colors.grey.shade800),
          ),
          SizedBox(height: 0.6.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _expandedIntro = !_expandedIntro),
              child: Text(
                _expandedIntro ? 'Thu gọn' : 'Đọc thêm',
                style:
                    TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniGallery(ImageProvider first) {
    final images = [
      first,
      const AssetImage(AssetHelper.img_nui_ba_den_1),
      const AssetImage(AssetHelper.img_bo_ke_01),
      const AssetImage(AssetHelper.img_dien_son_01),
    ];
    return SizedBox(
      height: 13.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 3.w),
        itemBuilder: (context, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image(image: images[i], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 18,
          decoration: BoxDecoration(
            color: ColorPalette.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _badgeWrap(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: const Color(0xFF374151).withOpacity(0.12)),
              ),
              child: Text(
                e,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    ChipTone tone = ChipTone.primary,
  }) {
    final bg = tone == ChipTone.primary
        ? const Color(0xFFEFF6FF)
        : const Color(0xFFF3F4F6);
    final fg = tone == ChipTone.primary
        ? const Color(0xFF2563EB)
        : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                fontSize: 12.5.sp, color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    final stars = <Widget>[];
    for (int i = 1; i <= 5; i++) {
      final fill = rating + 0.001 - i;
      final icon = fill >= 0
          ? Icons.star_rounded
          : (fill > -1 ? Icons.star_half_rounded : Icons.star_border_rounded);
      stars.add(const SizedBox(width: 2));
      stars.add(Icon(icon, size: 18, color: const Color(0xFFFFB200)));
    }
    return Row(children: stars.skip(1).toList());
  }
}

enum ChipTone { primary, neutral }
