import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [0];
}

class MainDone extends MainState {
  final int currentScreen;
  const MainDone({required this.currentScreen});

  @override
  List<Object> get props => [currentScreen];
}
