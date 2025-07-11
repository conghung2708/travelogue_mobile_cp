import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';

class TourConfirmedActionCard extends StatelessWidget {
  final TourTestModel tour;
  final NumberFormat currencyFormat;
  final DateTime? departureDate;
  final double price;
  final void Function()? onConfirmed;
  final bool? readOnly;
  final bool? isBooked;

  const TourConfirmedActionCard({
    super.key,
    required this.tour,
    required this.currencyFormat,
    required this.price,
    this.departureDate,
    this.onConfirmed,
    this.readOnly = false,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    final tripDate = (departureDate != null)
        ? DateFormat('dd/MM/yyyy').format(departureDate!)
        : 'Chưa chọn ngày';
    final formattedPrice = currencyFormat.format(price);

    final bool isViewingOnly = readOnly == true;
    final bool hasBeenBooked = isBooked == true;

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
                hasBeenBooked
                    ? "Tour đã được đặt"
                    : "Tour đã sẵn sàng để đặt",
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
                'Khởi hành: $tripDate',
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

          // Nút đặt tour (nếu chưa booked và không readonly)
          if (!isViewingOnly && !hasBeenBooked)
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
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 5.w),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.2.h),
                                      child: Text(
                                        "Để sau",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[700],
                                        ),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.2.h),
                                      child: Text(
                                        "Xác nhận",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
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
            )

          // Khi đã booked hoặc readonly
          else
            Container(
              margin: EdgeInsets.only(top: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF4FAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF91C9F7), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasBeenBooked
                        ? '✅ Tour của bạn đã được đặt thành công!'
                        : '🌏 Hành trình của bạn đang chờ đợi!',
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2979FF),
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    hasBeenBooked
                        ? 'Chúng tôi đã ghi nhận lịch trình của bạn. Hẹn gặp bạn trong hành trình sắp tới!'
                        : 'Chỉ một bước nữa, Travelogue hân hạnh đồng hành cùng bạn trên hành trình đầy cảm xúc và khám phá.',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: Colors.blueGrey.shade800,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    hasBeenBooked
                        ? '🎉 Cảm ơn bạn đã chọn Travelogue!'
                        : '📌 Từ khung cảnh mê hồn đến ẩm thực đặc sắc – mọi trải nghiệm đáng nhớ đang chờ đón bạn.',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: Colors.blueGrey.shade800,
                      height: 1.4,
                    ),
                  ),
                  if (!hasBeenBooked)
                    SizedBox(height: 2.h),
                  if (!hasBeenBooked)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: Gradients.defaultGradientBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          label: Text(
                            "Quay lại đặt tour ngay",
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
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
}
