import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/image_model.dart';

class Festival {
  String title;
  String description;
  Image image;
  List<Image>? imageList;
  DateTime startDate;
  DateTime endDate;

  Festival({
    required this.title,
    required this.description,
    required this.image,
    this.imageList,
    required this.startDate,
    required this.endDate,
  });
}

List<Festival> festivalsInTayNinh = [
  Festival(
    title: "Lễ hội Chùa Bà Tây Ninh",
    description:
    "Mọi việc chuẩn bị cho lễ Vía Bà được tổ chức từ nhiều ngày trước đó để kịp đến khuya mùng 3 rạng mùng 4/5 âm lịch sẽ làm lễ tắm Bà và thay áo cho Bà. Vào lúc này cửa điện được đóng kín, đèn nến tắt gần hết chỉ còn lại 6 phụ nữ trung niên trong đó có 3 ni cô của nhà chùa bắt tay vào nghi thức tắm tượng Bà, mọi người đến trước tượng Bà làm lễ thắp nhang, xin phép được tắm và thay áo cho Bà. Giữa tuần hương, dưới sự điều hành của một phụ nữ lớn tuổi trong nhóm, mọi người cùng bắt tay và cởi áo khoác trên tượng bà trong suốt năm qua, rồi chuyền tay nhau những gáo nước nấu bằng lá thơm trong rừng (về sau có pha thêm nước hoa) dội lên tượng Bà kỳ cọ sạch sẽ. Sau khi dội nước xong lần cuối, mọi người dùng những chiếc khăn khô và sạch lau khô tượng Bà và thay cho tượng một bộ áo mới.",
    image: Image(imageUrl: AssetHelper.img_fes_1),
    imageList: [
      Image(imageUrl: AssetHelper.img_fes_1_d_1),
      Image(imageUrl: AssetHelper.img_fes_1_d_2),
      Image(imageUrl: AssetHelper.img_fes_1_d_3),
      Image(imageUrl: AssetHelper.img_fes_1_d_4),
      Image(imageUrl: AssetHelper.img_fes_1_d_5),
      Image(imageUrl: AssetHelper.img_fes_1_d_6),
      Image(imageUrl: AssetHelper.img_fes_1_d_7),
    ],
    startDate: DateTime(2025, 1, 1),
    endDate: DateTime(2025, 1, 3),
  ),
  Festival(
    title: "Lễ Vía Bà Linh Sơn Thánh Mẫu",
    description: "Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.",
    image: Image(imageUrl: AssetHelper.img_fes_2),
    startDate: DateTime(2025, 2, 1),
    endDate: DateTime(2025, 2, 5),
  ),
  Festival(
    title: "Lễ hội Xuân Tây Ninh",
    description:
        "Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.",
    image: Image(imageUrl: AssetHelper.img_fes_3),
    startDate: DateTime(2025, 3, 1),
    endDate: DateTime(2025, 3, 5),
  ),
  Festival(
    title: "Lễ hội Đền Thờ Bà Đen",
    description:
    "Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.",
    image: Image(imageUrl: AssetHelper.img_fes_4),
    startDate: DateTime(2025, 4, 10),
    endDate: DateTime(2025, 4, 14),
  ),
  Festival(
    title: "Lễ hội Năm Mới Tây Ninh",
    description:
    "Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.Lễ vía Bà Linh Sơn Thánh Mẫu là ngày lễ trọng đại bậc nhất tại “Đệ Nhất Thiên Sơn” núi Bà Đen, thu hút nhiều du khách và tín đồ hành hương trên cả nước tề tựu đông đảo. Trải qua hàng trăm năm, lễ vía đã trở thành di sản linh thiêng, để lại cho con người nhiều giá trị văn hóa – tâm linh độc đáo và tô điểm thêm cho vẻ đẹp của thiên nhiên trù phú, hoang sơ.",
    image: Image(imageUrl: AssetHelper.img_fes_5),
    startDate: DateTime(2025, 5, 1),
    endDate: DateTime(2025, 5, 3),
  ),
  Festival(
    title: "Lễ hội Võ",
    description: "Lễ hội võ thuật Tây Ninh, được tổ chức vào tháng 6.",
    image: Image(imageUrl: AssetHelper.img_fes_6),
    startDate: DateTime(2025, 6, 10),
    endDate: DateTime(2025, 6, 12),
  ),
  Festival(
    title: "Lễ hội truyền thống động Kim Quang",
    description: "Lễ hội mừng biển cả và các hoạt động văn hóa vào tháng 7.",
    image: Image(imageUrl: AssetHelper.img_fes_7),
    startDate: DateTime(2025, 7, 15),
    endDate: DateTime(2025, 7, 17),
  ),
  Festival(
    title: "Lễ hội Yến Diêu Trì Cung",
    description:
        "Lễ hội tôn thờ tổ tiên và những người có công với đất nước vào tháng 8.",
    image: Image(imageUrl: AssetHelper.img_fes_8),
    startDate: DateTime(2025, 8, 10),
    endDate: DateTime(2025, 8, 12),
  ),
  Festival(
    title: "Lễ hội Trung Thu Tây Ninh",
    description: "Lễ hội dành cho trẻ em vào dịp Trung Thu, tháng 9.",
    image: Image(imageUrl: AssetHelper.img_fes_9),
    startDate: DateTime(2025, 9, 10),
    endDate: DateTime(2025, 9, 12),
  ),
  Festival(
    title: "Lễ giỗ Quan Lớn Trà Vong",
    description: "Lễ hội đón mùa thu hoạch vào tháng 10 tại Tây Ninh.",
    image: Image(imageUrl: AssetHelper.img_fes_10),
    startDate: DateTime(2025, 10, 1),
    endDate: DateTime(2025, 10, 3),
  ),
  Festival(
    title: "Lễ hội bánh tráng Trảng Bàng ở Tây Ninh",
    description:
        "Lễ hội Giáng Sinh với các chương trình âm nhạc và trang trí lộng lẫy vào tháng 12.",
    image: Image(imageUrl: AssetHelper.img_fes_12),
    startDate: DateTime(2025, 12, 24),
    endDate: DateTime(2025, 12, 25),
  ),
];
