import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/model/user_model.dart';

class UserLocal {
  static String? _accessToken;

  final Box _box = Hive.box(StorageKey.boxUser);

  // User
  String get getAccessToken {
    _accessToken ??= _box.get(StorageKey.token);

    return _accessToken ?? '';
  }

  String get getRefreshToken {
    return _box.get(StorageKey.refreshToken) ?? '';
  }

  UserModel getUser() {
    final accountLocal = _box.get(StorageKey.account);
    if (accountLocal == null) {
      return UserModel();
    }

    return UserModel.fromJson(accountLocal);
  }

  void saveAccessToken(String accessToken, String refreshToken) {
    _box.put(StorageKey.token, accessToken);
    _box.put(StorageKey.refreshToken, refreshToken);

    _accessToken = accessToken;
  }

  void clearAccessToken() {
    _accessToken = null;
    _box.delete(StorageKey.token);
    _box.delete(StorageKey.refreshToken);
  }

  void clearUser() {
    _box.delete(StorageKey.account);
  }

  void saveAccount(
    UserModel accountModel, {
    bool skipSaveAccount = false,
  }) {
    if (!skipSaveAccount) {
      _box.put(StorageKey.account, accountModel.toJson());
    }
  }
}
