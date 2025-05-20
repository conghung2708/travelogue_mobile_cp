class HobbyTestModel {
  final int id;            
  final String name;        
  final String description;  
  final String iconAsset;   

  HobbyTestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
  });
}

final List<HobbyTestModel> mockHobbies = [
  HobbyTestModel(
    id: 1,
    name: 'Thiên nhiên',
    description: 'Khám phá núi non, rừng rậm, suối và cảnh đẹp tự nhiên.',
    iconAsset: 'assets/icons/nature.png',
  ),
  HobbyTestModel(
    id: 2,
    name: 'Lịch sử',
    description: 'Tìm hiểu về di tích, chiến tích và văn hóa xưa.',
    iconAsset: 'assets/icons/history.png',
  ),
  HobbyTestModel(
    id: 3,
    name: 'Văn hoá',
    description: 'Trải nghiệm lễ hội, tập tục, nghệ thuật truyền thống.',
    iconAsset: 'assets/icons/culture.png',
  ),
  HobbyTestModel(
    id: 4,
    name: 'Ẩm thực',
    description: 'Thưởng thức món ăn đặc sản và hương vị địa phương.',
    iconAsset: 'assets/icons/food.png',
  ),
  HobbyTestModel(
    id: 5,
    name: 'Mạo hiểm',
    description: 'Hoạt động như leo núi, zipline, trekking, khám phá.',
    iconAsset: 'assets/icons/adventure.png',
  ),
  HobbyTestModel(
    id: 6,
    name: 'Nghỉ dưỡng',
    description: 'Thư giãn tại resort, spa, bãi biển hoặc nơi yên bình.',
    iconAsset: 'assets/icons/relax.png',
  ),
  HobbyTestModel(
    id: 7,
    name: 'Chụp ảnh',
    description: 'Khám phá những nơi có background đẹp, góc sống ảo chất lừ.',
    iconAsset: 'assets/icons/photography.png',
  ),
  HobbyTestModel(
    id: 8,
    name: 'Tâm linh',
    description: 'Tham quan chùa, miếu, đền linh thiêng và thanh tịnh.',
    iconAsset: 'assets/icons/spiritual.png',
  ),
  HobbyTestModel(
    id: 9,
    name: 'Mua sắm',
    description: 'Khám phá chợ địa phương, mua đặc sản và quà lưu niệm.',
    iconAsset: 'assets/icons/shopping.png',
  ),
  HobbyTestModel(
    id: 10,
    name: 'Cắm trại',
    description: 'Trải nghiệm cắm trại, BBQ và ngắm sao cùng bạn bè.',
    iconAsset: 'assets/icons/camping.png',
  ),
  HobbyTestModel(
    id: 11,
    name: 'Gia đình',
    description: 'Tour nhẹ nhàng, an toàn, phù hợp với trẻ em và người lớn tuổi.',
    iconAsset: 'assets/icons/family.png',
  ),
  HobbyTestModel(
    id: 12,
    name: 'Giao lưu',
    description: 'Gặp gỡ người bản địa, trò chuyện, học hỏi văn hóa.',
    iconAsset: 'assets/icons/community.png',
  ),
];
