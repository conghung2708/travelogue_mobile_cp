part of 'search_bloc.dart';

abstract class SearchState {
  List<Object> get props => [<LocationModel>[]];
}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {
  final List<LocationModel> listSearch;
  SearchSuccess({required this.listSearch});

  @override
  List<Object> get props => [listSearch];
}
