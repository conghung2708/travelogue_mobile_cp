class StringHelper {
  String? formatUserName(String? username) {
    if (username == null) {
      return null;
    }
    final List<String> lstCharName = username.split(" ");

    return lstCharName.last;
  }
}

extension StringExtension on String {
  String get removeEmptyLines {
    return replaceAll(
      RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'),
      '\n',
    );
  }
}
