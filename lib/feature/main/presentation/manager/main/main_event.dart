part of 'main_bloc.dart';


abstract class MainEvent {}

class GetAllMoviesEvent extends MainEvent{
  final context;
  GetAllMoviesEvent({required this.context});
}

class GetMoreMovieEvent extends MainEvent{
  String movieLevel;
  final context;
  Function(List<Content> p0) onSuccess;
  GetMoreMovieEvent({required this.movieLevel,required this.onSuccess,required this.context});
}

class BuyMovieEvent extends MainEvent{
  int movieId;
  Function(dynamic) success;
  Function() failure;
  Function() progress;
  BuyMovieEvent({required this.success,required this.failure,required this.progress,required this.movieId});
}

class GetUserInfoEvent extends MainEvent{
  Function(User user) success;
  Function() progress;
  Function(Failure) failure;

  GetUserInfoEvent({required this.success,required this.failure,required this.progress});
}

class SearchMovieEvent extends MainEvent{
  String keyWord;
  Function(List<SearchModel> list) success;
  Function() failure;

  SearchMovieEvent({required this.success,required this.failure,required this.keyWord});
}

class SubmitMovieEvent extends MainEvent{
  String movieName;
  SubmitMovieEvent({required this.movieName});
}