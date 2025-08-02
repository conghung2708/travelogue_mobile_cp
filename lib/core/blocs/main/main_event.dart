import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class OnChangeIndexEvent extends MainEvent {
  final int indexChange;
  const OnChangeIndexEvent({required this.indexChange});

  @override
  List<Object> get props => [indexChange];
}
