part of 'news_bloc.dart';

abstract class NewsEvent {}

class GetAllNewsEvent extends NewsEvent {}

class CleanNewsEvent extends NewsEvent {}
