import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/notification/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final String userId;
  const GetNotificationsEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ConnectNotificationHub extends NotificationEvent {
  final String hubUrl;
  final String accessToken;
  final String? userId; 

  const ConnectNotificationHub({
    required this.hubUrl,
    required this.accessToken,
    this.userId,
  });

  @override
  List<Object?> get props => [hubUrl, accessToken, userId];
}

class NotificationReceivedEvent extends NotificationEvent {
  final NotificationModel notification;
  const NotificationReceivedEvent(this.notification);
  @override
  List<Object?> get props => [notification];
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String notificationId;
  const MarkNotificationReadEvent(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}
