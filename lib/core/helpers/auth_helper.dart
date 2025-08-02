import 'package:travelogue_mobile/data/data_local/user_local.dart';

bool isLoggedIn() {
  return UserLocal().getAccessToken.isNotEmpty &&
         UserLocal().getRefreshToken.isNotEmpty;
}
