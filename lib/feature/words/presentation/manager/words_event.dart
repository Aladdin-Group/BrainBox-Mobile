part of 'words_bloc.dart';


abstract class WordsEvent {}

class GetMovieInfoEvent extends WordsEvent{
  final int id;
  GetMovieInfoEvent({required this.id});
}

class GetWordsEvent extends WordsEvent{}

class GetMoreWordsEvent extends WordsEvent{
  Function(int list) success;
  GetMoreWordsEvent({required this.success});
}
