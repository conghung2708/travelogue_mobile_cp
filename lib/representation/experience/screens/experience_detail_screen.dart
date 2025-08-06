import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/news_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/single_events_item_header.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class ExperienceDetailScreen extends StatelessWidget {
  static const routeName = '/experience_detail';
  final NewsModel experience;

  const ExperienceDetailScreen({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: CustomScrollView(
        slivers: [
          // Header ảnh + tiêu đề
          SliverPersistentHeader(
            delegate: SingleEventsItemHeaderDelegate(
              title: experience.title ?? '',
              imageAssetPath: experience.imgUrlFirst,
              date: experience.createdTime ?? DateTime.now(),
              maxExtent: maxScreenHeight / 2,
              minExtent: topPadding + 56,
            ),
          ),

          // Nội dung
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin tác giả
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(AssetHelper.img_logo_tay_ninh),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sở Du Lịch Tây Ninh',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                  const SizedBox(height: 20),

                  // Nội dung chi tiết
                  Text(
                    experience.content ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hình ảnh trải nghiệm
                  if (experience.listImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      '📸 Hình ảnh Trải Nghiệm',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Pattaya",
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    ImageGridPreview(
                      images: experience.listImages,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
