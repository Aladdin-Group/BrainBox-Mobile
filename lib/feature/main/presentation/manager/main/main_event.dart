part of 'main_bloc.dart';


abstract class MainEvent {}

class GetAllMoviesEvent extends MainEvent{}

class GetMoreMovieEvent extends MainEvent{
  String movieLevel;
  Function(List<Content> p0) onSuccess;
  GetMoreMovieEvent({required this.movieLevel,required this.onSuccess});
}