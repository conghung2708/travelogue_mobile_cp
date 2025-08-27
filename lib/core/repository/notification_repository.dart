import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/notification/notification_model.dart';

class NotificationRepository {
Future<List<NotificationModel>> getByUser(String userId) async {
  final res = await BaseRepository().getRoute('${Endpoints.getNotifications}/$userId');
  print("📡 API Notifications raw: ${res.data}");

  final List<NotificationModel> result = [];

  if (res.statusCode == StatusCode.ok) {
    final dynamic raw = res.data is Map ? res.data['data'] : res.data;
    if (raw is List) {
      for (var e in raw) {
        try {
          final parsed = NotificationModel.fromJson(
            (e ?? const {}) as Map<String, dynamic>,
          );
          print("✅ Parsed notification: ${parsed.id} | ${parsed.title}");
          result.add(parsed);
        } catch (err, st) {
          print("❌ Parse error for item $e \n$err\n$st");
        }
      }
    }
  }

  print("📥 Repo: Loaded ${result.length} notifications cho user $userId");
  return result;
}


  Future<bool> markAsRead(String notificationId) async {
    final res = await BaseRepository()
        .putRoute(gateway: '${Endpoints.getNotifications}/$notificationId/read');
    return res.statusCode == StatusCode.ok;
  }
}
