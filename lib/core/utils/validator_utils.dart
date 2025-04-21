class ValidatorUtils {
  /// Checks if string is email.
  static bool isEmail(String s) => RegExp(
        r'^([a-zA-Z]|\d|[%\+\-_.])+@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      ).hasMatch(s);

  static String? emailValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return 'Email cannot be empty';
    }

    if (isEmail(val!.trim())) {
      return null;
    }

    return 'Invalid Email';
  }
}
