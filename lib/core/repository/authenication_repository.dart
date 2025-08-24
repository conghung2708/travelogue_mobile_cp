import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/user_model.dart';

class AuthenicationRepository {
  Future<UserModel> fetchCurrentUser() async {
    final res = await BaseRepository().getRoute(Endpoints.getCurrentUser);

    if (res.statusCode == StatusCode.ok) {
      final data = res.data is Map ? res.data['data'] : null;
      if (data is Map<String, dynamic>) {
        final user = UserModel.fromMap(data);
        // lưu vào local cho toàn app dùng
        UserLocal().saveAccount(user);
        return user;
      }
      throw const FormatException('Dữ liệu user không hợp lệ');
    }
    throw Exception('HTTP ${res.statusCode}');
  }

  // chỉnh login: sau khi lưu token → gọi fetchCurrentUser()
  Future<(UserModel?, String?)> login({
    required String email,
    required String password,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == StatusCode.ok) {
      final dataJson = response.data['data'];
      final String token = dataJson['verificationToken'];
      final String refreshToken = dataJson['refreshTokens'];

      // lưu token trước
      UserLocal().saveAccessToken(token, refreshToken);

      // lấy full profile từ /get-current-user
      final user = await fetchCurrentUser();

      return (user, null);
    } else {
      final String message = response.data['Message'];
      return (null, message);
    }
  }

  Future<(bool, String)> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'fullName': fullName,
      'confirmPassword': password,
    };

    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.register,
      data: body,
    );

    if (response.statusCode == StatusCode.ok) {
      return (true, '');
    } else {
      final String message = response.data['Message'];
      return (false, message);
    }
  }

  Future<(bool, String)> sendOTPEmail({
    required String email,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.sendOTPEmail,
      data: {
        'email': email,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return (true, '');
    } else {
      final String message = response.data['Message'];
      print('🛑 sendOTPEmail failed with message: $message'); // 👈
      return (false, message);
    }
  }

  Future<(bool, String)> checkValidOTP({
    required String email,
    required String otp,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.checkValidOTP,
      data: {
        'token': otp,
        'email': email,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return (true, '');
    } else {
      final String message = response.data['Message'];
      return (false, message);
    }
  }

  Future<(bool, String)> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.resetPassword,
      data: {
        'token': otp,
        'email': email,
        'newPassword': password,
        'confirmPassword': password,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return (true, '');
    } else {
      final String message = response.data['Message'];
      return (false, message);
    }
  }

  // chỉnh loginGoogle tương tự
  Future<(UserModel?, String?)> loginGoogle({
    required String token,
    required User user,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.loginGoogle,
      data: {'token': token},
    );

    if (response.statusCode == StatusCode.ok) {
      final dataJson = response.data['data'];
      final String access = dataJson['verificationToken'];
      final String refresh = dataJson['refreshTokens'];

      UserLocal().saveAccessToken(access, refresh);

      final current = await fetchCurrentUser();
      // optional: update display name nếu cần
      final merged =
          current.copyWith(username: current.username ?? user.displayName);

      UserLocal().saveAccount(merged);
      return (merged, null);
    } else {
      final String message = response.data['message'];
      return (null, message);
    }
  }

  Future<(bool, String)> sendContactSupport({
    required String email,
    required String message,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.sendContactSupport,
      data: {
        'email': email,
        'message': message,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return (true, '');
    } else {
      final String message = response.data['Message'];
      return (false, message);
    }
  }
}
