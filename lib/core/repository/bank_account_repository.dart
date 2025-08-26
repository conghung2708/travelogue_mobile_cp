import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/bank_account/bank_account_model.dart';
class BankAccountRepository {

  Future<List<BankAccountModel>> getBankAccounts({String? userId}) async {
    try {
   
      final id = (userId != null && userId.isNotEmpty)
          ? userId
          : (UserLocal().getUser().id ?? '');

      final queryParams = <String, dynamic>{};
      if (id.isNotEmpty) queryParams['userId'] = id;

      final response = await BaseRepository().getRoute(
        Endpoints.bankAccount,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      if (response.statusCode == StatusCode.ok) {
        final body = response.data;

        if (body is List) {
          return body
              .whereType<Map<String, dynamic>>()
              .map(BankAccountModel.fromJson)
              .toList();
        } else if (body is Map && body['data'] is List) {
          return (body['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map(BankAccountModel.fromJson)
              .toList();
        } else {
          throw const FormatException('Dữ liệu trả về không phải danh sách');
        }
      }

      throw Exception('Lỗi HTTP ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Lỗi kết nối';
      throw Exception(msg);
    }
  }


 
  Future<String?> createBankAccount(CreateBankAccountModel model) async {
    try {
      final response = await BaseRepository().postRoute(
        gateway: Endpoints.bankAccount,
        data: model.toJson(),
      );

      if (response.statusCode == StatusCode.ok ||
          response.statusCode == StatusCode.created) {
        return null; 
      }
      return response.data?['message']?.toString() ?? 'Tạo tài khoản thất bại';
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Lỗi kết nối';
      return msg;
    } catch (e) {
      return e.toString();
    }
  }


    Future<String?> updateBankAccount({
    required String bankAccountId,
    required UpdateBankAccountModel model,
  }) async {
    try {
      final response = await BaseRepository().putRoute(
        gateway: '${Endpoints.bankAccount}/$bankAccountId',
        data: model.toJson(),
      );

      if (response.statusCode == StatusCode.ok) {
        return null;
      }
      return response.data?['message']?.toString() ?? 'Cập nhật tài khoản thất bại';
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      return msg;
    } catch (e) {
      return e.toString();
    }
  }
}
