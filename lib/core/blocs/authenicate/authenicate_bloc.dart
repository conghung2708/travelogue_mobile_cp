import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_event.dart';
import 'package:travelogue_mobile/core/repository/authenication_repository.dart';
import 'package:travelogue_mobile/core/utils/dialog/dialog_loading.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/main.dart';

import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_screen.dart';
import 'package:travelogue_mobile/representation/trip_plan/screens/my_trip_plan_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/new_password_screen.dart';


part 'authenicate_event.dart';
part 'authenicate_state.dart';

class AuthenicateBloc extends Bloc<AuthenicateEvent, AuthenicateState> {
  String userName = '';

  AuthenicateBloc() : super(AuthenicateInitial()) {
    on<OnCheckAccountEvent>(_onCheckAccount);
    on<LoginEvent>(_onLogin);
    on<LoginWithSocialEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<SendOTPEmailEvent>(_onSendOTP);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<ResetPasswordEvent>(_onResetPassword);
    on<SendContactSupportEvent>(_onSendSupport);
  }

  void _onCheckAccount(OnCheckAccountEvent event, Emitter emit) {
    final isLogin = _onAuthCheck();
    if (isLogin) {
      userName = UserLocal().getUser().fullName ?? '';
      emit(AuthenicateSuccess(userName: userName));
    } else {
      emit(AuthenicateFailed());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final success = await _login(event);
    AppBloc().initial();

    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop(); 
    }

    if (success) {
      debugPrint('✅ Login thành công! Redirect đến: ${event.redirectRoute}');

      final redirect = event.redirectRoute;
      const target = MainScreen.routeName;

      if (redirect == TourScreen.routeName) {
        AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 2)); 
      } else if (redirect == MyTripPlansScreen.routeName) {
        AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 1));
      } else {
        AppBloc.mainBloc
            .add(const OnChangeIndexEvent(indexChange: 0));
      }

      navigatorKey.currentState?.pushReplacementNamed(target);
      emit(AuthenicateSuccess(userName: userName));
    } else {
      emit(AuthenicateFailed());
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithSocialEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final success = await _loginGoogle(event);
    AppBloc().initial();

    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }

    if (success) {
      debugPrint(
          '✅ Google login thành công! Redirect đến: ${event.redirectRoute}');

      final redirect = event.redirectRoute;
      const target = MainScreen.routeName;

      if (redirect == TourScreen.routeName) {
        AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 2));
      } else if (redirect == MyTripPlansScreen.routeName) {
        AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 1));
      } else {
        AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 0));
      }

      navigatorKey.currentState?.pushReplacementNamed(target);
      emit(AuthenicateSuccess(userName: userName));
    } else {
      emit(AuthenicateFailed());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    await Future.delayed(const Duration(milliseconds: 1500));
    UserLocal().clearAccessToken();
    UserLocal().clearUser();
    Navigator.of(event.context).pop();
    AppBloc.mainBloc.add(const OnChangeIndexEvent(indexChange: 0));
    AppBloc().initial();
    emit(AuthenicateInitial());
  }

  Future<void> _onRegister(RegisterEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final (success, message) = await AuthenicationRepository().register(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (success) {
      event.handleRegisterSuccess().call();
    } else {
      event.handleRegisterFailed(message).call();
    }
  }

  Future<void> _onSendOTP(SendOTPEmailEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final (success, message) = await AuthenicationRepository().sendOTPEmail(
      email: event.email,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (!success) {
      print('❌ Send OTP failed: $message'); 
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _onVerifyOTP(VerifyOTPEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final (success, message) = await AuthenicationRepository().checkValidOTP(
      email: event.email,
      otp: event.otp,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (!success) {
      print('❌ OTP Verification Failed: $message');
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }
    if (event.isLogin) {
      event.onTapSuccess?.call();
    } else {
      Navigator.pushNamed(
        event.context,
        NewPasswordScreen.routeName,
        arguments: event.otp,
      );
    }
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final (success, message) = await AuthenicationRepository().resetPassword(
      email: event.email,
      otp: event.otp,
      password: event.password,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (!success) {
      print('❌ Reset Password Failed: $message');
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      if (!event.isLogin) {
        Navigator.popUntil(
            event.context, ModalRoute.withName('/edit_profile_screen'));
      }
    }
  }

  Future<void> _onSendSupport(
      SendContactSupportEvent event, Emitter emit) async {
    showDialogLoading(event.context);
    final (success, message) =
        await AuthenicationRepository().sendContactSupport(
      email: event.email,
      message: event.message,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (!success) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      event.onSendSuccess().call();
    }
  }

  Future<bool> _login(LoginEvent event) async {
    final (user, message) = await AuthenicationRepository().login(
      email: event.email,
      password: event.password,
    );
    if (Navigator.of(event.context).canPop()) {
      Navigator.of(event.context).pop();
    }
    if (user == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(message ?? 'Đăng nhập thất bại')),
      );
      return false;
    }
    userName = user.username ?? '';
    return true;
  }

  Future<bool> _loginGoogle(LoginWithSocialEvent event) async {
    try {
      await GoogleSignIn().signOut();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return false;
      }

      final (user, message) = await AuthenicationRepository().loginGoogle(
        token: await firebaseUser.getIdToken() ?? '',
        user: firebaseUser,
      );
      if (Navigator.of(event.context).canPop()) {
        Navigator.of(event.context).pop();
      }
      if (user == null) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(content: Text(message ?? 'Đăng nhập Google thất bại')),
        );
        return false;
      }
      userName = user.username ?? '';
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _onAuthCheck() {
    return UserLocal().getAccessToken.isNotEmpty &&
        UserLocal().getRefreshToken.isNotEmpty;
  }
}
