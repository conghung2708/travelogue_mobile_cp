import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/image_model.dart';

class CraftVillageModel {
  final String name;
  final String description;
  final String content;
  final int? locationId;
  final String phoneNumber;
  final String email;
  final String? website;
  final double? latitude;
  final double? longitude;
  final String address;
  final List<String> imageList;

  CraftVillageModel({
    required this.name,
    required this.description,
    required this.content,
    this.locationId,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.imageList,
    this.website,
    this.latitude,
    this.longitude,
  });
}

final List<CraftVillageModel> craftVillages = [
  CraftVillageModel(
    name: "Làng nghề bánh tráng phơi sương Trảng Bàng",
    description: "**Nghề làm bánh tráng phơi sương truyền thống**, nổi tiếng khắp cả nước.",
    content: """**Làng nghề bánh tráng phơi sương Trảng Bàng** đã tồn tại hơn 100 năm và là nét văn hóa ẩm thực đặc trưng của Tây Ninh.

- Địa điểm sản xuất chính: *Khu phố Lộc Du, phường Trảng Bàng*.
- Ngày 13/10/2015, nghề này được **Bộ Văn hóa, Thể thao và Du lịch** công nhận là *Di sản văn hóa phi vật thể quốc gia*.

Người dân thường **dậy từ 2 giờ sáng** để kịp phơi sương bánh tráng. Dù công việc cực nhọc, nghề vẫn được **truyền qua nhiều thế hệ**, có gia đình đã nối tiếp tới **4 thế hệ** làm bánh.""",
    locationId: null,
    phoneNumber: "0276-1234-567",
    email: "info@battrangbang.vn",
    website: null,
    latitude: 11.0470,
    longitude: 106.3600,
    address: "Khu phố Lộc Du, thị trấn Trảng Bàng, tỉnh Tây Ninh",
    imageList: [
      AssetHelper.img_lang_nghe_01_01,
      AssetHelper.img_lang_nghe_01_02,
      AssetHelper.img_lang_nghe_01_03,
      AssetHelper.img_lang_nghe_01_04,
    ],
  ),
  CraftVillageModel(
    name: "Làng nghề làm nhang Long Thành Bắc",
    description: "**Làng nghề làm nhang truyền thống với mùi hương dịu nhẹ.**",
    content: """Nghề làm nhang là một phần quan trọng trong văn hóa dân gian Việt Nam, đặc biệt tại tỉnh Tây Ninh.

- Đây là nghề thủ công truyền thống.
- Thể hiện bản sắc của cộng đồng và sự sáng tạo qua nhiều thế hệ.
- Gắn với sự ra đời, tồn tại của tôn giáo và tín ngưỡng tại địa phương.

Mùi nhang dịu nhẹ, quá trình làm thủ công tỉ mỉ là nét đặc trưng của làng nghề.""",
    locationId: null,
    phoneNumber: "0276-2345-678",
    email: "contact@nhanglongthanh.vn",
    website: null,
    latitude: 11.1000,
    longitude: 106.1500,
    address: "Phường Long Thành Bắc, thị xã Hòa Thành, tỉnh Tây Ninh",
    imageList: [
      AssetHelper.img_lang_nghe_02_01,
      AssetHelper.img_lang_nghe_02_02,
      AssetHelper.img_lang_nghe_02_03,
      AssetHelper.img_lang_nghe_02_04,
    ],
  ),
  CraftVillageModel(
    name: "Làng nghề mây tre đan Long Thành Trung",
    description: "**Làng nghề sản xuất các sản phẩm từ mây tre đan thủ công.**",
    content: """Thăm làng nghề mây tre nứa Long Thành Trung:

- Các công đoạn: chẻ, vót tre – phơi – gia công sản phẩm.
- Dùng máy chẻ hiện đại giúp năng suất gấp 10 lần thủ công.
- Người thợ phải chọn nguyên liệu đẹp và làm cẩn thận từng bước.

Sản phẩm bao gồm: bàn ghế, tủ, kệ, salon... đủ kích cỡ, màu sắc tinh xảo.

Mỗi cơ sở tạo việc làm cho nhiều thợ, thu nhập ổn định mỗi ngày.""",
    locationId: null,
    phoneNumber: "0276-3456-789",
    email: "info@maytrelongthanh.vn",
    website: null,
    latitude: 11.1200,
    longitude: 106.1700,
    address: "Phường Long Thành Trung, thị xã Hòa Thành, tỉnh Tây Ninh",
    imageList: [
      AssetHelper.img_lang_nghe_03_01,
      AssetHelper.img_lang_nghe_03_02,
      AssetHelper.img_lang_nghe_03_03,
      AssetHelper.img_lang_nghe_03_04,
    ],
  ),
  CraftVillageModel(
    name: "Làng nghề chằm nón lá An Hòa",
    description: "**Làng nghề chằm nón lá truyền thống với kỹ thuật tinh xảo.**",
    content: """Nghề chằm nón lá ăn sâu vào đời sống người dân tại An Hòa – Tây Ninh.

- Du khách được trải nghiệm làm nón: chọn lá mật cật, luộc, phơi, vuốt lá.
- Làm sườn nón có 3 loại: nón dày, nón thưa, nón lỡ.

Đây là một hoạt động du lịch thú vị giúp du khách hiểu về tinh hoa thủ công Việt.""",
    locationId: null,
    phoneNumber: "0276-4567-890",
    email: "contact@nonlaanhoavn",
    website: null,
    latitude: 11.0500,
    longitude: 106.3000,
    address: "Xã An Hòa, thị xã Trảng Bàng, tỉnh Tây Ninh",
    imageList: [
      AssetHelper.img_lang_nghe_04_01,
      AssetHelper.img_lang_nghe_04_02,
      AssetHelper.img_lang_nghe_04_03,
      AssetHelper.img_lang_nghe_04_04,
    ],
  ),
  CraftVillageModel(
    name: "Làng nghề làm muối ớt Gò Dầu",
    description: "**Làng nghề sản xuất muối ớt truyền thống, đặc sản Tây Ninh.**",
    content: """Nghề làm muối ớt ra đời trong thời kỳ kháng chiến, tiếp tế cho chiến sĩ nơi tiền tuyến.

- Sau giải phóng, muối ớt trở thành đặc sản quen thuộc trong mỗi gia đình.
- Du khách thưởng thức khi viếng miếu Bà, thăm Tòa thánh Cao Đài...

Vị mặn, cay và đậm đà của muối ớt Tây Ninh được yêu thích khắp cả nước.""",
    locationId: null,
    phoneNumber: "0276-5678-901",
    email: "info@muoiotgodau.vn",
    website: null,
    latitude: 11.0300,
    longitude: 106.4200,
    address: "Huyện Gò Dầu, tỉnh Tây Ninh",
    imageList: [
      AssetHelper.img_lang_nghe_05_01,
      AssetHelper.img_lang_nghe_05_02,
      AssetHelper.img_lang_nghe_05_03,
      AssetHelper.img_lang_nghe_05_04,
    ],
  ),
];
