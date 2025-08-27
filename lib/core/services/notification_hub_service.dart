import 'package:signalr_core/signalr_core.dart';

typedef NotificationHandler = void Function(Map<String, dynamic> data);

class NotificationHubService {
  HubConnection? _conn;

  Future<void> connect({
    required String hubUrl, // https://travelogue.homes/notificationHub
    required String accessToken, // JWT
    required NotificationHandler onNotification,
  }) async {
    print("🔗 SignalR: đang khởi tạo kết nối tới $hubUrl ...");

    _conn = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
          ),
        )
        .withAutomaticReconnect() 
        .build();

    
    _conn!.on('ReceiveNotification', (args) {
      print("📨 SignalR: nhận raw args = $args");
      if (args != null && args.isNotEmpty) {
        try {
          final first = args.first;
          if (first is Map) {
            print("✅ SignalR: parse Map notification");
            onNotification(Map<String, dynamic>.from(first));
          } else {
            print("✅ SignalR: parse String notification");
            onNotification({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': 'Thông báo',
              'content': first.toString(),
              'createdAt': DateTime.now().toIso8601String(),
              'isRead': false,
            });
          }
        } catch (err) {
          print("❌ SignalR parse error: $err");
        }
      }
    });

    _conn!.onclose((error) {
      print("❌ SignalR closed: $error");
    });

    _conn!.onreconnecting((error) {
      print("♻️ SignalR reconnecting... $error");
    });

    _conn!.onreconnected((id) {
      print("🔄 SignalR reconnected, connId=$id");
    });

    // Start kết nối
    await _conn!.start();
    print("✅ SignalR connected tới $hubUrl");
  }

  Future<void> disconnect() async {
    print("🔌 SignalR: disconnect...");
    await _conn?.stop();
    _conn = null;
    print("❎ SignalR disconnected");
  }

  bool get isConnected => _conn?.state == HubConnectionState.connected;
}
