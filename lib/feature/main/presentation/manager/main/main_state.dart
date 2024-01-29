part of 'main_bloc.dart';

class MainState extends Equatable {
  final List<SearchModel> listSearch;

  final Map<String, RequestMovieModel> movies;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus getUserInfoStatus;
  final FormzSubmissionStatus getAllMoviesStatus;
  final GenericPagination<Content>? genericPagination;
  final User? user;
  final List<Map<String, int>> count;
  final List<Map<String, int>> page;

  const MainState({
    this.listSearch = const [],
    this.movies = const {},
    this.count = const [],
    this.page = const [],
    this.user,
    this.genericPagination,
    this.getUserInfoStatus = FormzSubmissionStatus.initial,
    this.getAllMoviesStatus = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
  });


  @override
  List<Object?> get props =>
      [
        movies,
        status,
        user,
        getUserInfoStatus,
        getAllMoviesStatus,
        genericPagination,
        count,
        listSearch,
        page,
      ];

  MainState copyWith({
    List<SearchModel>? listSearch,
    Map<String, RequestMovieModel>? movies,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? getUserInfoStatus,
    FormzSubmissionStatus? getAllMoviesStatus,
    GenericPagination<Content>? genericPagination,
    User? user,
    List<Map<String, int>>? count,
    List<Map<String, int>>? page,
  }) {
    return MainState(
      listSearch: listSearch ?? this.listSearch,
      movies: movies ?? this.movies,
      status: status ?? this.status,
      getUserInfoStatus: getUserInfoStatus ?? this.getUserInfoStatus,
      getAllMoviesStatus: getAllMoviesStatus ?? this.getAllMoviesStatus,
      genericPagination: genericPagination ?? this.genericPagination,
      user: user ?? this.user,
      count: count ?? this.count,
      page: page ?? this.page,
    );
  }
}
