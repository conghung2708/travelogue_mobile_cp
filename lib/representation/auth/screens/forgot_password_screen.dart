import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/authenicate/authenicate_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/representation/auth/widgets/email_step_form.dart';
import 'package:travelogue_mobile/representation/auth/widgets/otp_code_input.dart';
import 'package:travelogue_mobile/representation/auth/widgets/reset_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = '/forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isCodeStep = false;
  bool _isResetStep = false;

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      AppBloc.authenicateBloc.add(
        SendOTPEmailEvent(
          email: _emailController.text.trim(),
          context: context,
          isLogin: true,
        ),
      );
      setState(() {
        _isCodeStep = true;
      });
    }
  }

  void _submitCode() {
    final code = _codeControllers.map((c) => c.text).join();
    AppBloc.authenicateBloc.add(
      VerifyOTPEvent(
        email: _emailController.text.trim(),
        otp: code,
        context: context,
        isLogin: true,
        onTapSuccess: () {
          setState(
            () {
              _isResetStep = true;
            },
          );
        },
      ),
    );
  }

  void _resetPassword() {
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu phải từ 6 ký tự trở lên")),
      );
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu không khớp")),
      );
      return;
    }
    final code = _codeControllers.map((c) => c.text).join();
    AppBloc.authenicateBloc.add(
      ResetPasswordEvent(
        email: _emailController.text.trim(),
        otp: code,
        password: _newPasswordController.text.trim(),
        context: context,
        isLogin: true,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đặt lại mật khẩu thành công")),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            const Text("Quên mật khẩu", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AssetHelper.img_tay_ninh_login,
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5.w),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: !_isCodeStep
                          ? EmailStepForm(
                              emailController: _emailController,
                              formKey: _formKey,
                              onSubmit: _nextStep,
                            )
                          : !_isResetStep
                              ? OtpCodeInput(
                                  controllers: _codeControllers,
                                  focusNodes: _focusNodes,
                                  onSubmit: _submitCode,
                                )
                              : ResetPasswordForm(
                                  newPasswordController: _newPasswordController,
                                  confirmPasswordController:
                                      _confirmPasswordController,
                                  onSubmit: _resetPassword,
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
