import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/utils/validator_utils.dart';
import 'package:travelogue_mobile/representation/auth/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRememberMe = false;
  bool _isRegisterMode = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  int _selectedSex = 1;
  final _formKey = GlobalKey<FormState>();

  late String? _redirectRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _redirectRoute = args != null && args['redirectRoute'] is String
        ? args['redirectRoute'] as String
        : null;
  }

  void _toggleAuthMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      if (!_isRegisterMode) {
        _formKey.currentState?.reset();
        _fullNameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_isRegisterMode) {
        if (_formKey.currentState!.validate()) {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mật khẩu xác nhận không khớp!')),
            );
            return;
          }
          AppBloc.authenicateBloc.add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              fullName: _fullNameController.text.trim(),
              sex: _selectedSex,
              handleRegisterSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đăng ký thành công!')),
                );
              },
              handleRegisterFailed: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value)),
                );
              },
              context: context,
            ),
          );

          setState(() {
            _isRegisterMode = false;
            _formKey.currentState?.reset();
          });
        }
      } else {
        AppBloc.authenicateBloc.add(
          LoginEvent(
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            redirectRoute: _redirectRoute,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AssetHelper.img_tay_ninh_login,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AssetHelper.img_logo_travelogue,
                  height: 40.w,
                  width: 40.w,
                ),
                Text(
                  "Chào mừng bạn!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                ),
                Text(
                  "Cùng Travelogue khám phá Tây Ninh – vùng đất của những trải nghiệm tuyệt vời!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                ),
                SizedBox(height: 3.h),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.w),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.w),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    axisAlignment: -1,
                                    child: child,
                                  );
                                },
                                child: _isRegisterMode
                                    ? Column(
                                        key: const ValueKey('fullNameField'),
                                        children: [
                                          TextFormField(
                                            controller: _fullNameController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Iconsax.user,
                                                  color: ColorPalette
                                                      .primaryColor),
                                              hintText: "Họ và tên",
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.5),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.w),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_isRegisterMode &&
                                                  (value == null ||
                                                      value.trim().isEmpty)) {
                                                return 'Vui lòng nhập họ và tên';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 2.h),
                                          DropdownButtonFormField<int>(
                                            value: _selectedSex,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Iconsax.user_tag,
                                                  color: ColorPalette
                                                      .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.w),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 1, child: Text("Nam")),
                                              DropdownMenuItem(
                                                  value: 2, child: Text("Nữ")),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSex = value ?? 1;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 2.h),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Iconsax.direct_right,
                                      color: ColorPalette.primaryColor),
                                  hintText: "E-Mail",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                ),
                                validator: (value) {
                                  return ValidatorUtils.emailValidator(value);
                                },
                              ),
                              SizedBox(height: 2.h),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Iconsax.password_check,
                                      color: ColorPalette.primaryColor),
                                  hintText: "Mật khẩu",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                      color: Colors.grey[900],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  } else if (value.length < 6) {
                                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                                  }
                                  return null;
                                },
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _isRegisterMode
                                    ? Column(
                                        key: const ValueKey(1),
                                        children: [
                                          SizedBox(height: 2.h),
                                          TextFormField(
                                            controller:
                                                _confirmPasswordController,
                                            obscureText:
                                                !_isConfirmPasswordVisible,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Iconsax.password_check,
                                                  color: ColorPalette
                                                      .primaryColor),
                                              hintText: "Xác nhận mật khẩu",
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.5),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isConfirmPasswordVisible
                                                      ? Iconsax.eye
                                                      : Iconsax.eye_slash,
                                                  color: Colors.grey[900],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isConfirmPasswordVisible =
                                                        !_isConfirmPasswordVisible;
                                                  });
                                                },
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.w),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (_isRegisterMode) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Vui lòng xác nhận mật khẩu';
                                                } else if (value !=
                                                    _passwordController.text) {
                                                  return 'Mật khẩu không khớp';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              SizedBox(height: 2.h),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: !_isRegisterMode
                                    ? Row(
                                        key: const ValueKey(2),
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isRememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isRememberMe = value!;
                                                  });
                                                },
                                                activeColor:
                                                    ColorPalette.primaryColor,
                                              ),
                                              Text("Ghi nhớ mật khẩu",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp)),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  ForgotPasswordScreen
                                                      .routeName);
                                            },
                                            child: Text(
                                              "Quên mật khẩu?",
                                              style: TextStyle(
                                                  color:
                                                      ColorPalette.primaryColor,
                                                  fontSize: 14.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (_isRegisterMode) {
                                      setState(() {
                                        _isRegisterMode = false;
                                        _formKey.currentState?.reset();
                                      });
                                    } else {
                                      _submitForm();
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _isRegisterMode
                                        ? Colors.transparent
                                        : ColorPalette.primaryColor,
                                    side: BorderSide(
                                      color: ColorPalette.primaryColor,
                                      width: 1.2.sp,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.w),
                                    ),
                                  ),
                                  child: Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: _isRegisterMode
                                          ? ColorPalette.primaryColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (!_isRegisterMode) {
                                      setState(() {
                                        _isRegisterMode = true;
                                        _formKey.currentState?.reset();
                                      });
                                    } else {
                                      _submitForm();
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _isRegisterMode
                                        ? ColorPalette.primaryColor
                                        : Colors.transparent,
                                    side: BorderSide(
                                      color: ColorPalette.primaryColor,
                                      width: 1.2.sp,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.w),
                                    ),
                                  ),
                                  child: Text(
                                    "Đăng ký",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: _isRegisterMode
                                          ? Colors.white
                                          : ColorPalette.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        "Hoặc đăng nhập với",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp),
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1)),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    AppBloc.authenicateBloc.add(
                      LoginWithSocialEvent(
                        context: context,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AssetHelper.icon_google,
                      height: 6.w,
                      width: 6.w,
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isRegisterMode
                        ? "Bạn đã có tài khoản? Đăng nhập ngay!"
                        : "Bạn chưa có tài khoản? Đăng ký ngay!",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorPalette.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
