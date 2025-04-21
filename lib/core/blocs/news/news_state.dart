part of 'news_bloc.dart';

abstract class NewsState {
  List<Object> get props => [<NewsModel>[]];
}

class NewsInitial extends NewsState {}

class GetNewsSuccess extends NewsState {
  final List<NewsModel> listNews;
  GetNewsSuccess({required this.listNews});

  @override
  List<Object> get props => [listNews];
}
