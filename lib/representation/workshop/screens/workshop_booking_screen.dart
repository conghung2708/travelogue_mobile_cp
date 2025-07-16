import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_schedule_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';

class WorkshopBookingScreen extends StatefulWidget {
  final WorkshopTestModel workshop;
  final WorkshopScheduleTestModel schedule;
  const WorkshopBookingScreen({
    super.key,
    required this.workshop,
    required this.schedule,
  });

  @override
  State<WorkshopBookingScreen> createState() => _WorkshopBookingScreenState();
}

class _WorkshopBookingScreenState extends State<WorkshopBookingScreen> {
  int adultCount = 1;
  int childrenCount = 0;

  int get maxSlot     => widget.schedule.maxParticipant;
  int get booked      => widget.schedule.currentBooked ?? 0;
  int get available   => maxSlot - booked;
  int get totalPeople => adultCount + childrenCount;
  int get remaining   => available - totalPeople;

  final fmt = NumberFormat('#,###');

  double get totalPrice =>
      (adultCount * widget.schedule.adultPrice) +
      (childrenCount * widget.schedule.childrenPrice);

  bool canAdd() => totalPeople < available;

  void _showLimitSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chỉ còn $available chỗ trống.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Image.asset(widget.workshop.imageList.first,
                height: 100.h, width: double.infinity, fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(.55)),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _backBtn(context),
                    SizedBox(height: 3.h),
                    Text('Đặt chỗ Workshop',
                        style:
                            TextStyle(fontSize: 18.sp, color: Colors.white)),
                    SizedBox(height: 0.5.h),
                    Text(widget.workshop.name,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    _summaryCard(),
                    SizedBox(height: 2.h),
                    _counter('Người lớn', adultCount, (v) {
                      setState(() => adultCount = v);
                    }, widget.schedule.adultPrice, minAdult: 1),
                    SizedBox(height: 1.5.h),
                    _counter('Trẻ em', childrenCount, (v) {
                      setState(() => childrenCount = v);
                    }, widget.schedule.childrenPrice, minAdult: 0),
                    SizedBox(height: 1.5.h),
                    Text(
                      remaining >= 0
                          ? '👥 Còn có thể thêm $remaining người.'
                          : '⚠️ Vượt quá số chỗ trống!',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: remaining >= 0
                              ? Colors.white70
                              : Colors.yellowAccent),
                    ),
                    const Spacer(),
                    _totalBar(),
                  ],
                ),
              ),
            )
          ],
        ),
      );


  Widget _backBtn(BuildContext ctx) => Align(
        alignment: Alignment.centerLeft,
        child: CircleAvatar(
          backgroundColor: Colors.white24,
          child: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
      );

 Widget _summaryCard() {
  final d = DateFormat('dd/MM/yyyy')
      .format(DateTime.parse(widget.schedule.startTime));
  final t = '${DateFormat.Hm().format(DateTime.parse(widget.schedule.startTime))} – '
      '${DateFormat.Hm().format(DateTime.parse(widget.schedule.endTime))}';
  final note = widget.schedule.notes;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 2.h),
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.70),
          Colors.white.withOpacity(0.35)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        width: .4.w,
        color: ColorPalette.primaryColor.withOpacity(.3),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.12),
          blurRadius: 14,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.workshop.imageList.first,
            width: 24.w,
            height: 11.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 4.w),

 
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
       
              _chip(Icons.location_on_rounded,  'Làng nghề'),

              SizedBox(height: .6.h),

              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 12, color: Colors.black54),
                  SizedBox(width: 1.w),
                  Text(d, style: TextStyle(fontSize: 11.5.sp)),
                ],
              ),
              SizedBox(height: .3.h),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 12, color: Colors.black54),
                  SizedBox(width: 1.w),
                  Text(t, style: TextStyle(fontSize: 11.5.sp)),
                ],
              ),
              SizedBox(height: .3.h),

              if (note != null && note.isNotEmpty) ...[
                SizedBox(height: .5.h),
                _chip(Icons.sticky_note_2_outlined, note, light: true),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _chip(IconData icon, String text, {bool light = false}) => Container(
      padding: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: .6.h),
      decoration: BoxDecoration(
        color: light
            ? Colors.white.withOpacity(.85)               // sáng rõ
            : ColorPalette.primaryColor.withOpacity(.85), 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: .4.w), 
        boxShadow: [
          BoxShadow(                                     
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12.sp,
              color: light ? Colors.black87 : Colors.white),
          SizedBox(width: 1.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black87 : Colors.white,
            ),
          ),
        ],
      ),
    );

  Widget _counter(String label, int value, Function(int) onChanged,
      double unitPrice,
      {required int minAdult}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$label – ${fmt.format(unitPrice)}đ',
                style: TextStyle(fontSize: 14.sp, color: Colors.white)),
            SizedBox(height: 0.3.h),
            Text(
              label == 'Người lớn'
                  ? '(Từ 12 tuổi trở lên)'
                  : '(1 – dưới 12 tuổi)',
              style:
                  TextStyle(fontSize: 12.sp, color: Colors.white70, fontStyle: FontStyle.italic),
            ),
          ]),
          Row(children: [
            _roundBtn(Icons.remove, (value > minAdult)
                ? () => onChanged(value - 1)
                : null),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text('$value', style: TextStyle(fontSize: 15.sp, color: Colors.white)),
            ),
            _roundBtn(Icons.add, canAdd()
                ? () => onChanged(value + 1)
                : () => _showLimitSnack()),
          ])
        ],
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback? onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onTap == null ? Colors.grey.withOpacity(.2) : Colors.white24,
          ),
          child: Icon(icon, color: Colors.white),
        ),
      );

  Widget _totalBar() => Row(
        children: [
          Expanded(
            child: Text(
              'Tổng: ${fmt.format(totalPrice)}đ',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: remaining >= 0
                ? () {
                 
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Đặt chỗ Workshop thành công!')));
                  }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.8.h)),
            child: const Text('Xác nhận'),
          )
        ],
      );
}
