import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/notification/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> items;
  final bool hubConnected;
  const NotificationLoaded({required this.items, this.hubConnected = false});
  NotificationLoaded copyWith(
          {List<NotificationModel>? items, bool? hubConnected}) =>
      NotificationLoaded(
          items: items ?? this.items,
          hubConnected: hubConnected ?? this.hubConnected);
  @override
  List<Object?> get props => [items, hubConnected];
}

class NotificationFailure extends NotificationState {
  final String message;
  const NotificationFailure(this.message);
  @override
  List<Object?> get props => [message];
}
