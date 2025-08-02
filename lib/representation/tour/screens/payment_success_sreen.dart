import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/tour_guide_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final bool fromGuide;

  const PaymentSuccessScreen({super.key, this.fromGuide = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Image.asset(
                    AssetHelper.img_payment,
                    height: 28.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '🎉 Thanh toán thành công!',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade600,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    'Cảm ơn bạn đã tin tưởng Travelogue! 💙\nChúng tôi sẽ liên hệ sớm để xác nhận hành trình của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded,
                            color: Colors.green, size: 24),
                        SizedBox(width: 2.w),
                        Text(
                          'Đã xác nhận thanh toán',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (fromGuide) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        TourGuideScreen.routeName,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        TourScreen.routeName,
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Về trang chủ',
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
