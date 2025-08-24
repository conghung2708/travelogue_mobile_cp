  import 'package:hive/hive.dart';
  import 'package:travelogue_mobile/data/data_local/storage_key.dart';
  import 'package:travelogue_mobile/model/user_model.dart';

  class UserLocal {
    static String? _accessToken;
    final Box _box = Hive.box(StorageKey.boxUser);

    // ===== Tokens =====
    String get getAccessToken {
      _accessToken ??= _box.get(StorageKey.token);
      return _accessToken ?? '';
    }

    String get getRefreshToken => _box.get(StorageKey.refreshToken) ?? '';

    bool get isLoggedIn => getAccessToken.isNotEmpty;

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


    UserModel getUser() {
      final accountLocal = _box.get(StorageKey.account);
      if (accountLocal == null) return UserModel();
      return UserModel.fromJson(accountLocal);
    }

    void saveAccount(
      UserModel accountModel, {
      bool skipSaveAccount = false,
    }) {
      if (!skipSaveAccount) {
        _box.put(StorageKey.account, accountModel.toJson());
      }
    }

    void saveUser(UserModel user, {bool skipSave = false}) {
      saveAccount(user, skipSaveAccount: skipSave);
    }

    void patchUser({
      String? fullName,
      String? phoneNumber,
      String? address,
      String? avatarUrl,
    }) {
      final current = getUser();
      final merged = current.copyWith(
        fullName: fullName ?? current.fullName,
        phoneNumber: phoneNumber ?? current.phoneNumber,
        address: address ?? current.address,
        avatarUrl: avatarUrl ?? current.avatarUrl,
      );
      saveUser(merged);
    }

    void clearUser() {
      _box.delete(StorageKey.account);
    }
  }
