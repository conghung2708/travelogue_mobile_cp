import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/order/order_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/orders';
  final List<OrderTestModel> orders;
  final bool? isBooked;

  const OrderScreen({super.key, required this.orders, this.isBooked});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int selectedTab = 0;
  final List<String> tabs = ["Sắp diễn ra", "Đang hoạt động", "Đã hoàn tất"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text("Lịch sử đặt tour",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            _buildTabFilter(),
            SizedBox(height: 2.h),
            Expanded(child: _buildOrderList())
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
                    color:
                        isSelected ? Colors.white : ColorPalette.subTitleColor,
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

  Widget _buildOrderList() {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    List<OrderTestModel> filtered = widget.orders.where((order) {
      if (selectedTab == 0) return order.status == 0;
      if (selectedTab == 1) return order.status == 1;
      return order.status == 2;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text('Không có đơn nào.', style: TextStyle(fontSize: 11.sp)),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final o = filtered[index];
        final tour = mockTourTests.firstWhere(
          (t) => t.id == o.tourId,
          orElse: () => TourTestModel(
              id: '',
              name: 'Không tìm thấy tour',
              description: '',
              content: '',
              tourTypeId: '',
              isActive: false,
              isDeleted: false,
              totalDays: 1),
        );
        final media = mockTourMedia.firstWhere(
          (m) => m.tourId == o.tourId,
          orElse: () => TourMediaTestModel(id: 'none'),
        );

        final isAsset = !(media.mediaUrl?.startsWith('http') ?? false);
        final imageWidget = isAsset
            ? Image.asset(media.mediaUrl ?? AssetHelper.img_tay_ninh_login,
                width: double.infinity, height: 20.h, fit: BoxFit.cover)
            : Image.network(media.mediaUrl!,
                width: double.infinity, height: 20.h, fit: BoxFit.cover);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TourDetailScreen(
                  tour: tour,
                  media: media,
                  departureDate: o.scheduledStartDate,
                  isBooked: true,
                ),
              ),
            );
          },
          child: _buildTourCard(
            image: imageWidget,
            title: tour.name,
            duration: '${tour.totalDays} ngày',
            rating: 5.0,
            status: () {
              if (o.status == 1) return 'Đã hoàn tất';
              if (o.status == 2) return 'Đang hoạt động';

              final daysLeft =
                  o.scheduledStartDate.difference(DateTime.now()).inDays;
              if (daysLeft <= 0) return 'Sắp diễn ra hôm nay';
              if (daysLeft == 1) return 'Sắp diễn ra trong 1 ngày';
              return 'Sắp diễn ra trong $daysLeft ngày';
            }(),
            location: 'Tây Ninh',
            price: currency.format(o.totalPaid),
            orderDate: DateFormat('dd/MM/yyyy').format(o.orderDate),
            startDate: DateFormat('dd/MM/yyyy').format(o.scheduledStartDate),
            endDate: DateFormat('dd/MM/yyyy').format(o.scheduledEndDate),
          ),
        );
      },
    );
  }

  Widget _buildTourCard({
    required Widget image,
    required String title,
    required String duration,
    required double rating,
    required String status,
    required String location,
    required String price,
    required String orderDate,
    required String startDate,
    required String endDate,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: image),
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
                    Icon(Icons.schedule, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text('Từ $startDate đến $endDate',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.place, size: 13.sp, color: Colors.grey),
                    SizedBox(width: 1.w),
                    Text(location,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 13.sp, color: Colors.amber),
                    SizedBox(width: 1.w),
                    Text('$rating', style: TextStyle(fontSize: 13.sp)),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: status.contains('Sắp diễn ra')
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : (status == 'Đang hoạt động'
                                ? Colors.lightBlueAccent.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: status.contains('Sắp diễn ra')
                              ? Colors.orange
                              : (status == 'Đang hoạt động'
                                  ? Colors.blue
                                  : Colors.green),
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
