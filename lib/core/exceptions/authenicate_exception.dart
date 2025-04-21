enum AuthenicationException {
  emailPasswordWrong('Tên đăng nhập hoặc mật khẩu không đúng'),
  accountUnconfirm('Tài khoản của bạn chưa được xác thực.'),
  accountBlocked('Tài khoản của bạn đã bị khóa.'),
  accountExisted('Người dùng đã tồn tại');

  /// Returns the [AuthenicationException] from the given code.
  const AuthenicationException(this.message);

  /// Code of the player state.
  final String message;

  String get description => switch (this) {
        AuthenicationException.emailPasswordWrong =>
          'Username or password is incorrect.',
        AuthenicationException.accountUnconfirm =>
          'Your account has not been verified.',
        AuthenicationException.accountBlocked =>
          'Your account has been locked.',
        AuthenicationException.accountExisted => 'Account has been existed',
      };
}

extension AuthenicationExceptionX on String {
  AuthenicationException get authenicationException {
    final int index = AuthenicationException.values.indexWhere((exception) {
      return exception.message == this;
    });

    if (index < 0) {
      return AuthenicationException.emailPasswordWrong;
    }

    return AuthenicationException.values[index];
  }
}
