import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/discount_tag.dart';


class TourCard extends StatelessWidget {
  final TourModel tour;
  final String image;
  final TourGuideModel? guide;
  final VoidCallback? onTap;
  final bool isDiscount;
  final double headerAspectRatio; 
  final VoidCallback? onFavorite;
  final bool isFavorited;

  const TourCard({
    super.key,
    required this.tour,
    required this.image,
    this.guide,
    this.onTap,
    this.isDiscount = false,
    this.headerAspectRatio = 16 / 10,
    this.onFavorite,
    this.isFavorited = false,
  });

  String _money(num? v) {
    if (v == null) return '--';
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[s.length - 1 - i]);
      if (i % 3 == 2 && i != s.length - 1) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = isDiscount || (tour.isDiscount ?? false);
    final typeText = tour.tourTypeText ?? '';
    final daysText = tour.totalDaysText ?? (tour.totalDays != null ? '${tour.totalDays} ngày' : '');
    final isAsset = image.startsWith('assets/');

    return Semantics(
      button: true,
      label: tour.name ?? 'Tour không tên',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final padX = min(16.0, w * 0.06);
          const padY = 12.0;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: _cardDecoration(theme),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: headerAspectRatio,
                            child: isAsset
                                ? Image.asset(image, fit: BoxFit.cover)
                                : Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                                    loadingBuilder: (ctx, child, prog) {
                                      if (prog == null) return child;
                                      return Container(
                                        alignment: Alignment.center,
                                        color: Colors.grey.shade200,
                                        child: const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      );
                                    },
                                  ),
                          ),

               
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.20),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.55),
                                  ],
                                  stops: const [0.0, 0.45, 1.0],
                                ),
                              ),
                            ),
                          ),

                          if (hasDiscount)
                            const Positioned(top: 10, left: 10, child: DiscountTag()),

                      
                          if (typeText.isNotEmpty || daysText.isNotEmpty)
                            Positioned(
                              top: 10,
                              left: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        if (typeText.isNotEmpty) _pill(typeText, Icons.category_outlined),
                                        // if (daysText.isNotEmpty) _pill(daysText, Icons.calendar_month_rounded),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Favorite button (top-left)
                          if (onFavorite != null)
                            Positioned(
                              top: 10,
                              left: hasDiscount ? 86 : 10, // avoid DiscountTag
                              child: _favoriteBtn(context),
                            ),

                          // Glass info bar: title + rating
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: _Glass(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tour.name ?? 'Tour không tên',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w800,
                                        height: 1.15,
                                        letterSpacing: 0.1,
                                        shadows: const [
                                          Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black54)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        _stars(tour.averageRating, tour.totalReviews),
                                        const Spacer(),
                                        if ((tour.tourGuide?.userName ?? guide?.userName ?? '').isNotEmpty)
                                          Flexible(
                                            child: Text(
                                              tour.tourGuide?.userName ?? guide!.userName!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                color: Colors.white.withOpacity(0.95),
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9.5.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ===== Body
                      Padding(
                        padding: EdgeInsets.fromLTRB(padX, padY, padX, padY + 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Price block
                            if ((tour.adultPrice ?? 0) > 0)
                              _priceLine(
                                context,
                                label: 'Người lớn',
                                value: _money(tour.adultPrice),
                                isEmphasized: true,
                              ),
                            if ((tour.childrenPrice ?? 0) > 0) ...[
                              const SizedBox(height: 6),
                              _priceLine(
                                context,
                                label: 'Trẻ em',
                                value: _money(tour.childrenPrice),
                              ),
                            ],

                            // Subtle divider
                            const SizedBox(height: 10),
                            Container(height: 1, color: Colors.black.withOpacity(0.05)),

                            // Meta row: duration + type (as plain chips below)
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (daysText.isNotEmpty) _metaChip(Icons.schedule_rounded, daysText),
                                if (typeText.isNotEmpty) _metaChip(Icons.map_rounded, typeText),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _cardDecoration(ThemeData theme) {
    final base = theme.colorScheme.surface;
    return BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black.withOpacity(0.05)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 6)),
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 1)),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          base,
          Color.lerp(base, Colors.white, 0.06)!,
        ],
      ),
    );
  }

  Widget _favoriteBtn(BuildContext context) {
    return _Glass(
      radius: 22,
      child: InkWell(
        onTap: onFavorite,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18,
            color: isFavorited ? Colors.redAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, IconData icon) {
    return _Glass(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              text,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceLine(BuildContext context, {required String label, required String value, bool isEmphasized = false}) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(color: Colors.black54, fontWeight: FontWeight.w600);
    final valueStyle = (isEmphasized ? theme.textTheme.titleLarge : theme.textTheme.titleMedium)?.copyWith(
      fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w700,
      color: Colors.black87,
      fontSize: isEmphasized ? 15.sp : 13.5.sp,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$value', style: valueStyle),
        const SizedBox(width: 6),
        Text('/ $label', style: labelStyle),
      ],
    );
  }

  Widget _stars(double? rating, int? totalReviews) {
    final r = ((rating ?? 0).clamp(0, 5)).toDouble();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i + 1 <= r;
          final half = !filled && (i + 0.5) < r;
          return Icon(
            half ? Icons.star_half_rounded : (filled ? Icons.star_rounded : Icons.star_border_rounded),
            size: 16,
            color: Colors.amber.shade500,
          );
        }),
        if ((totalReviews ?? 0) > 0) ...[
          const SizedBox(width: 6),
          Text(
            '${rating?.toStringAsFixed(1) ?? '0.0'} (${totalReviews})',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
              shadows: [Shadow(offset: Offset(0, 1), blurRadius: 1, color: Colors.black45)],
            ),
          ),
        ],
      ],
    );
  }
}

/// Reusable glass container with blur & subtle stroke
class _Glass extends StatelessWidget {
  final Widget child;
  final double radius;
  const _Glass({required this.child, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }
}