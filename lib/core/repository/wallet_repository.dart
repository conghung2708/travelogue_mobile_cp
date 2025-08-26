// lib/core/repository/wallet_repository.dart
import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_create_model.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_model.dart';

class WalletRepository {
  Future<String?> createWithdrawalRequest(WithdrawalRequestCreateModel model) async {
    print('[📤 WITHDRAWAL REQUEST] Sending: ${model.toJson()}');
    try {
      final response = await BaseRepository().postRoute(
        gateway: Endpoints.withdrawalRequest,
        data: model.toJson(),
      );
      print('[📥 WITHDRAWAL RESPONSE] Status: ${response.statusCode}');
      if (response.statusCode == StatusCode.ok) return null;
      return response.data?['message']?.toString() ?? 'Yêu cầu rút tiền thất bại';
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      return msg;
    } catch (e) {
      return e.toString();
    }
  }

   Future<List<WithdrawalRequestModel>> getMyWithdrawalRequests({
    int? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (status != null) query['Status'] = status;
      if (fromDate != null) query['FromDate'] = fromDate.toIso8601String();
      if (toDate != null) query['ToDate'] = toDate.toIso8601String();

      final response = await BaseRepository().getRoute(
        Endpoints.myWithdrawalRequestsFilter,
        queryParameters: query,
      );

      if (response.statusCode == StatusCode.ok) {
        final body = response.data;

        List list;
        if (body is List) {
          list = body;
        } else if (body is Map && body['data'] is List) {
          list = body['data'] as List;
        } else if (body is Map && body['items'] is List) {
          list = body['items'] as List;
        } else {
          throw const FormatException('Dữ liệu trả về không phải danh sách');
        }

        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => WithdrawalRequestModel.fromJson(e))
            .toList();
      }

      throw Exception('Lỗi HTTP ${response.statusCode}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      throw Exception(
          'GET my-withdrawal-requests failed (${code ?? 'no-code'}): $msg');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
