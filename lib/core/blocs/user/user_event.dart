part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
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
  List<Object> get props => [introduction, price, certifications];
}
