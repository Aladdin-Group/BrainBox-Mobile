part of 'main_bloc.dart';

@immutable
class MainState extends Equatable {
  final Map<String,List<Content>> movies;
  final FormzSubmissionStatus status;
  final List<Map<String,int>> count;
  final List<Map<String,int>> page;
  const MainState({
    this.movies = const {},
    this.count = const [],
    this.page = const [],
    this.status = FormzSubmissionStatus.initial,
  });

  MainState copyWith({
    Map<String,List<Content>>? movies,
    FormzSubmissionStatus? status,
    List<Map<String,int>>? count,
    List<Map<String,int>>? page,
  }) =>
      MainState(
          movies: movies ?? this.movies,
          status: status ?? this.status,
          count: count ?? this.count,
          page: page ?? this.page,
      );

  @override
  List<Object?> get props => [movies, status, count, page,];
}
