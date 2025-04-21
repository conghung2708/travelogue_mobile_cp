part of 'festival_bloc.dart';

abstract class FestivalEvent {}

class GetAllFestivalEvent extends FestivalEvent {}

class FilterFestivalEvent extends FestivalEvent {
  final int month;
  FilterFestivalEvent({required this.month});
}
