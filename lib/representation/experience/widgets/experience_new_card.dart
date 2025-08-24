import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/model/news_model.dart';

class ExperienceNewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? onTap;

  const ExperienceNewsCard({
    super.key,
    required this.news,
    this.onTap,
  });

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'Vừa xong';
    if (d.inMinutes < 60) return '${d.inMinutes} phút trước';
    if (d.inHours < 24) return '${d.inHours} giờ trước';
    if (d.inDays < 7) return '${d.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final title = (news.title ?? '').trim();
    final desc = (news.description ?? '').trim();
    final imageUrl = news.imgUrlFirst;
    final category = ("Trải nghiệm").trim();
    final location = (news.locationName ?? '').trim();
    final created = news.createdTime;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blue.withOpacity(.10),
        highlightColor: Colors.blue.withOpacity(.03),
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h).add(EdgeInsets.symmetric(horizontal: 15.sp)),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12.withOpacity(.06)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Color(0x14000000),
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ẢNH BÊN TRÁI
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    ImageNetworkCard(
                      url: imageUrl,
                      width: 28.w,
                      height: 28.w,
                      fit: BoxFit.cover,
                    ),
                    // overlay rất nhẹ để chữ/viền nhìn “đằm” hơn
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(.20)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.5.w),

              // NỘI DUNG
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: .4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5.sp,
                          height: 1.18,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: .7.h),

                      // Mô tả
                      if (desc.isNotEmpty)
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 12.2.sp,
                            height: 1.35,
                            color: Colors.black.withOpacity(.74),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      SizedBox(height: 1.1.h),

                      // Meta pills
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (category.isNotEmpty)
                            _MetaPill(
                              icon: Icons.label_rounded,
                              text: category,
                              bg: const Color(0xFFEAF2FF),
                              fg: const Color(0xFF1E40AF),
                              border: const Color(0xFFD5E4FF),
                            ),
                          if (location.isNotEmpty)
                            _MetaPill(
                              icon: Icons.place_rounded,
                              text: location,
                              bg: const Color(0xFFEFFAF1),
                              fg: const Color(0xFF166534),
                              border: const Color(0xFFCFEBD6),
                            ),
                          if (created != null)
                            _MetaPill(
                              icon: Icons.schedule_rounded,
                              text: _timeAgo(created),
                              bg: const Color(0xFFF4F4F5),
                              fg: const Color(0xFF374151),
                              border: const Color(0xFFE7E7EA),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Mũi tên nhẹ gợi ý click
              SizedBox(width: 1.w),
              Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  const _MetaPill({
    required this.icon,
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: .55.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: fg),
          SizedBox(width: 1.6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
