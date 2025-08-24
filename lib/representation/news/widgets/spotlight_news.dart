// spotlight_news.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/news_model.dart';

class SpotlightNews extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? onTap;
  const SpotlightNews({super.key, required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    final image   = news.imgUrlFirst;
    final title   = (news.title ?? '').trim();
    final catName = (news.categoryName ?? 'Tin tức').trim();

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.black12),
              ),
              // overlay đậm ở đáy
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
              // badge category
              Positioned(
                top: 1.2.h, left: 3.5.w,
                child: _CategoryBadge(text: catName),
              ),
              // title
              Positioned(
                left: 3.5.w, right: 3.5.w, bottom: 1.6.h,
                child: Text(
                  title,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5.sp,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String text;
  const _CategoryBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .6.h),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11.5.sp,
        ),
      ),
    );
  }
}
