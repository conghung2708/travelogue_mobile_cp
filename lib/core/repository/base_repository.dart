
import 'dart:async';
import 'dart:convert' as convert;


import 'package:dio/dio.dart' as diox;

import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';

class BaseRepository {
  BaseRepository._internal();
  static final BaseRepository _instance = BaseRepository._internal();
  factory BaseRepository() => _instance;

  static final diox.Dio dio = diox.Dio(
    diox.BaseOptions(
      baseUrl: 'https://travelogue.homes/', 
      connectTimeout: const Duration(milliseconds: connectTimeOut),
      receiveTimeout: const Duration(milliseconds: receiveTimeOut),
      sendTimeout: const Duration(milliseconds: receiveTimeOut),
      validateStatus: (_) => true,
    ),
  )..interceptors.add(
      diox.LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );


  String _normalize(String path) => path.startsWith('/') ? path : '/$path';


  Future<diox.Response> getRoute(String gateway,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(
        _normalize(gateway),
        options: _getOptions(),
        queryParameters: queryParameters,
      );
    } on diox.DioException catch (e) {
      return _catchDioError(e);
    }
  }


Future<diox.Response> postRoute({
  required String gateway,
  dynamic data, 
  String? query,
}) async {
  try {
    final paramsObject = _parseQuery(query);
    final hasBody = data != null;
    return await dio.post(
      _normalize(gateway),
      data: hasBody ? convert.jsonEncode(data) : null,
      options: _getOptions(hasBody: hasBody),
      queryParameters: paramsObject,
    );
  } on diox.DioException catch (e) {
    return _catchDioError(e);
  }
}

Future<diox.Response> putRoute({
  required String gateway,
  dynamic data, 
  String? query,
}) async {
  try {
    final paramsObject = _parseQuery(query);
    final hasBody = data != null;
    return await dio.put(
      _normalize(gateway),
      data: hasBody ? convert.jsonEncode(data) : null,
      options: _getOptions(hasBody: hasBody),
      queryParameters: paramsObject,
    );
  } on diox.DioException catch (e) {
    return _catchDioError(e);
  }
}

  Future<diox.Response> patchRoute(
    String gateway, {
    String? query,
    Map<String, dynamic>? body,
  }) async {
    try {
      final paramsObject = _parseQuery(query);
      return await dio.patch(
        _normalize(gateway),
        data: body == null ? null : convert.jsonEncode(body),
        options: _getOptions(),
        queryParameters: paramsObject,
      );
    } on diox.DioException catch (e) {
      return _catchDioError(e);
    }
  }

Future<diox.Response> deleteRoute({
  required String gateway,
  String? query,
  Map<String, dynamic>? body,
  diox.FormData? formData,
}) async {
  try {
    final paramsObject = _parseQuery(query);
    return await dio.delete(
      _normalize(gateway),
      data: formData ?? (body == null ? null : convert.jsonEncode(body)),
      options: _getOptions(),
      queryParameters: paramsObject,
    );
  } on diox.DioException catch (e) {
    return _catchDioError(e);
  }
}

Future<diox.Response> postFormData(String gateway, diox.FormData formData) async {
  try {
    return await dio.post(
      _normalize(gateway),
      data: formData,
      options: _getOptions(isMultipart: true), 
    );
  } on diox.DioException catch (e) {
    return _catchDioError(e);
  }
}

  Future<diox.Response> putFormData(
      String gateway, diox.FormData formData) async {
    try {
      return await dio.put(
        _normalize(gateway),
        data: formData,
        options: _getOptions(isMultipart: true),
      );
    } on diox.DioException catch (e) {
      return _catchDioError(e);
    }
  }

 
  diox.Response _catchDioError(diox.DioException e) {
    print('🔥 DioException.type: ${e.type}');
    print('🔥 Message: ${e.message}');
    print('🔥 URL: ${e.requestOptions.uri}');

    if (e.response != null) {
      final r = e.response!;
      print('🔥 Resp status: ${r.statusCode}');
      print('🔥 Resp data: ${r.data}');
      return r;
    }

    final code = _mapDioTypeToStatus(e.type);
    return diox.Response(
      requestOptions: e.requestOptions,
      statusCode: code,
      statusMessage: e.message,
      data: {
        'error': 'network_error',
        'message': e.message,
        'type': e.type.toString(),
      },
    );
  }

  int _mapDioTypeToStatus(diox.DioExceptionType type) {
    switch (type) {
      case diox.DioExceptionType.connectionTimeout:
      case diox.DioExceptionType.receiveTimeout:
      case diox.DioExceptionType.sendTimeout:
        return StatusCode.requestTimeout;
      case diox.DioExceptionType.badCertificate:
        return 495;
      case diox.DioExceptionType.connectionError:
        return 503;
      case diox.DioExceptionType.cancel:
        return 499;
      default:
        return 520;
    }
  }

diox.Options _getOptions({bool isMultipart = false, bool hasBody = false}) {
  return diox.Options(
    validateStatus: (_) => true,
    headers: _getHeaders(isMultipart: isMultipart, hasBody: hasBody),
    receiveDataWhenStatusError: true,
  );
}
  Map<String, dynamic>? _parseQuery(String? query) {
    if (query == null || query.isEmpty) return null;
    final map = <String, String>{};
    for (final element in query.split('&')) {
      final kv = element.split('=');
      if (kv.length == 2) map[kv[0]] = kv[1];
    }
    return map;
  }


Map<String, String> _getHeaders({bool isMultipart = false, bool hasBody = false}) {
  final token = _readToken();
  final headers = <String, String>{
    'Accept': '*/*',
    'Connection': 'keep-alive',
  };

  if (isMultipart) {
    headers['Content-Type'] = 'multipart/form-data';
  } else if (hasBody) {
    headers['Content-Type'] = 'application/json; charset=UTF-8';
  }


  if (token != null) headers['Authorization'] = 'Bearer $token';
  return headers;
}

  String? _readToken() {
    try {
      final dynamic v = UserLocal().getAccessToken;
      if (v is String) {
        return (v.isEmpty || v == 'null') ? null : v;
      }
      if (v is String Function()) {
        final token = v();
        return (token.isEmpty || token == 'null') ? null : token;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
