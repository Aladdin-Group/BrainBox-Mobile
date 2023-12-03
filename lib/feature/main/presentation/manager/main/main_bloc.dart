import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_container.dart';
import 'package:brain_box/feature/main/data/models/movie_level.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/get_movies_usecase.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  final GetMoviesUseCase getMoviesUseCase = GetMoviesUseCase();

  MainBloc() : super(const MainState()) {
    on<GetAllMoviesEvent>((event, emit) async{
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final result = await getMoviesUseCase.call(state.page);
      var movie = <String, List<Content>>{};
      for(var model in result.right.results){
        movie[model.level!] ??= [];
        if(result.right.results!=[]){
          movie[model.level]!.add(model);
        }
      }
      print(movie);
      if(result.isRight){
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          movies: movie,
          page: result.right.count > 10 ? 2 : 1,
          count: result.right.count,
        ));
      }else{

      }
    });
  }
}
