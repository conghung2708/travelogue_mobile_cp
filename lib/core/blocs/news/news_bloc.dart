import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/news_repository.dart';
import 'package:travelogue_mobile/model/news_model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final List<NewsModel> listNews = [];
  NewsBloc() : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {
      if (event is GetAllNewsEvent) {
        await _getAllNews();
        emit(_getNewSuccess);
      }

      if (event is CleanNewsEvent) {
        listNews.clear();
        emit(NewsInitial());
      }
    });
  }

  GetNewsSuccess get _getNewSuccess => GetNewsSuccess(listNews: listNews);

  Future<void> _getAllNews() async {
    final List<NewsModel> news = await NewsRepository().getAllNews();

    if (news.isNotEmpty) {
      listNews.addAll(news);
    }
  }
}
