// Dart imports:
import 'dart:async';
import 'dart:convert' as convert;

// Package imports:
import 'package:dio/dio.dart' as diox;

import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class BaseRepository {
  static diox.Dio dio = diox.Dio(
    diox.BaseOptions(
      baseUrl: 'https://travelogue.homes/',
      connectTimeout: const Duration(milliseconds: connectTimeOut),
      receiveTimeout: const Duration(milliseconds: receiveTimeOut),
      sendTimeout: const Duration(milliseconds: receiveTimeOut),
    ),
  ); // with default Options

  Future<diox.Response<dynamic>> postFormData(
    String gateway,
    diox.FormData formData,
  ) async {
    try {
      final response = await dio.post(
        gateway,
        data: formData,
        options: getOptions(),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );

      return response;
    } on diox.DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<diox.Response<dynamic>> putFormData(
    String gateway,
    diox.FormData formData,
  ) async {
    try {
      final response = await dio.put(
        gateway,
        data: formData,
        options: getOptions(),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );
      return response;
    } on diox.DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

 Future<diox.Response<dynamic>> postRoute({
  required String gateway,
  required Map<String, dynamic> data,
  String? query,
}) async {
  try {
    final Map<String, String> paramsObject = {};
    if (query != null) {
      query.split('&').forEach((element) {
        paramsObject[element.split('=')[0]] = element.split('=')[1];
      });
    }

    final response = await dio.post(
      gateway,
      data: convert.jsonEncode(data),
      options: getOptions(),
      queryParameters: query == null ? null : paramsObject,
    );
    return response;
  } on diox.DioException catch (exception) {
    return catchDioError(exception: exception, gateway: gateway);
  }
}

  Future<diox.Response<dynamic>> patchRoute(
    String gateway, {
    String? query,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0]] = element.split('=')[1];
        });
      }

      final response = await dio.patch(
        gateway,
        data: body == null ? null : convert.jsonEncode(body),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );
      return response;
    } on diox.DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }
Future<diox.Response<dynamic>> getRoute(
  String gateway, {
  Map<String, dynamic>? queryParameters,
}) async {
  try {
    final response = await dio.get(
      gateway,
      options: getOptions(),
      queryParameters: queryParameters,
    );
    return response;
  } on diox.DioException catch (exception) {
    return catchDioError(exception: exception, gateway: gateway);
  }
}

  Future<diox.Response<dynamic>> deleteRoute(
    String gateway, {
    String? params,
    String? query,
    Map<String, dynamic>? body,
    diox.FormData? formData,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0]] = element.split('=')[1];
        });
      }

      final response = await dio.delete(
        gateway,
        data: formData ?? (body == null ? null : convert.jsonEncode(body)),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );
      return response;
    } on diox.DioException catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  diox.Response catchDioError({
    required diox.DioException exception,
    required String gateway,
  }) {
    return diox.Response(
      requestOptions: diox.RequestOptions(path: gateway),
      statusCode: StatusCode.badGateway,
      statusMessage: "CATCH EXCEPTION DIO",
    );
  }

  diox.Options getOptions() {
    return diox.Options(
      validateStatus: (status) {
        // if (status == StatusCode.unauthorized &&
        //     UserLocal().getAccessToken().isNotEmpty) {
        //   UserLocal().clearAccessToken();
        //   showDialogLoading();
        //   AppBloc.authBloc.add(LogOutEvent());
        // }
        return true;
      },
      headers: getHeaders(),
    );
  }

  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer ${UserLocal().getAccessToken}',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }
  Future<diox.Response<dynamic>> putRoute({
  required String gateway,
  required Map<String, dynamic> data,
  String? query,
}) async {
  try {
    final Map<String, String> paramsObject = {};
    if (query != null) {
      query.split('&').forEach((element) {
        paramsObject[element.split('=')[0]] = element.split('=')[1];
      });
    }

    final response = await dio.put(
      gateway,
      data: convert.jsonEncode(data),
      options: getOptions(),
      queryParameters: query == null ? null : paramsObject,
    );
    return response;
  } on diox.DioException catch (exception) {
    return catchDioError(exception: exception, gateway: gateway);
  }
}

}

