import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/tour/tour_test_model.dart';

class TourConfirmedActionCard extends StatelessWidget {
  final TourTestModel tour;
  final NumberFormat currencyFormat;
  final List<DateTime>? days; // Có thể null
  final double price;
  final void Function()? onConfirmed;

  const TourConfirmedActionCard({
    super.key,
    required this.tour,
    required this.currencyFormat,
    this.days,
    required this.price,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final tripDate = "Chưa chọn ngày";

    final tripDuration = (days != null && days!.isNotEmpty)
        ? '${days!.length}N${days!.length - 1}D'
        : 'Chưa rõ';

    final formattedPrice = currencyFormat.format(price);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.25),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 18.sp),
              SizedBox(width: 2.w),
              Text(
                "Tour đã sẵn sàng để đặt",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Icon(Icons.event_note, size: 14.sp, color: Colors.blueGrey),
              SizedBox(width: 1.w),
              Text(
                '$tripDuration  |  Khởi hành: $tripDate',
                style: TextStyle(fontSize: 13.sp, color: Colors.blueGrey),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          Text(
            "💵 Giá tour: $formattedPrice",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.schedule_send, color: Colors.white),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Dialog(
                    elevation: 10,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(3.w),
                            child: Icon(
                              Icons.rocket_launch_rounded,
                              size: 28.sp,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Đặt tour ngay bây giờ?",
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            "Tour của bạn đã sẵn sàng. Xác nhận để chọn ngày và đặt lịch trình.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3.5.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.2.h),
                                    child: Text(
                                      "Để sau",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.2.h),
                                    child: Text(
                                      "Xác nhận",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                if (confirmed == true && onConfirmed != null) {
                  onConfirmed!();
                }
              },
              label: Text(
                'ĐẶT TOUR NGAY',
                style: TextStyle(fontSize: 13.5.sp, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
