import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/model/craft_village_model.dart';
import 'package:travelogue_mobile/model/review_craft_village_test.dart';
import 'package:travelogue_mobile/representation/home/widgets/rating_button_widget.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class CraftVillageDetailScreen extends StatefulWidget {
  const CraftVillageDetailScreen({super.key});
  static const String routeName = '/craft_village_detail_screen';

  @override
  State<CraftVillageDetailScreen> createState() => _CraftVillageDetailScreenState();
}

class _CraftVillageDetailScreenState extends State<CraftVillageDetailScreen> {
  CraftVillageModel? village;
  double currentRating = 4.5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (village == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CraftVillageModel) {
        setState(() {
          village = args;
        });
      }
    }
  }

  void _openReviewsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewsScreen<ReviewCraftVillageTestModel>(
          reviews: mockCraftVillageReviews,
          averageRating: currentRating,
        ),
      ),
    );

    if (result is double) {
      setState(() {
        currentRating = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (village == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              village!.imageList.first,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: kMediumPadding * 3,
            left: kMediumPadding,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                child: const Icon(FontAwesomeIcons.arrowLeft, size: 20),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.36,
            maxChildSize: 0.93,
            minChildSize: 0.36,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(
                  left: kMediumPadding,
                  right: kMediumPadding,
                  bottom: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  village!.name,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Pattaya",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.redAccent, size: 22),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        village!.address,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          RatingButtonWidget(
                            rating: currentRating,
                            onTap: _openReviewsScreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 22, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(
                            "Giới thiệu",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pattaya",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MarkdownBody(
                        data: village!.content,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                              fontSize: 15.sp, color: Colors.black87),
                          listBullet: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.photo_library_outlined,
                              size: 22, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            "Hình ảnh",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pattaya",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ImageGridPreview(images: village!.imageList),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.contact_mail_outlined,
                              color: Colors.teal, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            "Thông tin liên hệ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pattaya",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("📞 ${village!.phoneNumber}",
                          style: TextStyle(fontSize: 15.sp)),
                      const SizedBox(height: 6),
                      Text("✉️ ${village!.email}",
                          style: TextStyle(fontSize: 15.sp)),
                      if (village!.website != null) ...[
                        const SizedBox(height: 6),
                        Text("🌐 ${village!.website!}",
                            style: TextStyle(fontSize: 15.sp)),
                      ],
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
