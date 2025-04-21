part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchLocationEvent extends SearchEvent {
  final String searchText;
  SearchLocationEvent({required this.searchText});
}

class CleanSearchEvent extends SearchEvent {}
