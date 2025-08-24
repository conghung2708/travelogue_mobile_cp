import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/report/report_review_request.dart';
import 'package:travelogue_mobile/model/report/report_model.dart';

class ReportRepository {
  Future<({bool ok, String? message})> submitReport(ReportReviewRequest req) async {
    final res = await BaseRepository().postRoute(
      gateway: Endpoints.reportReview,
      data: req.toJson(),
    );
    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final m = Map<String, dynamic>.from(res.data as Map);
      final ok = (m['succeeded'] ?? m['Succeeded'] ?? true) == true;
      final msg = (m['message'] ?? m['Message'])?.toString();
      return (ok: ok, message: msg);
    }
    final msg = (res.data is Map) ? ((res.data['message'] ?? res.data['Message'])?.toString()) : null;
    return (ok: false, message: msg ?? 'Gửi báo cáo thất bại.');
  }

  // NEW: GET /api/report/my-reports
  Future<List<ReportModel>> getMyReports() async {
    final res = await BaseRepository().getRoute(Endpoints.getMyReports);

    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final data = (res.data['data']);
      if (data is List) {
        return data.map((e) => ReportModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    }
    return <ReportModel>[];
  }

  // NEW: PUT /api/report/{id}
  Future<({bool ok, String? message})> updateReport({
    required String reportId,
    required String reason,
  }) async {
    final res = await BaseRepository().putRoute(
      gateway: Endpoints.updateReport(reportId),
      data: {'reason': reason},
    );

    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final m = Map<String, dynamic>.from(res.data as Map);
      final ok = (m['succeeded'] ?? m['Succeeded'] ?? true) == true;
      final msg = (m['message'] ?? m['Message'])?.toString();
      return (ok: ok, message: msg);
    }
    final msg = (res.data is Map) ? ((res.data['message'] ?? res.data['Message'])?.toString()) : null;
    return (ok: false, message: msg ?? 'Cập nhật báo cáo thất bại.');
  }

  // NEW: DELETE /api/report/{id}
  Future<({bool ok, String? message})> deleteReport(String reportId) async {
    final res = await BaseRepository().deleteRoute(
      gateway: Endpoints.deleteReport(reportId),
    );

    if (res.statusCode == StatusCode.ok && res.data is Map) {
      final m = Map<String, dynamic>.from(res.data as Map);
      final ok = (m['succeeded'] ?? m['Succeeded'] ?? true) == true;
      final msg = (m['message'] ?? m['Message'])?.toString();
      return (ok: ok, message: msg);
    }
    final msg = (res.data is Map) ? ((res.data['message'] ?? res.data['Message'])?.toString()) : null;
    return (ok: false, message: msg ?? 'Xoá báo cáo thất bại.');
  }
}
