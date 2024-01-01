part of 'words_bloc.dart';


abstract class WordsEvent {}

class GetMovieInfoEvent extends WordsEvent{
  final int id;
  GetMovieInfoEvent({required this.id});
}

class GetWordsEvent extends WordsEvent{
  final int movieId;
  GetWordsEvent({required this.movieId});
}

class GetMoreWordsEvent extends WordsEvent{
  Function(int list) success;
  final int movieId;
  GetMoreWordsEvent({required this.success,required this.movieId});
}
