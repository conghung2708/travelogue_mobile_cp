

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/notification/notification_event.dart';
import 'package:travelogue_mobile/core/blocs/notification/notification_state.dart';
import 'package:travelogue_mobile/core/repository/notification_repository.dart';
import 'package:travelogue_mobile/core/services/notification_hub_service.dart';
import 'package:travelogue_mobile/model/notification/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repo;
  final NotificationHubService hub;

  NotificationBloc(this.repo, this.hub) : super(NotificationInitial()) {
    on<GetNotificationsEvent>(_onGetAll);
    on<ConnectNotificationHub>(_onConnectHub);
    on<NotificationReceivedEvent>(_onReceived);
    on<MarkNotificationReadEvent>(_onMarkRead);
  }

  Future<void> _onGetAll(
    GetNotificationsEvent e,
    Emitter<NotificationState> emit,
  ) async {
    final prev = state;
    if (prev is! NotificationLoaded) {
      emit(NotificationLoading());
    }

    try {
      final List<NotificationModel> items = await repo.getByUser(e.userId);
      final bool hubConnected =
          prev is NotificationLoaded ? (prev.hubConnected) : false;

      emit(NotificationLoaded(items: items, hubConnected: hubConnected));
      print("📥 Bloc: Loaded ${items.length} notifications cho user ${e.userId}");
    } catch (err) {
      emit(NotificationFailure('Tải danh sách thông báo thất bại: $err'));
    }
  }


  Future<void> _onConnectHub(
    ConnectNotificationHub e,
    Emitter<NotificationState> emit,
  ) async {
    try {
      print("▶️ Bloc: ConnectNotificationHub (userId=${e.userId ?? '-'})");
      await hub.connect(
        hubUrl: e.hubUrl, 
        accessToken: e.accessToken,
        onNotification: (map) {
          try {
            final model = NotificationModel.fromJson(map);
            add(NotificationReceivedEvent(model));
          } catch (err) {
            print("❌ Bloc: Parse NotificationModel.fromJson lỗi: $err");
          }
        },
      );

      final prev = state is NotificationLoaded ? state as NotificationLoaded : null;
      emit(NotificationLoaded(items: prev?.items ?? const <NotificationModel>[], hubConnected: true));
      print("✅ Bloc: Hub connected -> hubConnected=true");

      if (e.userId != null && e.userId!.isNotEmpty) {
        print("📥 Bloc: Tự load notifications sau khi connect cho user ${e.userId}");
        add(GetNotificationsEvent(e.userId!));
      }
    } catch (err) {
      emit(NotificationFailure('Kết nối SignalR thất bại: $err'));
    }
  }

  Future<void> _onReceived(
    NotificationReceivedEvent e,
    Emitter<NotificationState> emit,
  ) async {
    print("📩 Bloc: Notification mới nhận được");
    print("   ➡️ ID: ${e.notification.id}");
    print("   ➡️ Title: ${e.notification.title}");
    print("   ➡️ Content: ${e.notification.content}");
    print("   ➡️ CreatedAt: ${e.notification.createdAt}");
    print("   ➡️ IsRead: ${e.notification.isRead}");

    final prev = state is NotificationLoaded ? state as NotificationLoaded : null;

    final List<NotificationModel> items = <NotificationModel>[
      e.notification,
      ...(prev?.items ?? const <NotificationModel>[])
    ];

    emit(NotificationLoaded(
      items: items,
      hubConnected: prev?.hubConnected ?? true,
    ));
  }


  Future<void> _onMarkRead(
    MarkNotificationReadEvent e,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationLoaded) return;
    final loaded = state as NotificationLoaded;

    final ok = await repo.markAsRead(e.notificationId);
    if (!ok) {
      print("⚠️ Bloc: markAsRead thất bại cho id=${e.notificationId}");
      return;
    }

    final updated = loaded.items
        .map((n) => n.id == e.notificationId ? n.copyWith(isRead: true) : n)
        .toList();

    emit(loaded.copyWith(items: updated));
    print("✅ Bloc: markAsRead thành công cho id=${e.notificationId}");
  }
}
