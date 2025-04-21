import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/single_events_item_header.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  static const routeName = '/event_detail_screen';

  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context)!.settings.arguments as NewsModel;
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;

    return ColoredBox(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: SingleEventsItemHeaderDelegate(
                title: news.title ?? '',
                imageAssetPath: news.imgUrlFirst,
                date: news.createdTime ?? DateTime.now(),
                maxExtent: maxScreenSizeHeight / 2,
                minExtent: topPadding + 56,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage(AssetHelper.img_logo_tay_ninh),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Tỉnh đoàn Tây Ninh',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 14.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      news.content ?? '',
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 2.h),

          
                    if (news.listImages.isNotEmpty) ...[
                      SizedBox(height: 1.5.h),
                      Text(
                        '📸 Hình ảnh Tin Tức',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Pattaya",
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ImageGridPreview(
                        images: news.listImages.map((e) => e).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
