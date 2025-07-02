import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/enums/tour_guide_status_enum.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/model/trip_plan.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/tag_selector.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_price_tag.dart';

class TripConfirmedActionCard extends StatelessWidget {
  final BaseTrip trip;
  final NumberFormat currencyFormat;
  final List<DateTime> days;
  final void Function(BaseTrip updatedTrip)? onUpdated;

  const TripConfirmedActionCard({
    super.key,
    required this.trip,
    required this.currencyFormat,
    required this.days,
    this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final tripDate = DateFormat('dd-MM-yyyy').format(trip.startDate);
    final tripDuration = '${days.length}N${days.length - 1}D';

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
                "Lịch trình đã được xác nhận",
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
          TripPriceTag(
            price: trip.price ?? 6390000,
            currencyFormat: currencyFormat,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.schedule_send, color: Colors.white),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Xác nhận đặt tour"),
                        content: const Text(
                            "Bạn có chắc chắn muốn đặt tour này không?"),
                        actions: [
                          TextButton(
                            child: const Text("Hủy"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            child: const Text("Đồng ý"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      if (trip is TripPlan) {
                        final plan = trip as TripPlan;
                        plan.statusEnum = TripStatus.booked;

                        final callback = onUpdated;
                        if (callback != null) {
                          callback(plan);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Bạn đã đặt tour thành công!"),
                          ),
                        );
                        Navigator.pushReplacementNamed(
                            context, MyTripPlansScreen.routeName);
                      }
                    }
                  },
                  label: Text('ĐẶT TOUR NGAY',
                      style: TextStyle(fontSize: 13.5.sp, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_location_alt_outlined,
                      size: 17, color: Colors.blueAccent),
                  onPressed: () => showCreativeRequestChangeSheet(
                    context,
                    trip,
                    onUpdated,
                  ),
                  label: Text('Yêu cầu điều chỉnh',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    side: const BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showCreativeRequestChangeSheet(
  BuildContext context,
  BaseTrip trip,
  void Function(BaseTrip updatedTrip)? onUpdated,
) {
  final controller = TextEditingController();
  final List<TagOption> quickTags = [
    TagOption("Xuất phát trễ hơn", Icons.access_time_filled),
    TagOption("Xuất phát sớm hơn", Icons.schedule),
    TagOption("Dừng ăn trưa sớm hơn", Icons.lunch_dining),
    TagOption("Đổi thứ tự điểm đến", Icons.swap_vert),
    TagOption("Tăng thời gian nghỉ ngơi", Icons.hotel),
    TagOption("Rút ngắn tham quan", Icons.directions_walk),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
        top: 2.h,
        left: 5.w,
        right: 5.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.horizontal_rule, size: 28, color: Colors.grey[400]),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.map_outlined, color: Colors.orange, size: 20.sp),
                SizedBox(width: 2.w),
                Text("Yêu cầu điều chỉnh hành trình",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 2.h),
            TagSelector(
              tags: quickTags,
              onTagSelected: (value) => controller.text = value,
            ),
            SizedBox(height: 2.5.h),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Nhập nội dung cụ thể",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.wifi_tethering, color: Colors.white),
                onPressed: () {
                  final request = controller.text.trim();
                  Navigator.pop(context);
                  if (request.isNotEmpty) {
                    if (trip.tourGuide != null) {
                      trip.tourGuide!.status = TourGuideStatus.pending;
                    }

                    if (onUpdated != null) {
                      onUpdated(trip);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            "🎒 Yêu cầu đã được gửi đến hướng dẫn viên!"),
                        backgroundColor: Colors.green.shade400,
                      ),
                    );
                  }
                },
                label: Text("GỬI YÊU CẦU",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
