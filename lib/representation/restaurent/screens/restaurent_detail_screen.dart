import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/model/args/reviews_screen_args.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';
import 'package:travelogue_mobile/model/review_restaurent_test_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/rating_button_widget.dart';
import 'package:travelogue_mobile/representation/review/screens/reviews_screen.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  static const String routeName = '/restaurant_detail_screen';

  @override
  RestaurantDetailScreenState createState() => RestaurantDetailScreenState();
}

class RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  RestaurantModel? restaurent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (restaurent == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RestaurantModel) {
        setState(() {
          restaurent = args;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              restaurent!.imgUrlFirst,
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
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                child: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
              ),
            ),
          ),
          Positioned(
            top: kMediumPadding * 3,
            right: kMediumPadding,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                child: const Icon(FontAwesomeIcons.solidHeart, size: 18, color: Colors.red),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.36,
            maxChildSize: 0.85,
            minChildSize: 0.36,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDFDFD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 0.5.h,
                        width: 15.w,
                        margin: EdgeInsets.only(bottom: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurent!.name ?? '',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.red, size: 14.sp),
                                          SizedBox(width: 2.w),
                                          Expanded(
                                            child: Text(
                                              restaurent!.address ?? '',
                                              style: TextStyle(fontSize: 14.sp, height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                RatingButtonWidget(
                                  rating: 4.6,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ReviewsScreen.routeName,
                                      arguments: ReviewsScreenArgs<ReviewRestaurantTestModel>(
                                        reviews: mockRestaurantReviews,
                                        averageRating: 4.6,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            const TitleWithCustoneUnderline(text: 'Menu ', text2: 'Đặc Sắc'),
                            SizedBox(height: 1.h),
                            ImageGridPreview(images: restaurent!.listImages),
                            SizedBox(height: 2.h),
                            const TitleWithCustoneUnderline(text: 'Mô ', text2: 'tả'),
                            SizedBox(height: 1.h),
                            Text(
                              restaurent!.description ?? '',
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey, height: 1.5),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
