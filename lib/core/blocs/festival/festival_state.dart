part of 'festival_bloc.dart';

abstract class FestivalState {
  List<Object> get props => [<EventModel>[], int];
}

class FestivalInitial extends FestivalState {}

class FestivalSuccess extends FestivalState {
  final List<EventModel> festivals;
  final int monthCurrent;
  FestivalSuccess({
    required this.festivals,
    required this.monthCurrent,
  });

  @override
  List<Object> get props => [
        festivals,
        monthCurrent,
      ];
}
