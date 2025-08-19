// lib/core/repository/wallet_repository.dart
import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_create_model.dart';

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
}
