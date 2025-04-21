part of 'authenicate_bloc.dart';

abstract class AuthenicateState {
  List<Object> get props => [String];
}

class AuthenicateInitial extends AuthenicateState {
  @override
  List<Object> get props => [''];
}

class AuthenicateSuccess extends AuthenicateState {
  final String userName;

  AuthenicateSuccess({required this.userName});
  @override
  List<Object> get props => [userName];
}

class AuthenicateFailed extends AuthenicateState {
  @override
  List<Object> get props => [''];
}
