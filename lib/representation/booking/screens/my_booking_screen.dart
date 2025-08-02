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
  int selectedTab = 0;
  final List<String> tabs = ["Chưa thanh toán", "Đã thanh toán", "Đã hoàn tất"];
  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  late String bookingType;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      bookingType = args?['bookingType'] ?? '1';
      _loadAllToursForBookings();
      _isInit = false;
    }
  }

  void _loadAllToursForBookings() async {
    for (final b in widget.bookings) {
      if (b.tourId != null && b.tour == null) {
        final tour = await TourRepository().getTourById(b.tourId!);
        if (tour != null) {
          b.tour = tour;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          bookingType == '3' ? "Lịch trình cá nhân" : "Lịch sử đặt tour",
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
            _buildTabFilter(),
            SizedBox(height: 2.h),
            Expanded(child: _buildBookingList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabFilter() {
    return Container(
      height: 5.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
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
                  tabs[index],
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
    final filtered = widget.bookings.where((b) {
      switch (selectedTab) {
        case 0:
          return b.status == "0";
        case 1:
          return b.status == "1";
        case 2:
          return b.status == "2" || b.statusText?.toUpperCase() == 'COMPLETED';
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
        final imageWidget = Image.asset(
          AssetHelper.img_tay_ninh_login,
          width: double.infinity,
          height: 20.h,
          fit: BoxFit.cover,
        );

        return GestureDetector(
          onTap: () async {
            if (b.status == "1" && b.tourId != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              final tour = await TourRepository().getTourById(b.tourId!);
              Navigator.pop(context);

              if (tour != null) {
                b.tour = tour;
                setState(() {});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourDetailScreen(
                      tour: tour,
                      image: tour.mediaList.isNotEmpty
                          ? (tour.mediaList.first.mediaUrl ?? AssetHelper.img_tay_ninh_login)
                          : AssetHelper.img_tay_ninh_login,
                      departureDate: b.bookingDate,
                      isBooked: true,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không tìm thấy thông tin tour.")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tour chưa được thanh toán. Không thể xem chi tiết.")),
              );
            }
          },
          child: _buildBookingCard(
            image: imageWidget,
            title: b.tour?.name ?? "Tour ...",
            status: _getStatusText(b),
            location: "Tây Ninh",
            price: currency.format(b.finalPrice),
            orderDate: DateFormat('dd/MM/yyyy').format(b.bookingDate),
          ),
        );
      },
    );
  }

  String _getStatusText(BookingModel b) {
    switch (b.status) {
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
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: image,
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.primaryColor)),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text('Ngày đặt: $orderDate',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                    const Spacer(),
                    Text(price,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.place, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text(location,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
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
