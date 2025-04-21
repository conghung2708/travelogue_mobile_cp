part of 'main_bloc.dart';

abstract class MainEvent {}

class OnChangeIndexEvent extends MainEvent {
  final int indexChange;
  final BuildContext context;
  OnChangeIndexEvent({
    required this.indexChange,
    required this.context,
  });
}
