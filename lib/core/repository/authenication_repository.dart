import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/user_model.dart';

class AuthenicationRepository {
  Future<(UserModel?, String?)> login({
    required String email,
    required String password,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      final dataJson = response.data['data'];
      final String token = dataJson['verificationToken'];
      final String refreshToken = dataJson['refreshTokens'];

      final UserModel accountModel = UserModel.fromMap(dataJson);
      UserLocal().saveAccessToken(token, refreshToken);
      UserLocal().saveAccount(accountModel);
      return (accountModel, null);
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

  Future<(UserModel?, String?)> loginGoogle({
    required String token,
    required User user,
  }) async {
    final Response response = await BaseRepository().postRoute(
      gateway: Endpoints.loginGoogle,
      data: {
        'token': token,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      final dataJson = response.data['data'];
      final String token = dataJson['verificationToken'];
      final String refreshToken = dataJson['refreshTokens'];

      final UserModel accountModel = UserModel.fromMap(dataJson).copyWith(
        username: user.displayName,
      );
      UserLocal().saveAccessToken(token, refreshToken);
      UserLocal().saveAccount(accountModel);
      return (accountModel, null);
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
