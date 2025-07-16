import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_schedule_test_model.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';

class MasonryItem extends StatelessWidget {
  final WorkshopTestModel workshop;
  const MasonryItem({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    final related = workshopSchedules
        .where((s) => s.workshopId == workshop.id && s.isActive)
        .toList();

    final minAdult = related.isEmpty
        ? double.infinity
        : related.map((e) => e.adultPrice).reduce(min);

    final random = Random(workshop.id.hashCode);
    final randomImage =
        workshop.imageList[random.nextInt(workshop.imageList.length)];

    related.sort((a, b) =>
        DateTime.parse(a.startTime).compareTo(DateTime.parse(b.startTime)));
    final nearest = related.isNotEmpty ? related.first : null;
    final dateStr = nearest == null
        ? '--/--/----'
        : DateFormat('dd/MM/yyyy').format(DateTime.parse(nearest.startTime));

    final soldOut = nearest != null &&
        nearest.currentBooked != null &&
        nearest.currentBooked! >= nearest.maxParticipant;
    final remaining = nearest == null
        ? 0
        : nearest.maxParticipant - (nearest.currentBooked ?? 0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        WorkshopDetailScreen.routeName,
        arguments: workshop,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.w),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                color: Colors.black.withOpacity(.08),
                offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.asset(
                  randomImage,
                  width: double.infinity,
                  height: (26 + random.nextInt(12)).w,
                  fit: BoxFit.cover,
                ),
                // Positioned(
                //   top: 1.h,
                //   left: 2.w,
                //   child: _chip(
                //     text: dateStr,
                //     bg: Colors.black54,
                //   ),
                // ),
                Positioned(
                  top: 1.h,
                  right: 2.w,
                  child: _chip(
                    text:
                        minAdult.isFinite ? '${minAdult ~/ 1000}K' : 'Liên hệ',
                    gradient: Gradients.defaultGradientBackground,
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workshop.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.6.h),
                    Text(workshop.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.3,
                            color: Colors.grey[700])),
                    SizedBox(height: 1.2.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.0.h),
                        decoration: BoxDecoration(
                          gradient: soldOut
                              ? null
                              : Gradients.defaultGradientBackground,
                          color: soldOut ? Colors.grey : null,
                          borderRadius: BorderRadius.circular(5.w),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_alt_rounded,
                                size: 14.sp, color: Colors.white),
                            SizedBox(width: 2.w),
                            Text(
                              soldOut ? 'HẾT CHỖ' : 'CÒN $remaining CHỖ',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
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

  Widget _chip(
      {required String text,
      Gradient? gradient,
      Color? bg,
      Color fg = Colors.white}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? bg : null,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 12.sp, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}
