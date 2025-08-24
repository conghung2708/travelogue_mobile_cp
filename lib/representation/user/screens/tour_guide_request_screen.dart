import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/user/user_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_event.dart';
import 'package:travelogue_mobile/core/blocs/media/media_state.dart';

import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class TourGuideRequestScreen extends StatefulWidget {
  static const routeName = '/tour-guide-request';

  const TourGuideRequestScreen({super.key});

  @override
  State<TourGuideRequestScreen> createState() => _TourGuideRequestScreenState();
}

class _TourGuideRequestScreenState extends State<TourGuideRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _introController = TextEditingController();
  final _priceController = TextEditingController();

  /// Danh sách chứng chỉ (đã là URL sau upload)
  final List<Certification> _certifications = [];

  bool _uploadingCerts = false;
  bool _submitting = false;
  bool _isTourGuide = false;

  @override
  void initState() {
    super.initState();
    // Decode JWT lấy userId → gọi GetUserByIdEvent để lấy roles
    final token = _readAccessToken();
    final userId = _extractUserIdFromJwt(token);
    if (userId != null && userId.isNotEmpty) {
      context.read<UserBloc>().add(GetUserByIdEvent(userId));
    }
  }

  @override
  void dispose() {
    _introController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Upload chứng chỉ
        BlocListener<MediaBloc, MediaState>(
          listener: (context, state) {
            if (state is MediaUploading) {
              setState(() => _uploadingCerts = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⏫ Đang upload chứng chỉ...')),
              );
            } else if (state is MediaUploadSuccess) {
              setState(() => _uploadingCerts = false);
              final urls = state.urls;
              final added = <Certification>[];
              for (final u in urls) {
                final name = _filenameFromUrl(u);
                added.add(Certification(name: name, certificateUrl: u));
              }
              setState(() => _certifications.addAll(added));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Upload thành công ${urls.length} chứng chỉ')),
              );
            } else if (state is MediaUploadFailure) {
              setState(() => _uploadingCerts = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ Upload thất bại: ${state.error}')),
              );
            }
          },
        ),

        // Gửi yêu cầu & lấy user theo id
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            // Flow submit
            if (state is UserLoading) setState(() => _submitting = true);
            if (state is TourGuideRequestSuccess) {
              setState(() => _submitting = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Gửi yêu cầu thành công!')),
              );
              Navigator.pop(context);
            } else if (state is TourGuideRequestFailure) {
              setState(() => _submitting = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }

            // Flow lấy roles
            if (state is GetUserByIdSuccess) {
              setState(() {
                _isTourGuide = state.user.roles.contains('TourGuide');
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildHeroAppBar(context),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 12.h),
                  sliver: SliverToBoxAdapter(
                    child: _isTourGuide ? _buildCongratsCard() : _buildFormCard(),
                  ),
                ),
              ],
            ),
            // Sticky submit bar: Ẩn hoàn toàn nếu đã là HDV
            if (!_isTourGuide)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _SubmitBar(
                  label: 'Gửi yêu cầu',
                  loading: _submitting,
                  onPressed: (_submitting || _uploadingCerts)
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<UserBloc>().add(
                                  SendTourGuideRequestEvent(
                                    introduction: _introController.text.trim(),
                                    price: double.tryParse(
                                            _priceController.text.replaceAll('.', '')) ??
                                        0,
                                    certifications: _certifications,
                                  ),
                                );
                          }
                        },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------- APPBAR ----------

  SliverAppBar _buildHeroAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      expandedHeight: 24.h,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      foregroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(
        builder: (_, constraints) {
          final t = ((constraints.maxHeight - kToolbarHeight) /
                  (24.h - kToolbarHeight))
              .clamp(0.0, 1.0);
          return Container(
            decoration: BoxDecoration(gradient: Gradients.defaultGradientBackground),
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: AnimatedOpacity(
                opacity: t < 0.2 ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _isTourGuide ? 'Chúc mừng Hướng dẫn viên' : 'Trở thành hướng dẫn viên',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              background: _HeroHeader(),
            ),
          );
        },
      ),
    );
  }

  // ---------- CONGRATS VIEW (đã là TourGuide, đọc-only) ----------

  Widget _buildCongratsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Thẻ chúc mừng lớn
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: Gradients.defaultGradientBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 6))],
          ),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(Icons.verified_rounded, size: 48, color: Color(0xFF34C759)),
              ),
              SizedBox(height: 2.h),
              Text(
                '🎉 Chúc mừng!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'Bạn đã là Hướng dẫn viên chính thức trên Travelogue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.2.h),
              // Wrap(
              //   spacing: 10,
              //   runSpacing: 10,
              //   alignment: WrapAlignment.center,
              //   children: const [
              //     _Badge(text: 'Hồ sơ nổi bật', icon: Icons.star_rounded),
              //     _Badge(text: 'Nhận đặt lịch', icon: Icons.event_available_rounded),
              //     _Badge(text: 'Thanh toán an toàn', icon: Icons.payments_rounded),
              //   ],
              // ),
              // SizedBox(height: 2.6.h),

              // Panel khích lệ đọc-only (không có nút hành động)
              const _MotivationPanel(),

              SizedBox(height: 1.h),
            ],
          ),
        ),
        // SizedBox(height: 2.h),

        // // Thẻ tips nhanh (giữ/ẩn tuỳ ý)
        // _QuickTipsCard(),
      ],
    );
  }

  // ---------- FORM VIEW (chưa là TourGuide) ----------

  Widget _buildFormCard() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            icon: Icons.info_outline,
            title: 'Giới thiệu bản thân',
            child: TextFormField(
              controller: _introController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: _inputDecoration('Viết một đoạn giới thiệu ngắn gọn về bạn…'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập giới thiệu' : null,
            ),
          ),
          SizedBox(height: 2.h),

          _SectionCard(
            icon: Icons.attach_money_rounded,
            title: 'Giá dịch vụ (VNĐ / ngày)',
            helper: 'Hãy đưa mức giá phù hợp với kinh nghiệm và khu vực hoạt động',
            child: TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              decoration: _inputDecoration('Ví dụ: 1.200.000'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Vui lòng nhập giá';
                final value = double.tryParse(v.replaceAll('.', ''));
                if (value == null) return 'Giá không hợp lệ';
                if (value <= 0) return 'Giá phải lớn hơn 0';
                return null;
              },
            ),
          ),
          SizedBox(height: 2.h),

          _SectionCard(
            icon: Icons.workspace_premium_rounded,
            title: 'Chứng chỉ',
            action: _uploadingCerts
                ? const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : TextButton.icon(
                    onPressed: _pickAndUploadCertificates,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Chọn tệp & Upload'),
                  ),
            child: _certifications.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'Chưa có chứng chỉ. Hãy chọn tệp để upload (PDF/JPG/PNG).',
                      style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                    ),
                  )
                : Column(
                    children: [
                      ..._certifications.asMap().entries.map(
                            (e) => _CertificationTile(
                              index: e.key,
                              cert: e.value,
                              onDelete: () => setState(() => _certifications.removeAt(e.key)),
                            ),
                          ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- PICK & UPLOAD ----------

  Future<void> _pickAndUploadCertificates() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withReadStream: false,
      );
      if (result == null || result.files.isEmpty) return;

      final files = <File>[];
      for (final f in result.files) {
        if (f.path != null) files.add(File(f.path!));
      }
      if (files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lấy được đường dẫn tệp hợp lệ.')),
        );
        return;
      }
      context.read<MediaBloc>().add(UploadMultipleCertsEvent(files));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn tệp: $e')),
      );
    }
  }

  // ---------- HELPERS ----------

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorPalette.dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ColorPalette.primaryColor, width: 1.5),
        ),
      );

  String _filenameFromUrl(String url) {
    try {
      final u = Uri.parse(url);
      final segs = u.pathSegments;
      if (segs.isNotEmpty) return segs.last;
      return url.split('/').last;
    } catch (_) {
      return url.split('/').last;
    }
  }

  String? _readAccessToken() {
    try {
      final dynamic v = UserLocal().getAccessToken;
      if (v is String) return (v.isEmpty || v == 'null') ? null : v;
      if (v is String Function()) {
        final token = v();
        return (token.isEmpty || token == 'null') ? null : token;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String? _extractUserIdFromJwt(String? token) {
    if (token == null || token.isEmpty) return null;
    final parts = token.split('.');
    if (parts.length < 2) return null;

    String _pad(String s) {
      final mod4 = s.length % 4;
      return mod4 == 0 ? s : s + '=' * (4 - mod4);
    }

    try {
      final payload = utf8.decode(base64Url.decode(_pad(parts[1])));
      final map = json.decode(payload) as Map<String, dynamic>;
      final id = map['Id'] ?? map['nameidentifier'] ?? map['sub'];
      return id?.toString();
    } catch (_) {
      return null;
    }
  }
}

// ===================== SUB-WIDGETS =====================

class _CertificationTile extends StatelessWidget {
  final int index;
  final Certification cert;
  final VoidCallback onDelete;

  const _CertificationTile({
    required this.index,
    required this.cert,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('cert_${index}_${cert.name}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 0.8.h),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          leading: ShaderMask(
            shaderCallback: (bounds) =>
                Gradients.defaultGradientBackground.createShader(bounds),
            child: const Icon(Icons.card_membership, color: Colors.white),
          ),
          title: Text(cert.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            cert.certificateUrl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? helper;
  final Widget child;
  final Widget? action;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.helper,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(2, 4))
        ],
        border: Border.all(color: ColorPalette.dividerColor, width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                Gradients.defaultGradientBackground.createShader(bounds),
            child: Icon(icon, size: 20.sp, color: Colors.white),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13.sp, height: 1.2)),
              if (helper != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(helper!,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11.sp)),
                ),
            ]),
          ),
          if (action != null) action!,
        ]),
        SizedBox(height: 1.h),
        child,
      ]),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  const _SubmitBar({required this.label, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          5.w, 1.2.h, 5.w, 1.2.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Ink(
            decoration: BoxDecoration(
                gradient: Gradients.defaultGradientBackground,
                borderRadius: BorderRadius.circular(14)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              alignment: Alignment.center,
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(label,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp)),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Spacer(),
          Text(
            'Trở thành\nHướng dẫn viên',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Chia sẻ đam mê khám phá, đồng hành cùng du khách khắp nơi.',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14.sp),
          ),
          SizedBox(height: 2.h),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Badge({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.white.withOpacity(0.4))),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// class _QuickTipsCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       icon: Icons.lightbulb_circle_rounded,
//       title: 'Mẹo để nhận nhiều booking',
//       helper: 'Các gợi ý nhanh giúp hồ sơ của bạn nổi bật hơn',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           _TipRow(icon: Icons.edit_note_rounded, text: 'Hoàn thiện mô tả hồ sơ và khu vực hoạt động.'),
//           _TipRow(icon: Icons.photo_camera_back_rounded, text: 'Thêm ảnh đẹp về chuyến đi hoặc trải nghiệm thực tế.'),
//           _TipRow(icon: Icons.schedule_rounded, text: 'Mở lịch trống đều đặn, phản hồi nhanh yêu cầu.'),
//         ],
//       ),
//     );
//   }
// }

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: ColorPalette.primaryColor),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}


class _MotivationPanel extends StatelessWidget {
  const _MotivationPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _MotivationTile(
                icon: Icons.people_alt_outlined,
                title: 'Khách đang tìm HDV',
                subtitle: 'Hàng ngày có hàng trăm lượt tìm kiếm',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _MotivationTile(
                icon: Icons.workspace_premium_outlined,
                title: 'Hồ sơ đầy đủ = 3×',
                subtitle: 'Cơ hội nhận booking tăng gấp ba',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _MotivationTile(
          icon: Icons.bolt_rounded,
          title: 'Phản hồi nhanh < 1 giờ',
          subtitle: 'Thường được ưu tiên khi chọn HDV',
          wide: true,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '“Mỗi hành trình bạn dẫn dắt là một câu chuyện đáng nhớ.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MotivationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool wide;

  const _MotivationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: wide ? EdgeInsets.zero : const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColorPalette.primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.95)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Format thousands separators while typing (e.g., 1200000 -> 1.200.000)
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll('.', '');
    if (digitsOnly.isEmpty) return const TextEditingValue(text: '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[digitsOnly.length - 1 - i]);
      if ((i + 1) % 3 == 0 && i + 1 != digitsOnly.length) buffer.write('.');
    }
    final formatted = buffer.toString().split('').reversed.join();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
