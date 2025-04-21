part of 'main_bloc.dart';

abstract class MainState {
  List<Object> get props => [int];
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [0];
}

class MainDone extends MainState {
  final int currentScreen;
  MainDone({required this.currentScreen});

  @override
  List<Object> get props => [currentScreen];
}
