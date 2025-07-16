import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/model/review_craft_village_test.dart';
import 'package:travelogue_mobile/representation/craft_village/widgets/masonry_item.dart';
import 'package:travelogue_mobile/representation/home/widgets/rating_button_widget.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class CraftVillageDetailScreen extends StatefulWidget {
  const CraftVillageDetailScreen({super.key});
  static const String routeName = '/craft_village_detail_screen';

  @override
  State<CraftVillageDetailScreen> createState() =>
      _CraftVillageDetailScreenState();
}

class _CraftVillageDetailScreenState extends State<CraftVillageDetailScreen>
    with TickerProviderStateMixin {
  CraftVillageModel? village;
  double currentRating = 4.5;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (village == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CraftVillageModel) setState(() => village = args);
    }
  }

  Widget _buildIntroTab(ScrollController sc) => ListView(
        controller: sc,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(village!.name,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pattaya')),
                    SizedBox(height: 1.h),
                    Row(children: [
                      Icon(Icons.location_on,
                          color: Colors.redAccent, size: 18.sp),
                      SizedBox(width: 1.w),
                      Expanded(
                          child: Text(village!.address ?? '',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey[800]))),
                    ]),
                  ],
                ),
              ),
              RatingButtonWidget(
                rating: currentRating,
                onTap: () async {
                  final res = await Navigator.push<double>(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ReviewsScreen<ReviewCraftVillageTestModel>(
                                reviews: mockCraftVillageReviews,
                                averageRating: currentRating)),
                  );
                  if (res != null) setState(() => currentRating = res);
                },
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(right: 55.w),
            child: TitleWithCustoneUnderline(text: 'Giới ', text2: 'thiệu : '),
          ),
          SizedBox(height: 1.h),
          MarkdownBody(
            data: village!.content ?? '',
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(fontSize: 15.sp, color: Colors.black87),
              listBullet: TextStyle(fontSize: 14.sp),
            ),
          ),
          SizedBox(height: 2.5.h),
          Padding(
            padding: EdgeInsets.only(right: 55.w),
            child: TitleWithCustoneUnderline(
              text: 'Hình ',
              text2: 'ảnh :',
            ),
          ),
          SizedBox(height: 1.h),
          ImageGridPreview(images: village!.imageList),
          SizedBox(height: 2.5.h),
          Padding(
            padding: EdgeInsets.only(right: 45.w),
            child: TitleWithCustoneUnderline(
                text: 'Thông tin ', text2: 'liên hệ :'),
          ),
          SizedBox(height: 1.h),
          Text('📞 ${village!.phoneNumber}', style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 0.8.h),
          Text('✉️ ${village!.email}', style: TextStyle(fontSize: 14.sp)),
          if (village!.website != null) ...[
            SizedBox(height: 0.8.h),
            Text('🌐 ${village!.website}', style: TextStyle(fontSize: 14.sp)),
          ],
          SizedBox(height: 4.h),
        ],
      );

  Widget _buildWorkshopTab(ScrollController sc) {
    final list =
        workshops.where((w) => w.craftVillageId == village!.id).toList();

    if (list.isEmpty) return const Center(child: Text('Chưa có workshop nào.'));

    return MasonryGridView.count(
      controller: sc,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      crossAxisCount: 2,
      mainAxisSpacing: 2.h,
      crossAxisSpacing: 3.w,
      itemCount: list.length,
      itemBuilder: (_, i) => MasonryItem(workshop: list[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (village == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(village!.imageList.first, fit: BoxFit.cover)),
        Positioned(top: 4.h, left: 4.w, child: _BackButton()),
        DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.93,
          minChildSize: 0.4,
          builder: (context, sc) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(children: [
                Container(
                  width: 12.w,
                  height: 0.6.h,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10)),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  labelStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  tabs: const [Tab(text: 'Giới thiệu'), Tab(text: 'Workshop')],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildIntroTab(sc), _buildWorkshopTab(sc)],
                  ),
                )
              ]),
            );
          },
        )
      ]),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4.w)),
          child: Icon(FontAwesomeIcons.arrowLeft, size: 16.sp),
        ),
      );
}
