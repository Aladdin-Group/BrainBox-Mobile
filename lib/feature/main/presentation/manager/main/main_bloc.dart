import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_level.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_movies_usecase.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  List<String> levels = [MovieLevel.ELEMENTARY,MovieLevel.INTERMEDIATE,MovieLevel.UPPER_INTERMEDIATE,MovieLevel.BEGINNER];
  final GetMoviesUseCase getMoviesUseCase = GetMoviesUseCase();

  MainBloc() : super(const MainState()) {
    on<GetAllMoviesEvent>((event, emit) async{
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      var movie = <String, List<Content>>{};
      var counts = <Map<String,int>>[];
      var page = <Map<String,int>>[];
      var index = 0;
      for(var level in levels){
        var req = <String,int>{};
        var countLevel = <String,int>{};
        req[level] = 0;

        var paging = <String,int>{};
        paging[level] = 1;
        page.add(paging);
        index++;
        final result = await getMoviesUseCase.call(req);
        movie[level] = result.right.results;
        countLevel[level] = result.right.count;
        counts.add(countLevel);
        if(result.isRight){
          levels.length == index ? emit(state.copyWith(
            status:FormzSubmissionStatus.success,
            movies: movie,
          )) : emit(state.copyWith(
            movies: movie,
            count: counts,
            page: page
          ));
        }else{
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
      }
    });
    on<GetMoreMovieEvent>((event,emit) async{
      Map<String,int> page = {};
      var movie = {};
      var moviesCount = 0;
      var levelPage = 0;
      for(var pagingItem in state.page){
        if(pagingItem.containsKey(event.movieLevel)){
          page = pagingItem;
          levelPage = pagingItem[event.movieLevel]!;
          break;
        }
      }
      final result = await getMoviesUseCase.call(page);
      if(result.isRight){
        movie[event.movieLevel] = result.right.results;
        var map = state.movies;
        map[event.movieLevel]!.addAll(movie[event.movieLevel] ?? []);
        emit(state.copyWith(
          movies: map,
          status: FormzSubmissionStatus.success
        ));
        event.onSuccess(result.right.results);
        for(var movie in state.movies[event.movieLevel]!){
          moviesCount++;
        }
        page[event.movieLevel] = result.right.count > (moviesCount + result.right.results.length) ? levelPage + 1 : levelPage;
      }else{
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });
  }
}
