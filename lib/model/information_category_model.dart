import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class EventCategoryModel {
  int id;
  String image;
  String title;

  EventCategoryModel({
    required this.id,
    required this.image,
    required this.title,
});
}

List<EventCategoryModel> eventCategories = [
  // EventCategoryModel(image: AssetHelper.img_hanh_chinh, title: "Hành chính"),
  // EventCategoryModel(image:AssetHelper.img_truyen_thong, title: "Truyền thông"),
  EventCategoryModel(id: 1, image: AssetHelper.img_tin_tuc, title: "Tin tức"),
  // EventCategoryModel(image: AssetHelper.img_trang_tri, title: "Trang trí"),
  EventCategoryModel(image: AssetHelper.img_su_kien, title: "Sự Kiện", id: 2),
  // EventCategoryModel(image: AssetHelper.img_sach_bao, title: "Sách báo"),
  EventCategoryModel(image: AssetHelper.img_di_san, title: "Trải nghiệm", id: 3),
];