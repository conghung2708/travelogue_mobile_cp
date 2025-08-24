part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class SendTourGuideRequestEvent extends UserEvent {
  final String introduction;
  final double price;
  final List<Certification> certifications;
  const SendTourGuideRequestEvent({
    required this.introduction,
    required this.price,
    required this.certifications,
  });
  @override
  List<Object?> get props => [introduction, price, certifications];
}

class GetUserByIdEvent extends UserEvent {
  final String id;
  const GetUserByIdEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// 🔶 NEW
class UpdateUserProfileEvent extends UserEvent {
  final String id;
  final String? phoneNumber;
  final String? fullName;
  final String? address;
  const UpdateUserProfileEvent({
    required this.id,
    this.phoneNumber,
    this.fullName,
    this.address,
  });
}

class UpdateAvatarEvent extends UserEvent {
  final File file;
  const UpdateAvatarEvent(this.file);
}