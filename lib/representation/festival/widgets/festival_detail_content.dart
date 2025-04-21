import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/utils/html_widget.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class FestivalDetailContent extends StatelessWidget {
  const FestivalDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final festival = Provider.of<EventModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    String formatDate(DateTime date) {
      return DateFormat('dd/MM/yyyy').format(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),

        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, right: screenWidth * 0.05),
          child: Text(
            formatTitle(festival.name ?? ''),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Pattaya',
              fontSize: (festival.name ?? '').length >= 35 ? 23.sp : 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.only(left: 25.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event, color: Colors.red, size: 18.sp),
              SizedBox(width: 2.w),
              Text(
                "${formatDate(festival.startDate ?? DateTime.now())} - ${formatDate(festival.endDate ?? DateTime.now())}",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        // Thông tin tổ chức
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.sp),
                  child: const CircleAvatar(
                    radius: 33,
                    backgroundImage: AssetImage(AssetHelper.img_logo_tay_ninh),
                  ),
                ),
                SizedBox(height: 12.sp),
                const Row(
                  children: [
                    Text(
                      'Tỉnh đoàn Tây Ninh',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mô tả
                        Text(
                          festival.description ?? '',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey,
                            height: 1.5,
                            fontFamily: 'Pattaya',
                          ),
                        ),

                        SizedBox(height: 12.sp),

                        HtmlWidget(text: festival.content ?? ''),

                        if (festival.listImages.isNotEmpty) ...[
                          SizedBox(height: 1.5.h),
                          Text(
                            '📸 Hình ảnh Lễ Hội',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pattaya",
                            ),
                          ),
                          ImageGridPreview(
                            images: festival.listImages.map((e) => e).toList(),
                          ),
                        ],
                        SizedBox(height: 60.sp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String formatTitle(String title) {
  if (title.length < 20) {
    return '$title\n';
  } else if (!title.contains('\n')) {
    int middle = (title.length / 2).round();
    int splitIndex = title.lastIndexOf(' ', middle);
    if (splitIndex == -1) {
      splitIndex = middle;
    }
    return '${title.substring(0, splitIndex)}\n${title.substring(splitIndex + 1)}';
  }
  return title;
}
