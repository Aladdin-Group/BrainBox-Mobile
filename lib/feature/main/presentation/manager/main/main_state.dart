part of 'main_bloc.dart';

@immutable
class MainState extends Equatable {
  final Map<String,List<Content>> movies;
  final FormzSubmissionStatus status;
  final int count;
  final int page;
  const MainState({
    this.movies = const {},
    this.count = 0,
    this.page = 0,
    this.status = FormzSubmissionStatus.initial,
  });

  MainState copyWith({
    Map<String,List<Content>>? movies,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? refreshStatus,
    int? count,
    int? page,
    double? coins
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
