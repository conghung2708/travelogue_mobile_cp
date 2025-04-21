class TayNinhLocation {
  final String title;
  final String desc;
  final String time;
  final String duration;
  final String tip;

  TayNinhLocation({
    required this.title,
    required this.desc,
    required this.time,
    required this.duration,
    required this.tip,
  });

  factory TayNinhLocation.fromMap(Map<String, String> map) {
    return TayNinhLocation(
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      time: map['time'] ?? '',
      duration: map['duration'] ?? '',
      tip: map['tip'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'desc': desc,
      'time': time,
      'duration': duration,
      'tip': tip,
    };
  }

  factory TayNinhLocation.empty() {
    return TayNinhLocation(
      title: '',
      desc: '',
      time: '',
      duration: '',
      tip: '',
    );
  }
}

final Map<String, List<TayNinhLocation>> tayNinhLocationsByStyle = {
  'Văn hoá – Tâm linh': [
    TayNinhLocation(
      title: 'Toà Thánh Cao Đài Tây Ninh',
      desc: 'Kiến trúc độc đáo, nghi lễ tôn giáo đặc sắc.',
      time: 'Sáng',
      duration: '08:00 – 10:30',
      tip: 'Nên đến trước 9h để tham dự buổi lễ.',
    ),
    TayNinhLocation(
      title: 'Chùa Gò Kén',
      desc: 'Ngôi chùa cổ yên bình giữa thiên nhiên.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Giữ trật tự và trang phục kín đáo.',
    ),
    TayNinhLocation(
      title: 'Chùa Khmer Khedol',
      desc: 'Nét văn hóa Khmer độc đáo tại Tây Ninh.',
      time: 'Sáng',
      duration: '10:45 – 12:00',
      tip: 'Mang theo khăn choàng khi vào chính điện.',
    ),
    TayNinhLocation(
      title: 'Chùa Tòa Thánh Tây Ninh – Nhánh Phụ',
      desc: 'Công trình phụ của Tòa Thánh với kiến trúc hài hòa thiên nhiên.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Đi bộ quanh khuôn viên để cảm nhận sự yên bình.',
    ),
    TayNinhLocation(
      title: 'Miếu Bà Đen',
      desc: 'Nơi linh thiêng gắn liền với truyền thuyết Bà Đen.',
      time: 'Sáng',
      duration: '09:00 – 10:00',
      tip: 'Nên thắp hương và cầu an khi đến thăm.',
    ),
    TayNinhLocation(
      title: 'Chùa Thiền Lâm – Gò Kén cổ tự',
      desc: 'Ngôi chùa cổ yên tĩnh giữa cánh đồng lúa.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Đến vào mùa lúa chín sẽ có cảnh rất đẹp.',
    ),
  ],
  'Thiên nhiên – Núi rừng': [
    TayNinhLocation(
      title: 'Núi Bà Đen',
      desc: 'Leo núi hoặc đi cáp treo ngắm toàn cảnh.',
      time: 'Sáng',
      duration: '07:00 – 10:00',
      tip: 'Mang nước và giày thể thao.',
    ),
    TayNinhLocation(
      title: 'Hồ Dầu Tiếng',
      desc: 'Picnic, đạp xe, thư giãn bên hồ rộng lớn.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Chuẩn bị đồ ăn nhẹ và thảm picnic.',
    ),
    TayNinhLocation(
      title: 'Ma Thiên Lãnh',
      desc: 'Trekking trong rừng, suối đá mát lạnh.',
      time: 'Sáng',
      duration: '08:00 – 11:00',
      tip: 'Không đi một mình, mang đồ chống côn trùng.',
    ),
    TayNinhLocation(
      title: 'Rừng phòng hộ Dầu Tiếng',
      desc: 'Khám phá thiên nhiên hoang sơ và hệ sinh thái đa dạng.',
      time: 'Sáng',
      duration: '07:30 – 10:30',
      tip: 'Mang theo ống nhòm để ngắm chim.',
    ),
    TayNinhLocation(
      title: 'Suối Đá',
      desc: 'Suối tự nhiên đổ từ núi Bà Đen với nhiều bậc đá đẹp.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Cẩn thận khi đi vào mùa mưa.',
    ),
    TayNinhLocation(
      title: 'Cánh đồng năng lượng mặt trời Dầu Tiếng',
      desc: 'Cảnh đẹp rộng lớn với dàn pin mặt trời trải dài.',
      time: 'Chiều',
      duration: '16:00 – 17:30',
      tip: 'Chụp ảnh lúc hoàng hôn rất nghệ.',
    ),
  ],
  'Trải nghiệm – Mạo hiểm': [
    TayNinhLocation(
      title: 'Zipline núi Bà Đen',
      desc: 'Trượt zipline từ sườn núi, ngắm rừng núi hùng vĩ.',
      time: 'Chiều',
      duration: '14:00 – 15:30',
      tip: 'Kiểm tra dây an toàn kỹ càng.',
    ),
    TayNinhLocation(
      title: 'Trekking Ma Thiên Lãnh',
      desc: 'Chinh phục thử thách núi đá và rừng sâu.',
      time: 'Sáng',
      duration: '07:00 – 10:00',
      tip: 'Không nên đi mưa, dễ trơn trượt.',
    ),
    TayNinhLocation(
      title: 'Leo núi đá Đá Đen',
      desc: 'Leo núi đá dựng đứng, dành cho người ưa thử thách.',
      time: 'Sáng',
      duration: '06:30 – 09:00',
      tip: 'Chuẩn bị đầy đủ thiết bị bảo hộ.',
    ),
    TayNinhLocation(
      title: 'Lái xe địa hình quanh Hồ Dầu Tiếng',
      desc: 'Chạy xe địa hình địa thế đa dạng gần hồ.',
      time: 'Chiều',
      duration: '14:30 – 16:30',
      tip: 'Chỉ nên đi nếu đã quen địa hình.',
    ),
    TayNinhLocation(
      title: 'Cắm trại hoang dã ven rừng',
      desc: 'Trải nghiệm đêm giữa thiên nhiên hoang sơ.',
      time: 'Tối',
      duration: 'Từ 18:00 đến sáng hôm sau',
      tip: 'Mang đủ vật dụng sinh tồn và đèn pin.',
    ),
    TayNinhLocation(
      title: 'Chèo SUP hồ Dầu Tiếng',
      desc: 'Trải nghiệm cảm giác thăng bằng trên mặt nước giữa thiên nhiên.',
      time: 'Sáng',
      duration: '08:00 – 09:30',
      tip: 'Mặc áo phao và không mang đồ điện tử theo.',
    ),
    TayNinhLocation(
      title: 'Khám phá hang động núi Heo',
      desc: 'Chui hang, leo đá và cảm giác mạo hiểm cực đã.',
      time: 'Sáng',
      duration: '07:00 – 10:00',
      tip: 'Mang đèn đội đầu và giày chuyên dụng.',
    ),
    TayNinhLocation(
      title: 'Lướt ván trên hồ Núi Đất',
      desc: 'Hoạt động thể thao nước dành cho tín đồ tốc độ.',
      time: 'Chiều',
      duration: '15:00 – 16:30',
      tip: 'Nên đi theo nhóm để hỗ trợ an toàn.',
    ),
    TayNinhLocation(
      title: 'Đi xe địa hình xuyên rừng Tân Châu',
      desc: 'Cung đường đất đỏ bụi bặm và nhiều thử thách.',
      time: 'Sáng',
      duration: '09:00 – 11:30',
      tip: 'Mang khẩu trang và kính bảo hộ.',
    ),
  ],
  'Lịch sử – Di tích': [
    TayNinhLocation(
      title: 'Địa đạo An Thới',
      desc: 'Tìm hiểu lịch sử chiến tranh qua địa đạo.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Có thể thuê hướng dẫn viên tại chỗ.',
    ),
    TayNinhLocation(
      title: 'Căn cứ Trung ương Cục miền Nam',
      desc: 'Chiến khu lịch sử quan trọng bậc nhất.',
      time: 'Sáng',
      duration: '08:30 – 11:00',
      tip: 'Mang giày thể thao và áo dài tay.',
    ),
    TayNinhLocation(
      title: 'Địa điểm Junction City',
      desc: 'Chiến thắng vang dội của lực lượng cách mạng.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Nên đi theo nhóm nhỏ.',
    ),
    TayNinhLocation(
      title: 'Đền tưởng niệm liệt sĩ Tân Biên',
      desc: 'Khu tưởng niệm yên bình và trang nghiêm.',
      time: 'Sáng',
      duration: '08:00 – 09:00',
      tip: 'Giữ im lặng và thể hiện sự tôn trọng.',
    ),
    TayNinhLocation(
      title: 'Di tích lịch sử Lò Gạch cũ',
      desc: 'Lò gạch cổ dùng trong kháng chiến chống Mỹ.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Có thể chụp ảnh cổ kính rất đẹp.',
    ),
    TayNinhLocation(
      title: 'Căn cứ Mặt trận Dân tộc Giải phóng miền Nam',
      desc: 'Địa điểm quan trọng trong kháng chiến miền Nam.',
      time: 'Sáng',
      duration: '09:00 – 11:00',
      tip: 'Nên thuê hướng dẫn viên để hiểu rõ lịch sử.',
    ),
  ],
  'Chụp ảnh – Sống ảo': [
    TayNinhLocation(
      title: 'Cánh đồng hoa tam giác mạch',
      desc: 'Góc sống ảo siêu chất giữa thiên nhiên.',
      time: 'Sáng',
      duration: '08:00 – 09:30',
      tip: 'Đến sớm để có ánh sáng đẹp.',
    ),
    TayNinhLocation(
      title: 'Đồi cỏ lau',
      desc: 'Thảm cỏ mềm mịn trải dài cực chill.',
      time: 'Chiều',
      duration: '16:00 – 17:30',
      tip: 'Mùa thu là thời điểm đẹp nhất.',
    ),
    TayNinhLocation(
      title: 'Tháp Chót Mạt',
      desc: 'Tháp cổ kiến trúc tuyệt đẹp cho bức ảnh nghệ thuật.',
      time: 'Trưa',
      duration: '12:30 – 13:30',
      tip: 'Mang theo tripod để chụp toàn cảnh.',
    ),
    TayNinhLocation(
      title: 'Vườn hoa hướng dương Tây Ninh',
      desc: 'Không gian sống ảo siêu lung linh vào mùa nở.',
      time: 'Sáng',
      duration: '07:00 – 08:30',
      tip: 'Trang phục sáng màu sẽ nổi bật hơn.',
    ),
    TayNinhLocation(
      title: 'Cầu tre xuyên rừng',
      desc: 'Cầu tre dài uốn lượn giữa khu sinh thái.',
      time: 'Chiều',
      duration: '15:30 – 17:00',
      tip: 'Rất phù hợp cho ảnh couple.',
    ),
    TayNinhLocation(
      title: 'Cánh đồng bò sữa Tây Ninh',
      desc: 'Phong cảnh xanh mát, đàn bò dễ thương.',
      time: 'Sáng',
      duration: '08:00 – 09:30',
      tip: 'Thử selfie với bò nếu can đảm.',
    ),
    TayNinhLocation(
      title: 'Cầu kính Núi Bà Đen',
      desc: 'Check-in cầu kính trên mây độc đáo bậc nhất miền Nam.',
      time: 'Sáng',
      duration: '08:00 – 09:00',
      tip: 'Nên mặc đồ nổi bật để tạo điểm nhấn.',
    ),
    TayNinhLocation(
      title: 'Rừng cao su Bến Củi',
      desc: 'Rừng cao su mùa thay lá tuyệt đẹp, chill như phim Hàn.',
      time: 'Chiều',
      duration: '16:00 – 17:30',
      tip: 'Chụp từ xa với lens tele để tạo chiều sâu.',
    ),
    TayNinhLocation(
      title: 'Đồi đá trắng Tân Biên',
      desc: 'Khung cảnh đá trắng tự nhiên đầy hoang sơ, độc đáo.',
      time: 'Sáng',
      duration: '07:30 – 09:00',
      tip: 'Mang giày đế bám để dễ di chuyển trên đá.',
    ),
    TayNinhLocation(
      title: 'Đồng cừu Suối Dây',
      desc: 'Chụp ảnh cùng những chú cừu đáng yêu giữa đồng cỏ.',
      time: 'Chiều',
      duration: '15:00 – 16:30',
      tip: 'Nên cho cừu ăn nhẹ để dễ tương tác chụp hình.',
    ),
  ],
  'Nghỉ dưỡng – Thư giãn': [
    TayNinhLocation(
      title: 'Resort ven Hồ Dầu Tiếng',
      desc: 'Nghỉ dưỡng không khí trong lành, view hồ tuyệt đẹp.',
      time: 'Chiều',
      duration: '15:00 – 18:00',
      tip: 'Mang kính mát và kem chống nắng.',
    ),
    TayNinhLocation(
      title: 'Nhà cổ Đốc Phủ Sứ',
      desc: 'Di tích kiến trúc cổ giữa lòng thành phố.',
      time: 'Sáng',
      duration: '09:00 – 10:00',
      tip: 'Chụp hình cực đẹp, phù hợp buổi sáng.',
    ),
    TayNinhLocation(
      title: 'Farmstay gần hồ Suối Đá',
      desc: 'Không gian mở, thư giãn giữa thiên nhiên.',
      time: 'Chiều',
      duration: '14:00 – 17:00',
      tip: 'Có thể đặt trước để chọn phòng view đẹp.',
    ),
    TayNinhLocation(
      title: 'Khu du lịch Long Điền Sơn',
      desc: 'Nơi nghỉ dưỡng kết hợp giải trí nhẹ nhàng.',
      time: 'Sáng',
      duration: '09:00 – 11:30',
      tip: 'Thích hợp cho gia đình có trẻ nhỏ.',
    ),
    TayNinhLocation(
      title: 'Quán cà phê sân vườn Núi Bà',
      desc: 'Thưởng thức cà phê view núi cực chill.',
      time: 'Sáng',
      duration: '07:30 – 09:00',
      tip: 'Gọi món đá xay cho buổi sáng mát mẻ.',
    ),
    TayNinhLocation(
      title: 'Homestay view ruộng lúa Trảng Bàng',
      desc: 'Nơi yên bình thư giãn với cảnh đồng quê mát mắt.',
      time: 'Chiều',
      duration: '15:00 – 17:30',
      tip: 'Nên đi mùa lúa xanh để có view đẹp nhất.',
    ),
    TayNinhLocation(
      title: 'Thiền viện Trúc Lâm Tây Ninh',
      desc: 'Không gian tĩnh lặng giữa núi rừng để tâm an, trí tịnh.',
      time: 'Sáng',
      duration: '08:00 – 09:30',
      tip: 'Giữ yên lặng và mặc trang phục kín đáo.',
    ),
    TayNinhLocation(
      title: 'Khu nghỉ dưỡng Hồ Núi Đá',
      desc: 'Resort nhỏ ven hồ, phù hợp nghỉ cuối tuần.',
      time: 'Chiều',
      duration: '14:00 – 17:00',
      tip: 'Đặt phòng trước vì cuối tuần thường đông.',
    ),
    TayNinhLocation(
      title: 'Tắm suối tại suối Đá Vàng',
      desc: 'Ngâm mình trong dòng suối mát giữa thiên nhiên.',
      time: 'Sáng',
      duration: '09:00 – 10:30',
      tip: 'Mang theo đồ bơi và khăn tắm cá nhân.',
    ),
  ],
};

final List<TayNinhLocation> lunchOptions = [
  TayNinhLocation(
    title: 'Bánh canh Trảng Bàng',
    desc: 'Món đặc sản nổi tiếng lâu đời của Tây Ninh.',
    time: 'Trưa',
    duration: '11:30 – 13:00',
    tip: 'Ghé quán Cô Năm là chuẩn vị.',
  ),
  TayNinhLocation(
    title: 'Bánh tráng me Tây Ninh',
    desc: 'Đặc sản lạ miệng, chua ngọt hấp dẫn.',
    time: 'Trưa',
    duration: '12:00 – 13:00',
    tip: 'Nên ăn liền để giữ độ dẻo.',
  ),
  TayNinhLocation(
    title: 'Bò tơ cuốn bánh tráng',
    desc: 'Thịt bò tơ mềm ngọt ăn kèm rau sống và nước chấm.',
    time: 'Trưa',
    duration: '11:00 – 12:30',
    tip: 'Ghé Bò Tơ Năm Sánh để trải nghiệm chuẩn vị.',
  ),
  TayNinhLocation(
    title: 'Cơm niêu Tây Ninh',
    desc: 'Món cơm dân dã với thịt kho và rau vườn.',
    time: 'Trưa',
    duration: '12:00 – 13:30',
    tip: 'Ăn kèm nước mắm me rất ngon.',
  ),
  TayNinhLocation(
    title: 'Bún riêu cua đồng',
    desc: 'Nước dùng ngọt thanh, cua tươi và rau sống đa dạng.',
    time: 'Trưa',
    duration: '11:30 – 13:00',
    tip: 'Thêm chút mắm tôm sẽ đậm đà hơn.',
  ),
  TayNinhLocation(
    title: 'Gà nướng muối ớt Tây Ninh',
    desc: 'Gà nướng nguyên con, vị cay mặn đậm đà.',
    time: 'Trưa',
    duration: '12:00 – 13:30',
    tip: 'Ăn kèm xôi hoặc bánh hỏi rất hợp.',
  ),
];
