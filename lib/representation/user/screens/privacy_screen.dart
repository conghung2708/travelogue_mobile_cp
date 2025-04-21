import 'dart:ui';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const routeName = '/privacy_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB2EBF2), Color(0xFFE0F7FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: const Text(
              'Chính sách quyền riêng tư',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: "Pattaya",
              ),
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2EBF2), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGlassSection(
                  context,
                  icon: Icons.info_outline,
                  title: '1. Giới thiệu',
                  content:
                      'Go Young cam kết bảo vệ quyền riêng tư và thông tin cá nhân của bạn. Chính sách này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ dữ liệu của bạn.',
                ),
                _buildGlassSection(
                  context,
                  icon: Icons.lock_outline,
                  title: '2. Thông tin chúng tôi thu thập',
                  content:
                      'Chúng tôi có thể thu thập tên, email, vị trí, lịch sử tìm kiếm trong ứng dụng để cải thiện trải nghiệm người dùng.',
                ),
                _buildGlassSection(
                  context,
                  icon: Icons.sync_alt,
                  title: '3. Cách sử dụng thông tin',
                  content:
                      'Thông tin của bạn sẽ được dùng để cá nhân hóa trải nghiệm, gửi thông báo sự kiện & chương trình khuyến mãi.',
                ),
                _buildGlassSection(
                  context,
                  icon: Icons.security,
                  title: '4. Bảo mật thông tin',
                  content:
                      'Chúng tôi áp dụng các biện pháp kỹ thuật để bảo vệ dữ liệu khỏi truy cập trái phép, rò rỉ hoặc phá hoại.',
                ),
                _buildGlassSection(
                  context,
                  icon: Icons.verified_user,
                  title: '5. Quyền của người dùng',
                  content:
                      'Bạn có quyền xem, chỉnh sửa hoặc yêu cầu xóa dữ liệu cá nhân bằng cách liên hệ với chúng tôi.',
                ),
                _buildGlassSection(
                  context,
                  icon: Icons.email_outlined,
                  title: '6. Liên hệ',
                  content:
                      'Mọi thắc mắc xin gửi về: support@travelogue.com. Chúng tôi luôn sẵn lòng hỗ trợ bạn 💙',
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Cảm ơn bạn đã tin tưởng sử dụng Go Young 💙',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blueAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
