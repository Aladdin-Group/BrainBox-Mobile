part of 'main_bloc.dart';

class MainState extends Equatable {
  final Map<String, List<Content>> movies;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus getUserInfoStatus;
  final FormzSubmissionStatus getAllMoviesStatus;

  final User? user;
  final List<Map<String, int>> count;
  final List<Map<String, int>> page;

  const MainState({
    this.movies = const {},
    this.count = const [],
    this.page = const [],
    this.user,
    this.getUserInfoStatus = FormzSubmissionStatus.initial,
    this.getAllMoviesStatus = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
  });

  MainState copyWith({
    Map<String, List<Content>>? movies,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? getUserInfoStatus,
    FormzSubmissionStatus? getAllMoviesStatus,
    User? user,
    List<Map<String, int>>? count,
    List<Map<String, int>>? page,
  }) =>
      MainState(
        movies: movies ?? this.movies,
        status: status ?? this.status,
        user: user ?? this.user,
        getUserInfoStatus: getUserInfoStatus ?? this.getUserInfoStatus,
        getAllMoviesStatus: getAllMoviesStatus ?? this.getAllMoviesStatus,
        count: count ?? this.count,
        page: page ?? this.page,
      );

  @override
  List<Object?> get props => [
        movies,
        status,
        user,
        getUserInfoStatus,
        getAllMoviesStatus,
        count,
        page,
      ];
}
