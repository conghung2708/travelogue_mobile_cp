// lib/core/repository/bank_lookup_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:travelogue_mobile/model/bank_account/bank_lookup_models.dart';

class BankLookupRepository {
  final Dio _dio;

  static const String _apiKey    = '243d0133-27ee-413b-a006-1363e6c4629ekey';
  static const String _apiSecret = '9214afd9-f1bb-4b49-ba0c-f2e84c03d548secret';

  BankLookupRepository()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.banklookup.net',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
          ),
        )..interceptors.add(
            LogInterceptor(
              requestBody: true,
              responseBody: true,
              logPrint: (obj) {
                if (kDebugMode) debugPrint(obj.toString());
              },
            ),
          );

  Map<String, String> _headers() => {
        'x-api-key': _apiKey.trim(),
        'x-api-secret': _apiSecret.trim(),
        'Content-Type': 'application/json',
      };


  Future<List<BankLookupItem>> listBanks() async {
    try {
      final res = await _dio.get('/api/bank/list', options: Options(headers: _headers()));
      if (res.statusCode == 200 && res.data is Map && res.data['data'] is List) {
        return (res.data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(BankLookupItem.fromJson)
            .toList();
      }
      throw Exception('Không lấy được danh sách ngân hàng');
    } on DioException catch (e) {
      final msg = (e.response?.data is Map) ? e.response?.data['msg']?.toString() : null;
      if (e.response?.statusCode == 422 && msg == 'API_INFO_NOT_FOUND') {
        throw Exception('API key/secret không hợp lệ hoặc đã bị reset');
      }
      throw Exception(msg ?? e.message ?? 'Lỗi mạng');
    }
  }


  Future<String> verifyAccount({
    required String bankCode,
    required String accountNumber,
  }) async {
    print('📤 Lookup: bank=$bankCode, account=$accountNumber');

    try {
      final res = await _dio.post(
        '/api/bank/id-lookup-prod',
        options: Options(headers: _headers()),
        data: {'bank': bankCode, 'account': accountNumber},
      );

      if (res.statusCode == 200 && res.data?['success'] == true) {
        final name = res.data['data']?['ownerName']?.toString();
        if (name == null || name.isEmpty) throw Exception('Không nhận được tên chủ tài khoản');
        return name;
      }

      throw Exception(res.data?['msg']?.toString() ?? 'Xác thực thất bại');
    } on DioException catch (e) {
      final sc  = e.response?.statusCode;
      final map = e.response?.data is Map ? (e.response!.data as Map) : null;
      final msg = map?['msg']?.toString();

      if (sc == 422) {
        if (msg == 'API_INFO_NOT_FOUND') {
          throw Exception('API key/secret không hợp lệ hoặc đã bị reset');
        }
        throw Exception('Không tìm thấy tài khoản');
      }
      if (sc == 429) throw Exception('Quá nhiều yêu cầu, thử lại sau');
      if (sc == 402) throw Exception('Hết credit. Vui lòng nạp thêm');
      throw Exception(msg ?? e.message ?? 'Lỗi mạng');
    }
  }
}
