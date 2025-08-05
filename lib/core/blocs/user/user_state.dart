part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}
final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class TourGuideRequestSuccess extends UserState {}

class TourGuideRequestFailure extends UserState {
  final String error;
  const TourGuideRequestFailure(this.error);

  @override
  List<Object> get props => [error];
}