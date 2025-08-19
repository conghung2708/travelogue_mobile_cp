// core/blocs/user/user_state.dart
part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {}
class UserLoading extends UserState {}
class TourGuideRequestSuccess extends UserState {}
class TourGuideRequestFailure extends UserState {
  final String error;
  const TourGuideRequestFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class GetUserByIdLoading extends UserState {}
class GetUserByIdSuccess extends UserState {
  final UserProfileModel user;
  const GetUserByIdSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class GetUserByIdFailure extends UserState {
  final String error;
  const GetUserByIdFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// 🔶 NEW
class UpdateUserProfileLoading extends UserState {}
class UpdateUserProfileSuccess extends UserState {
  final UserProfileModel user;
  const UpdateUserProfileSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class UpdateUserProfileFailure extends UserState {
  final String error;
  const UpdateUserProfileFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class UpdateAvatarLoading extends UserState {}
class UpdateAvatarSuccess extends UserState {
  final String avatarUrl;
  const UpdateAvatarSuccess(this.avatarUrl);
  @override
  List<Object?> get props => [avatarUrl];
}
class UpdateAvatarFailure extends UserState {
  final String error;
  const UpdateAvatarFailure(this.error);
  @override
  List<Object?> get props => [error];
}
