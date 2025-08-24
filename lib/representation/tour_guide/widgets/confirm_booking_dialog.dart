import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class ConfirmBookingDialog extends StatelessWidget {
  final TourGuideModel guide;
  const ConfirmBookingDialog({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final avatar = (guide.avatarUrl != null && guide.avatarUrl!.isNotEmpty)
        ? NetworkImage(guide.avatarUrl!)
        : const AssetImage(AssetHelper.img_default) as ImageProvider;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      titlePadding: EdgeInsets.only(top: 3.h, left: 5.w, right: 5.w),
      actionsPadding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w),
      title: Center(
        child: Text(
          "Xác nhận đặt hướng dẫn viên",
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
              radius: 7.h,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatar),
          SizedBox(height: 2.h),
          Text(
            "Bạn chắc chắn muốn đặt\n${guide.userName ?? 'người này'} làm hướng dẫn viên?",
            style:
                TextStyle(fontSize: 13.sp, color: Colors.black87, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: Gradients.defaultGradientBackground,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primaryColor.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 1.4.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
            child: Text("Đặt Ngay",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 1.h),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Huỷ bỏ",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
