import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import 'package:travelogue_mobile/core/blocs/news/news_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/month_model.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';
import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_screen_background.dart';
import 'package:travelogue_mobile/representation/festival/widgets/month_widget.dart';

class FestivalScreen extends StatefulWidget {
  static const routeName = '/festival_screen';

  const FestivalScreen({super.key});

  @override
  State<FestivalScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  int monthCurrent = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          final List<NewsModel> allNews = state.props[0] as List<NewsModel>;

          final List<NewsModel> festivals = allNews.where((n) {
            if (n.newsCategory != 2) return false;

            if (monthCurrent == 0) return true; // Tất cả tháng

            final start = n.createdTime;
            return start != null && start.month == monthCurrent;
          }).toList();

          return Stack(
            children: [
              Container(color: Colors.white),
              FestivalScreenBackground(screenHeight: 100.h),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 1.5.h),
                    _buildMonthSelector(),
                    Expanded(
                      child: festivals.isEmpty
                          ? _pageEmpty(context)
                          : ListView.builder(
                              padding: EdgeInsets.only(top: 1.h),
                              itemCount: festivals.length,
                              itemBuilder: (context, index) {
                                final festival = festivals[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ExperienceDetailScreen.routeName,
                                      arguments: festival,
                                    );
                                  },
                                  child: FestivalCard(festival: festival),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          ArrowBackButton(onPressed: () => Navigator.of(context).pop()),
          Expanded(
            child: Text(
              "Lễ hội & Sự kiện",
              style: TextStyle(
                fontFamily: "Pattaya",
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (UserLocal().getAccessToken.isNotEmpty)
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: ImageHelper.loadFromAsset(
                  AssetHelper.img_avatar,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: months
            .map((month) => MonthWidget(
                  month: month,
                  isSelected: monthCurrent == month.monthId,
                  onMonthSelected: (selectedMonth) {
                    setState(() {
                      monthCurrent = selectedMonth;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _pageEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(
            AssetHelper.img_search_not_found,
            width: 60.w,
            height: 60.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 2.h),
          Text(
            monthCurrent == 0
                ? "Không tìm thấy sự kiện lễ hội nào"
                : "Không tìm thấy sự kiện lễ hội trong tháng $monthCurrent",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class FestivalCard extends StatelessWidget {
  final NewsModel festival;

  const FestivalCard({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = festival.createdTime ?? now;
    final end = festival.lastUpdatedTime ?? now;

    String statusLabel;
    Color statusColor;

    if (now.isBefore(start)) {
      final daysLeft = start.difference(now).inDays;
      statusLabel = '$daysLeft ngày nữa';
      statusColor = Colors.orangeAccent;
    } else if (now.isAfter(end)) {
      statusLabel = 'Đã qua';
      statusColor = Colors.grey;
    } else {
      statusLabel = 'Đang diễn ra';
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: ImageNetworkCard(
                url: festival.imgUrlFirst,
                height: 18.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    festival.title ?? '',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 18.sp),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    festival.description ?? '',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateItem(Icons.date_range, Colors.blueAccent, start),
                Text("đến",
                    style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
                _dateItem(Icons.event_available, Colors.green, end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateItem(IconData icon, Color color, DateTime date) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18.sp),
        SizedBox(width: 2.w),
        Text(
          _formatDate(date),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}
