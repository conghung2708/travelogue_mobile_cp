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
      image: AssetHelper.icon_historical_site,
      title: 'Di tích',
      color: const Color(0xffF77777)),
  PlaceCategoryModel(
      image: AssetHelper.icon_travel,
      title: 'Du lịch',
      color: const Color(0xff64B5F6)),
  PlaceCategoryModel(
      image: AssetHelper.iconAll,
      title: 'Tất cả',
      color: const Color(0xffA8E6CF)),
];
