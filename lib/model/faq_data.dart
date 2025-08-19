class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

final List<FaqItem> faqItems = [
  FaqItem(
    question: 'Làm sao để đăng ký tài khoản Travelogue?',
    answer:
        'Bạn có thể đăng ký bằng email hoặc số điện thoại thông qua màn hình đăng ký trong ứng dụng.',
  ),
  FaqItem(
    question: 'Tôi quên mật khẩu, làm sao để khôi phục?',
    answer:
        'Chọn "Quên mật khẩu" trên màn hình đăng nhập và làm theo hướng dẫn để đặt lại mật khẩu.',
  ),
  FaqItem(
    question: 'Travelogue có thu phí sử dụng không?',
    answer:
        'Hiện tại Travelogue hoàn toàn miễn phí cho tất cả người dùng.',
  ),
  FaqItem(
    question: 'Làm sao để cập nhật hồ sơ cá nhân?',
    answer:
        'Bạn có thể vào mục "Tài khoản" và chọn "Chỉnh sửa hồ sơ" để cập nhật thông tin cá nhân.',
  ),
  FaqItem(
    question: 'Ứng dụng Travelogue có hỗ trợ những nền tảng nào?',
    answer:
        'Hiện Travelogue hỗ trợ cả hệ điều hành Android.',
  ),
  FaqItem(
    question: 'Làm sao để xoá tài khoản Travelogue?',
    answer:
        'Bạn vui lòng liên hệ bộ phận hỗ trợ để yêu cầu xoá tài khoản. Việc xoá là vĩnh viễn và không thể khôi phục.',
  ),
  FaqItem(
    question: 'Tôi không nhận được mã xác thực OTP, phải làm sao?',
    answer:
        'Hãy kiểm tra kết nối mạng và thử lại sau vài phút. Nếu vẫn không nhận được, bạn có thể chọn “Gửi lại mã OTP”.',
  ),
  FaqItem(
    question: 'Travelogue có lưu trữ thông tin người dùng như thế nào?',
    answer:
        'Chúng tôi cam kết bảo mật và chỉ lưu trữ thông tin cần thiết để phục vụ trải nghiệm người dùng.',
  ),
  FaqItem(
    question: 'Tôi có thể sử dụng nhiều tài khoản trên cùng một thiết bị không?',
    answer:
        'Bạn có thể đăng xuất tài khoản hiện tại và đăng nhập bằng tài khoản khác. Tuy nhiên, mỗi tài khoản nên dùng riêng cho mục đích bảo mật.',
  ),
  FaqItem(
    question: 'Tôi muốn góp ý hoặc báo lỗi, làm thế nào?',
    answer:
        'Bạn có thể sử dụng mục “Gửi phản hồi” trong phần Trợ giúp để gửi góp ý hoặc báo lỗi cho đội ngũ phát triển.',
  ),
];
