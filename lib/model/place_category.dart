import 'dart:ui';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class PlaceCategoryModel {
  String title;
  String image;
  Color color;

  PlaceCategoryModel({
    required this.image,
    required this.title,
    required this.color,
  });
}

List<PlaceCategoryModel> placeCategories = [
  PlaceCategoryModel(
    image: AssetHelper.iconAll,
    title: 'Tất Cả',
    color: const Color(0xffA8E6CF),
  ),
  PlaceCategoryModel(
    image: AssetHelper.icon_historical_site,
    title: 'Danh Lam Thắng Cảnh',
    color: const Color(0xffF77777),
  ),
  PlaceCategoryModel(
    image: AssetHelper.icon_travel,
    title: 'Làng Nghề',
    color: const Color(0xff64B5F6),
  ),
  PlaceCategoryModel(
    image: AssetHelper.icon_historical_site,
    title: 'Địa Điểm Lịch Sử',
    color: const Color(0xffFFB74D), 
  ),
  PlaceCategoryModel(
    image: AssetHelper.img_icon_restauant,
    title: 'Ẩm Thực',
    color: const Color(0xffAED581),  
  ),
];
