// lib/representation/tour/widgets/tour_team_summary_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourTeamSummaryCard extends StatelessWidget {
  final TourModel tour;
  final TourScheduleModel schedule;
  final String mediaUrl;
  final NumberFormat formatter;

  const TourTeamSummaryCard({
    super.key,
    required this.tour,
    required this.schedule,
    required this.mediaUrl,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final adult      = schedule.adultPrice    ?? tour.adultPrice    ?? 0;
    final child      = schedule.childrenPrice ?? tour.childrenPrice ?? 0;
    final hasChild   = child > 0;
    final finalPrice = tour.finalPrice ?? adult;
    final isDiscount = (tour.isDiscount ?? false) || (finalPrice > 0 && finalPrice < adult);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.6.h),
          padding: EdgeInsets.all(3.6.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Ảnh + badge giảm giá
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 24.w,
                  height: 11.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      mediaUrl.startsWith('http')
                          ? Image.network(mediaUrl, fit: BoxFit.cover)
                          : Image.asset(mediaUrl, fit: BoxFit.cover),

                      if (isDiscount)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFF4D4D), Color(0xFFFF8A00)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.local_fire_department_rounded,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  '-${_discountPercent(original: adult, finalPrice: finalPrice)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                     
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [Colors.black.withOpacity(0.06), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.6.w),

              // Thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quốc gia
                    Text('🌍 Việt Nam',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700)),
                    SizedBox(height: 0.6.h),

                    // Tiêu đề
                    Text(
                      tour.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 0.4.h),

                    // Ngày khởi hành
                    Row(
                      children: [
                        const Icon(Icons.event, size: 16, color: Colors.black45),
                        SizedBox(width: 1.2.w),
                        Text(
                          DateFormat('dd/MM/yyyy').format(schedule.startTime ?? DateTime.now()),
                          style: TextStyle(fontSize: 11.5.sp, color: Colors.black54),
                        ),
                      ],
                    ),

                    SizedBox(height: 0.8.h),

                    // Khối ưu đãi
                    if (isDiscount)
                      _DiscountBlock(
                        original: adult,
                        finalPrice: finalPrice,
                        textPriceFinal: '${formatter.format(finalPrice)}đ',
                        textPriceOrig:  '${formatter.format(adult)}đ',
                      ),

                    if (isDiscount) SizedBox(height: 0.8.h),

                    // Giá người lớn / trẻ em
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 0.8.h,
                      children: [
                        _PriceTag(
                          icon: Icons.attach_money_rounded,
                          color: ColorPalette.primaryColor,
                          label: 'Người lớn',
                          priceText: adult > 0 ? '${formatter.format(adult)}đ' : '—',
                        ),
                        if (hasChild)
                          _PriceTag(
                            icon: Icons.child_care_outlined,
                            color: Colors.orange,
                            label: 'Trẻ em',
                            priceText: child > 0 ? '${formatter.format(child)}đ' : '—',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========= Sub widgets ========= */

class _DiscountBlock extends StatelessWidget {
  final double original;
  final double finalPrice;
  final String textPriceFinal;
  final String textPriceOrig;

  const _DiscountBlock({
    required this.original,
    required this.finalPrice,
    required this.textPriceFinal,
    required this.textPriceOrig,
  });

  @override
  Widget build(BuildContext context) {
    final percent = _discountPercent(original: original, finalPrice: finalPrice);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // chip % giảm
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    size: 14, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(
                  '-$percent%',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Giá
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    textPriceFinal,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    textPriceOrig,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Ưu đãi cho lịch khởi hành này',
                style: TextStyle(fontSize: 11.sp, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String priceText;

  const _PriceTag({
    required this.icon,
    required this.color,
    required this.label,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 1.2.w),
          Text(
            '$label: $priceText',
            style: TextStyle(
              color: color,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

int _discountPercent({required double original, required double finalPrice}) {
  if (original <= 0 || finalPrice <= 0 || finalPrice >= original) return 0;
  final p = ((1 - finalPrice / original) * 100).round();
  return p.clamp(0, 90);
}
