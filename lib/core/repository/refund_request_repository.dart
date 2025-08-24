import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/refund_request/refund_create_model.dart';
import 'package:travelogue_mobile/model/refund_request/refund_request_model.dart';

class RefundRepository {
  Future<String?> sendRefundRequest(RefundCreateModel model) async {
    print('[📤 REFUND REQUEST] Sending: ${model.toJson()}');
    try {
      final response = await BaseRepository().postRoute(
        gateway: Endpoints.createRefundRequest,
        data: model.toJson(),
      );
      print('[📥 REFUND RESPONSE] Status: ${response.statusCode}');
      if (response.statusCode == StatusCode.ok) return null;
      return response.data?['message']?.toString() ?? 'Yêu cầu thất bại';
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      return msg;
    } catch (e) {
      return e.toString();
    }
  }

  /// ✅ Trả về danh sách đã parse sẵn
  Future<List<RefundRequestModel>> getUserRefundRequests({
    DateTime? fromDate,
    DateTime? toDate,
    int? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (fromDate != null) queryParams['FromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['ToDate'] = toDate.toIso8601String();
      if (status != null) queryParams['Status'] = status;

      final response = await BaseRepository().getRoute(
        Endpoints.getUserRefundRequests,
        queryParameters: queryParams,
      );

      if (response.statusCode == StatusCode.ok) {
        final body = response.data;

        // Hỗ trợ cả 2 kiểu: [] hoặc { data: [] } / { items: [] }
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
            .map((e) => RefundRequestModel.fromJson(e))
            .toList();
      }

      throw Exception('Lỗi HTTP ${response.statusCode}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      throw Exception('GET refunds failed (${code ?? 'no-code'}): $msg');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// 🔎 Lấy chi tiết 1 refund theo id
  Future<RefundRequestModel> getRefundRequestDetail(String refundRequestId) async {
    try {
      final response = await BaseRepository().getRoute(
        '${Endpoints.refundRequest}/$refundRequestId',
      );

      if (response.statusCode == StatusCode.ok) {
        final body = response.data;

        // API mẫu trong ảnh: { data: { ... }, additionalData, message, succeeded, statusCode }
        Map<String, dynamic>? json;
        if (body is Map && body['data'] is Map) {
          json = (body['data'] as Map).cast<String, dynamic>();
        } else if (body is Map<String, dynamic>) {
          // Trong trường hợp backend trả thẳng object
          json = body;
        }

        if (json == null) {
          throw const FormatException('Dữ liệu trả về không hợp lệ');
        }

        return RefundRequestModel.fromJson(json);
      }

      throw Exception('Lỗi HTTP ${response.statusCode}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Lỗi kết nối';
      throw Exception('GET refund detail failed (${code ?? 'no-code'}): $msg');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
