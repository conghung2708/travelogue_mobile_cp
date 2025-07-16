
import 'package:collection/collection.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';

class WorkshopTestModel {
  final String id;
  final String name;
  final String? description;
  final String? content;
  final String craftVillageId;
  final String? createdTime;
  final String? lastUpdatedTime;
  final String? deletedTime;
  final String? createdBy;
  final String? lastUpdatedBy;
  final String? deletedBy;
  final bool isActive;
  final bool isDeleted;

  WorkshopTestModel({
    required this.id,
    required this.name,
    this.description,
    this.content,
    required this.craftVillageId,
    this.createdTime,
    this.lastUpdatedTime,
    this.deletedTime,
    this.createdBy,
    this.lastUpdatedBy,
    this.deletedBy,
    this.isActive = true,
    this.isDeleted = false,
  });


CraftVillageModel? get craftVillage =>
    craftVillages.firstWhereOrNull((v) => v.id == craftVillageId);

  List<String> get imageList => craftVillage?.imageList ?? [];
}

final List<WorkshopTestModel> workshops = [
  WorkshopTestModel(
    id: 'w01',
    name: 'Trải nghiệm làm bánh tráng',
    description: 'Tự tay tráng & phơi sương bánh tráng Trảng Bàng.',
    content: '''
Bạn sẽ được hoá thân thành nghệ nhân bánh tráng Trảng Bàng – một nghề truyền thống có lịch sử hơn 100 năm. Từ hạt gạo Nàng Hương ngâm nước tro đến thao tác tráng bánh trên nồi hơi đất nung, từng bước đều yêu cầu sự tinh tế và khéo léo.

Điểm độc đáo là công đoạn *phơi sương* – bánh được mang ra sân vào lúc 2–3h sáng để đón làn sương mỏng, giúp bánh mềm, dẻo mà không bị nứt. Bạn sẽ học cách kiểm tra độ chín bằng thao tác "gấp bốn không gãy", và tự tay cuốn bánh cùng rau rừng, thịt luộc, nước mắm me.

> 🎁 Mang về: 10 chiếc bánh tráng phơi sương do chính bạn làm + booklet công thức.
''',
    craftVillageId: '1',
    createdTime: '2025-06-25T09:00:00',
    lastUpdatedTime: '2025-07-05T14:20:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff01',
  ),

  WorkshopTestModel(
    id: 'w02',
    name: 'Làm nhang thơm truyền thống',
    description: 'Pha bột, se lõi tre và nhuộm màu nhang Long Thành Bắc.',
    content: '''
Khám phá hành trình tạo nên bó nhang thủ công đậm hương quê: bắt đầu từ việc chọn tre Tân Châu – loại tre già 3 năm có thớ mịn, được ngâm nước vôi chống mối và phơi nắng đúng 2 ngày. Sau đó, bạn sẽ học cách phối bột hương với tỷ lệ chuẩn: quế Trà My, trầm hương, bời lời và keo thiên nhiên.

Phần thú vị nhất là thao tác se lõi nhang bằng khung tay gỗ mít và nhuộm màu từ lá cẩm, lá bàng. Kết thúc buổi học, bạn tham gia nghi thức “thổi hồn vào nhang” bằng tiếng gõ gỗ truyền thống – một nghi lễ thiêng liêng của nghệ nhân vùng Long Thành.

> 🎁 Mang về: 1 bó nhang 30 cây + clip hướng dẫn se nhang tại nhà (QR code).
''',
    craftVillageId: '2',
    createdTime: '2025-06-26T10:30:00',
    lastUpdatedTime: '2025-07-04T11:00:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff02',
  ),

  WorkshopTestModel(
    id: 'w03',
    name: 'Đan giỏ mây tre cơ bản',
    description: 'Học kỹ thuật đan mắt cáo & lên khung sản phẩm.',
    content: '''
Từ những sợi mây thô, bạn sẽ được hướng dẫn cách chẻ, vót và uốn nan đúng kỹ thuật – tránh gãy mây và đảm bảo độ đàn hồi. Kỹ thuật đan mắt cáo 60 độ – đặc trưng của giỏ Việt – sẽ được giảng viên thị phạm chi tiết, từng vòng nan lồng vào nhau như một bản nhạc hình học.

Bạn cũng được trải nghiệm tạo khung bằng súng hơi nước 160°C giúp bo tròn tự nhiên, và học cách trang trí hoa văn Đông Dương bằng màu từ rễ mật nhân. Sau 3 giờ, bạn sẽ hoàn thành một chiếc giỏ mây xinh xắn – vừa là vật dụng, vừa là kỷ niệm.

> 🎁 Mang về: 01 giỏ mây mini + file SVG pattern tuỳ chỉnh.
''',
    craftVillageId: '3',
    createdTime: '2025-06-27T08:45:00',
    lastUpdatedTime: '2025-07-06T09:15:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff03',
  ),

  WorkshopTestModel(
    id: 'w04',
    name: 'Chằm nón lá nghệ thuật',
    description: 'Tự tay làm nón lá An Hòa với hoạ tiết hoa đơn giản.',
    content: '''
Bạn sẽ bước vào hành trình làm nón lá từ lá mật cật, tre vầu và chỉ sen. Mỗi công đoạn – từ hấp lá 120°C, ép phẳng đến chốt vành tre – đều được làm thủ công với sự hướng dẫn trực tiếp từ nghệ nhân An Hòa.

Sau khi chằm xong 16 vòng, bạn sẽ được thử vẽ hoạ tiết hoa sen hoặc chim triện bằng màu tự nhiên. Nón sẽ được quét lớp dầu bóng để tăng độ bền lên đến 2–3 năm. Trong suốt quá trình, bạn còn nghe những câu chuyện văn hoá gắn liền với chiếc nón Việt.

> 🎁 Mang về: 1 nón lá đã hoàn thiện + túi canvas bảo vệ.
''',
    craftVillageId: '4',
    createdTime: '2025-06-28T13:00:00',
    lastUpdatedTime: '2025-07-07T16:30:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff04',
  ),

  WorkshopTestModel(
    id: 'w05',
    name: 'Pha muối ớt Tây Ninh chuẩn vị',
    description: 'Học bí quyết chọn ớt, rang muối & xay gia vị.',
    content: '''
Muối ớt Tây Ninh không chỉ cay – nó là sự kết hợp kỳ công giữa *chỉ thiên đỏ*, *hiểm xanh*, tỏi Lý Sơn, muối hột rang và đường thốt nốt. Tại workshop, bạn sẽ rang muối đúng 200°C, xay mịn ở tốc độ 20.000 rpm và thử điều chỉnh vị theo tỉ lệ “3 cay – 2 mặn – 1 ngọt”.

Ngoài phần pha muối, bạn còn được trải nghiệm mix muối ớt với trái cây, nước chấm và cả trong cocktail! Một phần thú vị khác là tạo nhãn dán riêng cho hũ muối của bạn như một sản phẩm “thủ công mang đậm dấu ấn cá nhân”.

> 🎁 Mang về: 2 lọ muối ớt tự tay làm + recipe card thiết kế cá nhân hoá.
''',
    craftVillageId: '5',
    createdTime: '2025-06-29T09:20:00',
    lastUpdatedTime: '2025-07-08T10:05:00',
    createdBy: 'admin',
    lastUpdatedBy: 'staff05',
  ),
];
