import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';
import 'package:travelogue_mobile/model/booking/booking_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';

class MyBookingScreen extends StatefulWidget {
  static const String routeName = '/my-bookings';
  final List<BookingModel> bookings;

  const MyBookingScreen({super.key, required this.bookings});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  // Status tabs: 0: pending, 1: confirmed, 2: completed
  int selectedStatusTab = 0;
  final List<String> statusTabs = ["Chưa thanh toán", "Đã thanh toán", "Đã hoàn tất"];

  // Type filter: 0: All, 1: Tour, 2: Workshop, 3: Guide
  int selectedType = 0;

  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  bool _prefetchedTours = false;

  @override
  void initState() {
    super.initState();
    _prefetchToursForType1();
  }


  int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

int _statusCodeOf(BookingModel b) {
  final dynamic s = b.status;

  if (s is int) return s;

  if (s is String) {
    final parsed = int.tryParse(s);
    if (parsed != null) return parsed;
  }


  final t = (b.statusText ?? '').trim().toUpperCase();
  if (t == 'PENDING') return 0;
  if (t == 'CONFIRMED') return 1;
  if (t == 'COMPLETED') return 2;

 
  return 0;
}

  String _statusText(BookingModel b) {
    switch (_statusCodeOf(b)) {
      case 0:
        return 'Chưa thanh toán';
      case 1:
        return 'Đã thanh toán';
      case 2:
        return 'Đã hoàn tất';
      default:
        return b.statusText ?? 'Không rõ';
    }
  }

  String _typeText(int t) {
    switch (t) {
      case 1:
        return 'Tour';
      case 2:
        return 'Workshop';
      case 3:
        return 'Hướng dẫn viên';
      default:
        return 'Khác';
    }
  }

  Future<void> _prefetchToursForType1() async {
    if (_prefetchedTours) return;

    final futures = <Future<void>>[];
    for (final b in widget.bookings) {
      final bt = _asInt(b.bookingType, fallback: -1);
      if (bt == 1 && b.tourId != null && b.tour == null) {
        futures.add(() async {
          final tour = await TourRepository().getTourById(b.tourId!);
          if (tour != null) b.tour = tour;
        }());
      }
    }

    await Future.wait(futures);
    if (mounted) {
      setState(() {
        _prefetchedTours = true;
      });
    }
  }

  // ===== Build =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Quản lý đơn hàng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            _buildTypeFilterChips(),
            SizedBox(height: 1.5.h),
            _buildStatusTab(),
            SizedBox(height: 2.h),
            Expanded(child: _buildBookingList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilterChips() {
    // 0: Tất cả, 1: Tour, 2: Workshop, 3: Guide
    final items = const [
      {'label': 'Tất cả', 'value': 0, 'icon': Icons.all_inbox_outlined},
      {'label': 'Tour', 'value': 1, 'icon': Icons.card_travel_outlined},
      {'label': 'Workshop', 'value': 2, 'icon': Icons.handyman_outlined},
      {'label': 'Hướng dẫn viên', 'value': 3, 'icon': Icons.badge_outlined},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((e) {
          final value = e['value'] as int;
          final selected = selectedType == value;
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e['icon'] as IconData, size: 14.sp),
                  SizedBox(width: 1.w),
                  Text(e['label'] as String),
                ],
              ),
              selected: selected,
              onSelected: (_) => setState(() => selectedType = value),
              selectedColor: ColorPalette.primaryColor.withOpacity(0.9),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: selected
                      ? ColorPalette.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusTab() {
    return Container(
      height: 5.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        children: List.generate(statusTabs.length, (index) {
          final isSelected = selectedStatusTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedStatusTab = index),
              child: Container(
                height: 5.5.h,
                alignment: Alignment.center,
                decoration: isSelected
                    ? BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius: BorderRadius.circular(30),
                      )
                    : null,
                child: Text(
                  statusTabs[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : ColorPalette.subTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBookingList() {
    // Lọc theo loại
    final typeFiltered = widget.bookings.where((b) {
      if (selectedType == 0) return true; // Tất cả
      final bt = _asInt(b.bookingType, fallback: -1);
      return bt == selectedType;
    }).toList();

    // Lọc theo trạng thái
    final filtered = typeFiltered.where((b) {
      final code = _statusCodeOf(b);
      switch (selectedStatusTab) {
        case 0:
          return code == 0;
        case 1:
          return code == 1;
        case 2:
          return code == 2 || (b.statusText?.toUpperCase() == 'COMPLETED');
        default:
          return false;
      }
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Không có đơn nào.',
          style: TextStyle(fontSize: 11.sp),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final b = filtered[index];
        final bt = _asInt(b.bookingType, fallback: -1);

        final imageWidget = (bt == 1 && b.tour?.mediaList.isNotEmpty == true)
            ? Image.network(
                b.tour!.mediaList.first.mediaUrl ?? '',
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  AssetHelper.img_tay_ninh_login,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                AssetHelper.img_tay_ninh_login,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              );

 
        final title = (bt == 1)
            ? (b.tour?.name ?? "Tour ...")
            : (b.bookingTypeText ?? _typeText(bt));

        return GestureDetector(
          onTap: () async {
            final statusCode = _statusCodeOf(b);

       
            if (bt == 1 && statusCode == 1 && b.tourId != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              final tour = await TourRepository().getTourById(b.tourId!);
              if (mounted) Navigator.pop(context);

              if (tour != null) {
                b.tour = tour;
                if (mounted) setState(() {});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourDetailScreen(
                      tour: tour,
                      image: tour.mediaList.isNotEmpty
                          ? (tour.mediaList.first.mediaUrl ?? AssetHelper.img_tay_ninh_login)
                          : AssetHelper.img_tay_ninh_login,
                      startTime: b.bookingDate,
                      isBooked: true,
                    ),
                  ),
                );
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Không tìm thấy thông tin tour.")),
                  );
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    bt == 1
                        ? "Tour chưa được thanh toán. Không thể xem chi tiết."
                        : "Đơn đặt hiện chưa hỗ trợ xem chi tiết.",
                  ),
                ),
              );
            }
          },
          child: _buildBookingCard(
            image: imageWidget,
            title: title,
            status: _statusText(b),
            location: "Tây Ninh",
            price: currency.format((b.finalPrice ?? 0)),
            orderDate: DateFormat('dd/MM/yyyy').format(b.bookingDate),
          ),
        );
      },
    );
  }

  Widget _buildBookingCard({
    required Widget image,
    required String title,
    required String status,
    required String location,
    required String price,
    required String orderDate,
  }) {
    Color statusColor;
    Color bgColor;

    if (status == 'Chưa thanh toán') {
      statusColor = Colors.orange;
      bgColor = Colors.orangeAccent.withOpacity(0.2);
    } else if (status == 'Đã thanh toán') {
      statusColor = Colors.blue;
      bgColor = Colors.lightBlueAccent.withOpacity(0.2);
    } else {
      statusColor = Colors.green;
      bgColor = Colors.green.withOpacity(0.2);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: image,
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text(
                      'Ngày đặt: $orderDate',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.place, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text(
                      location,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: bgColor,
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
