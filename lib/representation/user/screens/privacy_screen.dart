import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const routeName = '/privacy_screen';

  static const _blue = Color(0xFF1E88E5);
  static const _blueSoft = Color(0xFFE8F3FF);
  static const _blueBorder = Color(0xFFE3F2FD);

  static const _supportEmail = 'support@travelogue.com';
  static const _versionText = 'Phiên bản 1.0';
  static const _lastUpdatedText = 'Cập nhật lần cuối: 14/08/2025';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.black87,
      height: 1.2,
    );
    final lead = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    final body = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      height: 1.6,
      color: Colors.black87,
    );
    final note = theme.textTheme.bodySmall?.copyWith(
      color: Colors.black54,
      height: 1.6,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          tooltip: 'Quay lại',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chính sách quyền riêng tư',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            )),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    const _IntroBanner(
                      title: 'Travelogue tôn trọng và bảo vệ dữ liệu của bạn',
                      subtitle:
                          'Chính sách này mô tả cách chúng tôi thu thập, sử dụng và bảo vệ thông tin cá nhân. '
                          'Vui lòng đọc kỹ để hiểu rõ quyền và lựa chọn của bạn.',
                    ),
                    const SizedBox(height: 18),

                    _SectionCard(
                      icon: Icons.info_outline,
                      title: '1. Giới thiệu',
                      titleStyle: lead,
                      child: Text(
                        'Travelogue cam kết bảo vệ quyền riêng tư và thông tin cá nhân của bạn. '
                        'Chính sách này áp dụng cho toàn bộ sản phẩm và dịch vụ của chúng tôi.',
                        style: body,
                      ),
                    ),

                    _SectionCard(
                      icon: Icons.lock_person_outlined,
                      title: '2. Thông tin chúng tôi thu thập',
                      titleStyle: lead,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Tùy tính năng bạn sử dụng, chúng tôi có thể thu thập:',
                              style: body),
                          const SizedBox(height: 8),
                          _Bullets(
                            items: const [
                              'Thông tin tài khoản (tên, email).',
                              'Dữ liệu sử dụng cơ bản (tương tác trong ứng dụng).',
                              'Vị trí (khi bạn cho phép) để gợi ý nội dung phù hợp.',
                              'Lịch sử tìm kiếm nhằm cải thiện trải nghiệm.',
                            ],
                            textStyle: body,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chúng tôi chỉ thu thập những gì cần thiết cho mục đích đã thông báo.',
                            style: note,
                          ),
                        ],
                      ),
                    ),

                    _SectionCard(
                      icon: Icons.sync_alt,
                      title: '3. Cách chúng tôi sử dụng thông tin',
                      titleStyle: lead,
                      child: _Bullets(
                        items: const [
                          'Cá nhân hóa trải nghiệm, đề xuất nội dung phù hợp.',
                          'Cải thiện chất lượng sản phẩm và dịch vụ.',
                          'Gửi thông báo về cập nhật, sự kiện, ưu đãi (khi bạn đồng ý).',
                        ],
                        textStyle: body,
                      ),
                    ),

                    _SectionCard(
                      icon: Icons.security,
                      title: '4. Bảo mật thông tin',
                      titleStyle: lead,
                      child: _Bullets(
                        items: const [
                          'Áp dụng biện pháp kỹ thuật và tổ chức để ngăn truy cập trái phép.',
                          'Giới hạn quyền truy cập dữ liệu nội bộ theo nguyên tắc cần-biết.',
                          'Mã hóa dữ liệu nhạy cảm khi truyền tải (nếu áp dụng).',
                        ],
                        textStyle: body,
                      ),
                    ),

                    _SectionCard(
                      icon: Icons.verified_user_outlined,
                      title: '5. Quyền của bạn',
                      titleStyle: lead,
                      child: _Bullets(
                        items: const [
                          'Yêu cầu truy cập, chỉnh sửa hoặc xóa dữ liệu cá nhân.',
                          'Rút lại sự đồng ý đối với các xử lý không bắt buộc.',
                          'Khiếu nại nếu bạn tin rằng dữ liệu bị xử lý trái quy định.',
                        ],
                        textStyle: body,
                      ),
                    ),

                    _SectionCard(
                      icon: Icons.email_outlined,
                      title: '6. Liên hệ',
                      titleStyle: lead,
                      child: _ContactBlock(
                        email: _supportEmail,
                        bodyStyle: body,
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Footer meta
                    Semantics(
                      label: 'Thông tin phiên bản',
                      child: Column(
                        children: [
                          Text(
                            'Cảm ơn bạn đã tin tưởng sử dụng Travelogue.',
                            style: body?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$_versionText · $_lastUpdatedText',
                            style: note?.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  const _IntroBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PrivacyScreen._blueSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PrivacyScreen._blueBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1.2,
                )),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _Pill(
                    icon: Icons.verified_user_outlined,
                    label: 'Minh bạch & kiểm soát'),
                _Pill(icon: Icons.lock_outline, label: 'Mã hóa & bảo mật'),
                _Pill(icon: Icons.update, label: 'Cập nhật định kỳ'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextStyle? titleStyle;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrivacyScreen._blueBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accent bar + icon
            Column(
              children: [
                Container(
                  width: 3,
                  height: 22,
                  decoration: BoxDecoration(
                    color: PrivacyScreen._blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
                Icon(icon,
                    color: PrivacyScreen._blue,
                    semanticLabel: 'Biểu tượng mục'),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: titleStyle),
                  ),
                  const SizedBox(height: 8),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  final TextStyle? textStyle;

  const _Bullets({required this.items, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 2),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: PrivacyScreen._blue,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(t, style: textStyle)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: PrivacyScreen._blueSoft,
          border: Border.all(color: PrivacyScreen._blueBorder),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: PrivacyScreen._blue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: .1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactBlock extends StatelessWidget {
  final String email;
  final TextStyle? bodyStyle;
  const _ContactBlock({required this.email, this.bodyStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Nếu có câu hỏi hoặc yêu cầu liên quan đến quyền riêng tư, hãy liên hệ:',
            style: bodyStyle),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.mail_outline, color: PrivacyScreen._blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(email,
                  style: bodyStyle?.copyWith(
                    color: PrivacyScreen._blue,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _PrimaryButton(
              icon: Icons.copy,
              label: 'Sao chép email',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã sao chép: $email'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            // const SizedBox(width: 12),
            // _TextButton(
            //   icon: Icons.outgoing_mail,
            //   label: 'Mở trình soạn email',
            //   onPressed: () {
            //     // Không cần package ngoài: dùng mailto:
            //     final uri = Uri(scheme: 'mailto', path: email);
            //     // Navigator.pushNamed có thể không mở được mail app;
            //     // sử dụng SystemChannels để thử mở theo platform default.
            //     SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // no-op fallback
            //     // Gợi ý cho dev: nếu muốn chính xác, tích hợp url_launcher và gọi launchUrl(uri).
            //   },
            // ),
          ],
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: PrivacyScreen._blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

// ignore: unused_element
class _TextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _TextButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        side: BorderSide(color: PrivacyScreen._blue.withOpacity(.4)),
        foregroundColor: PrivacyScreen._blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
