import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/user/user_bloc.dart';
import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

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
  final List<Certification> _certifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
  backgroundColor: Colors.transparent, 
  elevation: 0, 
  centerTitle: true,
  title: Text(
    "Đăng ký Hướng dẫn viên",
    style: TextStyle(
      color: ColorPalette.primaryColor, 
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
      fontFamily: "Pattaya",
    ),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios_new_rounded),
    color: ColorPalette.primaryColor,
    onPressed: () => Navigator.pop(context),
  ),
),

      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is TourGuideRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Gửi yêu cầu thành công!')),
            );
            Navigator.pop(context);
          } else if (state is TourGuideRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAnimatedCard(
                    title: "Giới thiệu bản thân",
                    icon: Icons.person_outline,
                    child: TextFormField(
                      controller: _introController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Viết một đoạn giới thiệu ngắn gọn về bạn...",
                        border: InputBorder.none,
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Vui lòng nhập giới thiệu"
                          : null,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildAnimatedCard(
                    title: "Giá dịch vụ (VNĐ)",
                    icon: Icons.attach_money_rounded,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Nhập giá bạn muốn cung cấp...",
                        border: InputBorder.none,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Vui lòng nhập giá" : null,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  _buildCertificationSection(),

                  SizedBox(height: 5.h),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: state is UserLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<UserBloc>().add(
                                        SendTourGuideRequestEvent(
                                          introduction: _introController.text,
                                          price: double.tryParse(
                                                  _priceController.text) ??
                                              0,
                                          certifications: _certifications,
                                        ),
                                      );
                                }
                              },
                        icon: const Icon(Icons.send_rounded),
                        label: state is UserLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Gửi yêu cầu"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 1.8.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
        border: Border.all(color: ColorPalette.dividerColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    Gradients.defaultGradientBackground.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Icon(icon, size: 20.sp, color: Colors.white),
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  foreground: Paint()
                    ..shader =
                        Gradients.defaultGradientBackground.createShader(
                      const Rect.fromLTWH(0, 0, 200, 70),
                    ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          child,
        ],
      ),
    );
  }

  Widget _buildCertificationSection() {
    return _buildAnimatedCard(
      title: "Chứng chỉ",
      icon: Icons.workspace_premium_rounded,
      child: Column(
        children: [
          if (_certifications.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Text(
                "Chưa thêm chứng chỉ nào.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ..._certifications.asMap().entries.map(
                (entry) => Card(
                  margin: EdgeInsets.symmetric(vertical: 0.8.h),
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ShaderMask(
                      shaderCallback: (bounds) =>
                          Gradients.defaultGradientBackground.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: const Icon(Icons.card_membership,
                          color: Colors.white),
                    ),
                    title: Text(entry.value.name),
                    subtitle: Text(
                      entry.value.certificateUrl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _certifications.removeAt(entry.key);
                        });
                      },
                    ),
                  ),
                ),
              ),
          SizedBox(height: 1.h),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Thêm chứng chỉ"),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorPalette.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: ColorPalette.primaryColor,
            ),
            onPressed: _addCertificationDialog,
          ),
        ],
      ),
    );
  }

void _addCertificationDialog() {
  final nameController = TextEditingController();
  final urlController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (_, __, ___) => const SizedBox(),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.translate(
        offset: Offset(0, (1 - anim1.value) * 200),
        child: Opacity(
          opacity: anim1.value,
          child: Dialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          Gradients.defaultGradientBackground.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        "Thêm chứng chỉ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Input Tên chứng chỉ
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: ShaderMask(
                        shaderCallback: (bounds) =>
                            Gradients.defaultGradientBackground.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Icon(Icons.badge_outlined,
                            color: Colors.white),
                      ),
                      labelText: "Tên chứng chỉ",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Input Link chứng chỉ
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      prefixIcon: ShaderMask(
                        shaderCallback: (bounds) =>
                            Gradients.defaultGradientBackground.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child:
                            const Icon(Icons.link_rounded, color: Colors.white),
                      ),
                      labelText: "Link chứng chỉ (URL - Google Drive, web, ...)",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Nút hành động
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                          child: const Text("Hủy"),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final urlPattern =
                                r'^(https?:\/\/)?([\w\-]+\.)+[a-z]{2,6}\/?.*$';
                            final regExp = RegExp(urlPattern);

                            if (nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('⚠ Vui lòng nhập tên chứng chỉ')),
                              );
                              return;
                            }
                            if (urlController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('⚠ Vui lòng nhập link chứng chỉ')),
                              );
                              return;
                            }
                            if (!regExp.hasMatch(urlController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        '⚠ Link chứng chỉ không hợp lệ')),
                              );
                              return;
                            }

                            setState(() {
                              _certifications.add(Certification(
                                name: nameController.text,
                                certificateUrl: urlController.text,
                              ));
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: Gradients.defaultGradientBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              alignment: Alignment.center,
                              child: const Text(
                                "Thêm",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

}
