import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class DestinationTestModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final List<String> imageUrls;
  final List<int> hobbyIds;

  DestinationTestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrls,
    required this.hobbyIds,
  });
}

final List<DestinationTestModel> mockDestinations = [
  DestinationTestModel(
    id: 1,
    name: 'Núi Bà Đen',
    description: 'Ngọn núi cao nhất Nam Bộ, nổi tiếng với chùa Bà và cáp treo.',
    address: 'Phường Ninh Sơn, TP Tây Ninh',
    imageUrls: [
      AssetHelper.img_ex_ba_den_1,
      AssetHelper.img_ex_ba_den_2,
    ],
    hobbyIds: [1, 5],
  ),
  DestinationTestModel(
    id: 2,
    name: 'Tòa Thánh Tây Ninh',
    description: 'Công trình tôn giáo độc đáo, trung tâm đạo Cao Đài.',
    address: 'Phường Long Hoa, Hòa Thành, Tây Ninh',
    imageUrls: [
      AssetHelper.img_fes_6,
      AssetHelper.img_fes_7,
    ],
    hobbyIds: [2, 3],
  ),
  DestinationTestModel(
    id: 3,
    name: 'Hồ Dầu Tiếng',
    description: 'Hồ nước nhân tạo lớn, thích hợp cho picnic và câu cá.',
    address: 'Xã Minh Tân, Dương Minh Châu',
    imageUrls: [
      AssetHelper.intro3,
      AssetHelper.intro2,
    ],
    hobbyIds: [1, 6],
  ),
  DestinationTestModel(
    id: 4,
    name: 'Ma Thiên Lãnh',
    description: 'Thung lũng giữa núi rừng, hoang sơ và mát mẻ.',
    address: 'Xã Thạnh Tân, TP Tây Ninh',
    imageUrls: [
      AssetHelper.intro2,
      AssetHelper.intro3,
    ],
    hobbyIds: [1, 5],
  ),
  DestinationTestModel(
    id: 5,
    name: 'Tháp cổ Bình Thạnh',
    description: 'Di tích văn hóa Óc Eo hơn nghìn năm tuổi.',
    address: 'Xã Bình Thạnh, Trảng Bàng',
    imageUrls: [AssetHelper.img_thap_01, AssetHelper.img_thap_01],
    hobbyIds: [2, 3],
  ),
  DestinationTestModel(
    id: 6,
    name: 'Chùa Gò Kén',
    description: 'Ngôi chùa lâu đời mang kiến trúc kết hợp Đông - Tây.',
    address: 'Phường Ninh Sơn, TP Tây Ninh',
    imageUrls: [AssetHelper.img_chua_01, AssetHelper.img_chua_02],
    hobbyIds: [2, 3],
  ),
  DestinationTestModel(
    id: 7,
    name: 'Nhà hàng sinh thái Lạc Viên',
    description:
        'Nhà hàng Lạc Viên nổi bật với không gian mở, hòa mình vào thiên nhiên, được thiết kế theo phong cách nhà rường Huế rộng rãi, thoáng mát. Thực đơn đa dạng với các món cơm chay gia đình thuần Việt, phù hợp cho những ai yêu thích ẩm thực chay và không gian yên bình.',
    address:
        'Số 482, đường Điện Biên Phủ, khu phố Hiệp Thành, phường Hiệp Ninh, thành phố Tây Ninh',
    imageUrls: [AssetHelper.img_lac_vien_01, AssetHelper.img_lac_vien_02],
    hobbyIds: [4],
  ),
  DestinationTestModel(
    id: 8,
    name: 'Nhà hàng bò tơ Út Khương',
    description:
        'Chuyên phục vụ các món ăn từ bò tơ như gỏi bò, bò hấp, bò xào, bò nướng và lẩu bò. Không gian rộng rãi, lịch sự, là điểm đến yêu thích của cả khách du lịch và người dân địa phương.',
    address: 'Số 24, đường Ba Tháng Hai, thành phố Tây Ninh',
    imageUrls: [AssetHelper.img_ut_khuong_01, AssetHelper.img_ut_khuong_02],
    hobbyIds: [4],
  ),
  DestinationTestModel(
    id: 9,
    name: ' Nhà hàng ẩm thực Sông Quê',
    description:
        'Thiết kế theo phong cách nhà tranh mái lá, không gian rộng rãi với nhiều cây xanh và hồ nước, mang đến cảm giác đồng quê đích thực.',
    address:
        'Số 169, đường Trần Hưng Đạo, khu phố 1, phường 1, thành phố Tây Ninh',
    imageUrls: [AssetHelper.img_song_que_01, AssetHelper.img_song_que_02],
    hobbyIds: [4],
  ),
  DestinationTestModel(
    id: 10,
    name: 'Nhà hàng hải sản Bờ Kè',
    description:
        'Chuyên phục vụ các món hải sản tươi sống đa dạng từ tôm, cua, cá, ốc đến các loại đặc sản như tôm hùm Alaska, bào ngư, cua hoàng đế. Không gian đơn giản, sạch sẽ, nhân viên phục vụ nhiệt tình.',
    address: 'Số 14, đường Trưng Nữ Vương, phường 2, thành phố Tây Ninh​',
    imageUrls: [AssetHelper.img_bo_ke_01, AssetHelper.img_bo_ke_02],
    hobbyIds: [4],
  ),
  DestinationTestModel(
    id: 11,
    name: 'Suối Đá',
    description: 'Suối nhỏ trong lành, thích hợp tắm mát và picnic.',
    address: 'Chân núi Bà Đen, TP Tây Ninh',
    imageUrls: [AssetHelper.img_suoi_da_01, AssetHelper.img_suoi_da_02],
    hobbyIds: [1, 6],
  ),
  DestinationTestModel(
    id: 12,
    name: 'Khu du lịch Long Điền Sơn',
    description: 'Khu phức hợp giải trí - sinh thái phù hợp gia đình.',
    address: 'Phường Ninh Sơn, TP Tây Ninh',
    imageUrls: [AssetHelper.img_dien_son_01, AssetHelper.img_dien_son_02],
    hobbyIds: [5, 6],
  ),
];
