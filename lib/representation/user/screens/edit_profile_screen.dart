import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/representation/user/screens/otp_vertification_screen.dart';

// Repositories + models
import 'package:travelogue_mobile/core/repository/user_repository.dart';
import 'package:travelogue_mobile/model/user/user_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  // Controllers & state
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // Email (readonly, giữ nguyên như yêu cầu)
  String _email = "";
  late final TextEditingController _emailReadonlyController;

  // Animation an toàn
  AnimationController? _animController;
  Animation<double>? _fadeAnim;

  // Avatar
  File? _avatarFile;
  String? _avatarUrl;

  // Save state
  bool _saving = false;

  // Repo
  final _userRepo = UserRepository();

  @override
  void initState() {
    super.initState();
    final user = UserLocal().getUser();
    _nameController.text = user.fullName ?? '';
    _email = user.email ?? '';
    _emailReadonlyController = TextEditingController(text: _email);

    // Optional fields
    _addressController.text = user.address ?? '';
    _phoneController.text = user.phoneNumber ?? '';

    // Avatar
    _avatarUrl = user.avatarUrl;

    // init animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController!, curve: Curves.easeInOut);
    _animController!.forward();
  }

  @override
  void dispose() {
    _animController?.dispose();
    _nameController.dispose();
    _emailReadonlyController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _avatarFile = File(picked.path));
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: ${e.message}')),
      );
    }
  }

  Future<void> _saveChanges() async {
    final user = UserLocal().getUser();
    final userId = user.id;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không xác định được tài khoản.")),
      );
      return;
    }

    if (_saving) return;
    setState(() => _saving = true);

    try {
      // 1) Upload avatar nếu có file mới chọn
      if (_avatarFile != null) {
        print('[➡️ UPDATE AVATAR] file=${_avatarFile!.path}');
        final newUrl = await _userRepo.updateAvatar(_avatarFile!);
        print('[⬅️ UPDATE AVATAR] newUrl=$newUrl');

        if (newUrl != null && newUrl.isNotEmpty) {
          _avatarUrl = newUrl;
          final merged = user.copyWith(avatarUrl: newUrl);
          UserLocal().saveUser(merged);
          if (mounted) setState(() {});
        } else {
          print('[⚠️] Upload avatar không trả về URL.');
        }
      }

      // 2) Update profile (tên, sđt, địa chỉ…)
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim();
      final addr = _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim();

      print(
          '[➡️ UPDATE PROFILE] id=$userId name=$name phone=$phone address=$addr');
      final updated = await _userRepo.updateUserProfile(
        id: userId,
        fullName: name.isEmpty ? null : name,
        phoneNumber: phone,
        address: addr,
      );
      print('[⬅️ UPDATE PROFILE] $updated');

      // Cập nhật cache local
      if (updated != null) {
        final merged = user.copyWith(
          fullName: updated.fullName ?? name,
          phoneNumber: updated.phoneNumber ?? phone,
          address: updated.address ?? addr,
          avatarUrl: _avatarUrl ?? user.avatarUrl,
        );
        UserLocal().saveUser(merged);
      } else {
        final merged = user.copyWith(
          fullName: name.isEmpty ? user.fullName : name,
          phoneNumber: phone ?? user.phoneNumber,
          address: addr ?? user.address,
          avatarUrl: _avatarUrl ?? user.avatarUrl,
        );
        UserLocal().saveUser(merged);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thông tin đã được cập nhật!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('[❌ UPDATE PROFILE ERROR] $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmChangePassword() async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Xác nhận"),
            content: const Text("Bạn có chắc muốn thay đổi mật khẩu không?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Không")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Có")),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    // GIỮ NGUYÊN logic gửi OTP
    AppBloc.authenicateBloc.add(
      SendOTPEmailEvent(
        context: context,
        email: _email,
      ),
    );
    if (!mounted) return;
    Navigator.pushNamed(context, OtpVerificationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Fallback animation nếu hot-reload chưa init kịp
    final opacityAnim = _fadeAnim ?? const AlwaysStoppedAnimation<double>(1);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: opacityAnim,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.w),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    _buildProfileCard(),
                    SizedBox(height: 3.h),
                    _buildChangePasswordSection(),
                    SizedBox(height: 4.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Gradient
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 2.h, bottom: 3.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Chỉnh sửa thông tin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: "Pattaya",
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Profile Card (đẹp + gọn)
  Widget _buildProfileCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: const Color(0xFF0288D1).withOpacity(0.18),
      child: Padding(
        padding: EdgeInsets.fromLTRB(5.w, 2.6.h, 5.w, 2.6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      backgroundImage: _avatarFile != null
                          ? FileImage(_avatarFile!) as ImageProvider
                          : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                              ? NetworkImage(_avatarUrl!)
                              : null,
                      child: (_avatarFile == null &&
                              (_avatarUrl == null || _avatarUrl!.isEmpty))
                          ? Icon(Icons.person_rounded,
                              size: 42, color: Colors.blueGrey[300])
                          : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: _saving ? null : _pickAvatar,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xFF1E88E5), width: 1.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            size: 18, color: Color(0xFF1E88E5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.2.h),

            _buildLabel("Tên của bạn"),
            _buildTextField(_nameController,
                icon: Icons.person_outline, hint: 'Nhập tên hiển thị'),

            SizedBox(height: 2.0.h),
            _buildLabel("Email đăng ký"),
            _buildTextField(
              _emailReadonlyController,
              icon: Icons.email_outlined,
              readOnly: true,
              hint: 'Email đã xác thực',
              suffix: const Icon(Icons.verified, color: Colors.green),
            ),

            SizedBox(height: 2.0.h),
            _buildLabel("Số điện thoại"),
            _buildTextField(_phoneController,
                icon: Icons.phone_rounded, hint: 'Số điện thoại (tuỳ chọn)'),

            SizedBox(height: 2.0.h),
            _buildLabel("Địa chỉ"),
            _buildTextField(_addressController,
                icon: Icons.home_outlined, hint: 'Địa chỉ (tuỳ chọn)'),
          ],
        ),
      ),
    );
  }

  /// Change Password (GIỮ NGUYÊN)
  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Bạn muốn đổi mật khẩu?"),
        SizedBox(height: 1.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _confirmChangePassword,
            icon: Icon(Icons.lock_reset, size: 18.sp, color: Colors.teal),
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.6.h),
              child: Text(
                "Thay đổi mật khẩu",
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
              side: const BorderSide(color: Colors.teal, width: 1.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Save Button (gradient, loading state)
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF0288D1)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0288D1).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 1.8.h),
          ),
          onPressed: _saving ? null : _saveChanges,
          icon: _saving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save, color: Colors.white),
          label: _saving
              ? const Text('Đang lưu...',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600))
              : Text(
                  "Lưu thay đổi",
                  style: TextStyle(
                      fontSize: 14.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  /// Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, bottom: 0.8.h),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey[800]),
      ),
    );
  }

  /// Text Field với icon nền tròn xanh nhạt
  Widget _buildTextField(
    TextEditingController controller, {
    IconData? icon,
    String? hint,
    bool readOnly = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Container(
                margin: EdgeInsets.all(1.5.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blueAccent),
              )
            : null,
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black45, fontSize: 12.5.sp),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE3F2FD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
    );
  }
}
