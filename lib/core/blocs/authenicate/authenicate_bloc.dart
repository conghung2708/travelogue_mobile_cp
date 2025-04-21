import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/main/main_bloc.dart';
import 'package:travelogue_mobile/core/repository/authenication_repository.dart';
import 'package:travelogue_mobile/core/utils/dialog/dialog_loading.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/user_model.dart';
import 'package:travelogue_mobile/representation/main_screen.dart';
import 'package:travelogue_mobile/representation/user/screens/new_password_screen.dart';

part 'authenicate_event.dart';
part 'authenicate_state.dart';

class AuthenicateBloc extends Bloc<AuthenicateEvent, AuthenicateState> {
  String userName = '';
  AuthenicateBloc() : super(AuthenicateInitial()) {
    on<AuthenicateEvent>((event, emit) async {
      if (event is OnCheckAccountEvent) {
        final bool isLogin = _onAuthCheck();
        if (isLogin) {
          userName = UserLocal().getUser().fullName ?? '';
          emit(AuthenicateSuccess(userName: userName));
        } else {
          emit(AuthenicateFailed());
        }
      }

      if (event is LoginEvent) {
        showDialogLoading(event.context);
        final bool isLoginSuccess = await _login(event);
        AppBloc().initial();
        if (isLoginSuccess) {
          Navigator.of(event.context).pushNamed(MainScreen.routeName);
          emit(AuthenicateSuccess(userName: userName));
        } else {
          emit(AuthenicateFailed());
        }
      }

      if (event is LoginWithSocialEvent) {
        showAboutDialog(context: event.context);
        final bool isLoginSuccess = await _loginGoogle(event);
        AppBloc().initial();
        if (isLoginSuccess) {
          Navigator.of(event.context).pushNamed(MainScreen.routeName);
          emit(AuthenicateSuccess(userName: userName));
        } else {
          emit(AuthenicateFailed());
        }
      }

      if (event is LogoutEvent) {
        showDialogLoading(event.context);
        await Future.delayed(const Duration(milliseconds: 1500));
        UserLocal().clearAccessToken();
        UserLocal().clearUser();
        Navigator.of(event.context).pop();
        AppBloc.mainBloc.add(
          OnChangeIndexEvent(
            indexChange: 0,
            context: event.context,
          ),
        );
        AppBloc().initial();
        emit(AuthenicateInitial());
      }

      if (event is RegisterEvent) {
        showDialogLoading(event.context);
        await _register(event);
      }

      if (event is SendOTPEmailEvent) {
        await _sendOTPEmail(event);
      }

      if (event is VerifyOTPEvent) {
        bool isVerifySuccess = await _verifyOTP(event);
        if (isVerifySuccess) {
          event.onTapSuccess?.call();
        }
      }

      if (event is ResetPasswordEvent) {
        await _resetPassword(event);
      }

      if (event is SendContactSupportEvent) {
        await _sendSupport(event);
      }
    });
  }

  // Private function

  Future<bool> _login(LoginEvent event) async {
    final (UserModel?, String?) data = await AuthenicationRepository().login(
      email: event.email,
      password: event.password,
    );

    Navigator.of(event.context).pop();

    if (data.$1 == null) {
      // Show message
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(data.$2 ?? '')),
      );
      return false;
    }

    userName = data.$1?.username ?? '';

    return true;
  }

  Future<void> _register(RegisterEvent event) async {
    final (bool, String) isRegisterSuccess =
        await AuthenicationRepository().register(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    );

    Navigator.of(event.context).pop();

    if (isRegisterSuccess.$1) {
      event.handleRegisterSuccess().call();
    } else {
      event.handleRegisterFailed(isRegisterSuccess.$2).call();
    }
  }

  Future<bool> _sendOTPEmail(SendOTPEmailEvent event) async {
    showDialogLoading(event.context);
    final (bool, String?) data = await AuthenicationRepository().sendOTPEmail(
      email: event.email,
    );

    Navigator.of(event.context).pop();

    if (!data.$1) {
      // Show message
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(data.$2 ?? '')),
      );
      return false;
    }

    return true;
  }

  Future<bool> _verifyOTP(VerifyOTPEvent event) async {
    showDialogLoading(event.context);
    final (bool, String?) data = await AuthenicationRepository().checkValidOTP(
      email: event.email,
      otp: event.otp,
    );

    Navigator.of(event.context).pop();

    if (!data.$1) {
      // Show message
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(data.$2 ?? '')),
      );
      return false;
    }

    if (event.isLogin) {
      return true;
    }
    Navigator.pushNamed(
      event.context,
      NewPasswordScreen.routeName,
      arguments: event.otp,
    );
    return true;
  }

  Future<bool> _resetPassword(ResetPasswordEvent event) async {
    showDialogLoading(event.context);
    final (bool, String?) data = await AuthenicationRepository().resetPassword(
      email: event.email,
      otp: event.otp,
      password: event.password,
    );

    Navigator.of(event.context).pop();

    if (!data.$1) {
      // Show message
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(data.$2 ?? '')),
      );
      return false;
    }
    if (event.isLogin) {
      return true;
    }
    Navigator.popUntil(
      event.context,
      ModalRoute.withName(
        '/edit_profile_screen',
      ),
    );
    return true;
  }

  Future<bool> _loginGoogle(LoginWithSocialEvent event) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential firebaseUserCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      if (firebaseUserCredential.user == null) {
        return false;
      }

      final (UserModel?, String?) data =
          await AuthenicationRepository().loginGoogle(
        token: await firebaseUserCredential.user!.getIdToken() ?? '',
        user: firebaseUserCredential.user!,
      );

      Navigator.of(event.context).pop();

      if (data.$1 == null) {
        // Show message
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(content: Text(data.$2 ?? '')),
        );
        return false;
      }

      userName = data.$1?.username ?? '';

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _sendSupport(SendContactSupportEvent event) async {
    showDialogLoading(event.context);
    final (bool, String?) data =
        await AuthenicationRepository().sendContactSupport(
      email: event.email,
      message: event.message,
    );

    Navigator.of(event.context).pop();

    if (!data.$1) {
      // Show message
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(content: Text(data.$2 ?? '')),
      );
    }

    event.onSendSuccess().call();
  }

  bool _onAuthCheck() {
    return UserLocal().getAccessToken.isNotEmpty &&
        UserLocal().getRefreshToken.isNotEmpty;
  }
}
