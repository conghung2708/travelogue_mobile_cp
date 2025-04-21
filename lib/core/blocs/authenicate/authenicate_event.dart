// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authenicate_bloc.dart';

abstract class AuthenicateEvent {}

class OnCheckAccountEvent extends AuthenicateEvent {}

class LoginEvent extends AuthenicateEvent {
  final String email;
  final String password;
  BuildContext context;
  LoginEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class LogoutEvent extends AuthenicateEvent {
  final BuildContext context;
  LogoutEvent({required this.context});
}

class RegisterEvent extends AuthenicateEvent {
  final String email;
  final String password;
  final String fullName;
  final Function() handleRegisterSuccess;
  final Function(String) handleRegisterFailed;
  final BuildContext context;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.handleRegisterSuccess,
    required this.handleRegisterFailed,
    required this.context,
  });
}

class SendOTPEmailEvent extends AuthenicateEvent {
  final String email;
  final BuildContext context;
  final bool isLogin;

  SendOTPEmailEvent({
    required this.email,
    required this.context,
    this.isLogin = false,
  });
}

class VerifyOTPEvent extends AuthenicateEvent {
  final String email;
  final String otp;
  final BuildContext context;
  final Function()? onTapSuccess;
  final bool isLogin;
  VerifyOTPEvent({
    required this.email,
    required this.otp,
    required this.context,
    this.onTapSuccess,
    this.isLogin = false,
  });
}

class ResetPasswordEvent extends AuthenicateEvent {
  final String email;
  final String otp;
  final String password;
  final BuildContext context;
  final bool isLogin;
  ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.password,
    required this.context,
    this.isLogin = false,
  });
}

class LoginWithSocialEvent extends AuthenicateEvent {
  final BuildContext context;
  LoginWithSocialEvent({
    required this.context,
  });
}

class SendContactSupportEvent extends AuthenicateEvent {
  final String email;
  final String message;
  final Function() onSendSuccess;
  final BuildContext context;
  SendContactSupportEvent(
    this.context, {
    required this.email,
    required this.message,
    required this.onSendSuccess,
  });
}
