import 'package:bloc/bloc.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_level.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../../../../core/exceptions/exception.dart';
import '../../../../../core/singletons/storage/storage_repository.dart';
import '../../../../../core/singletons/storage/store_keys.dart';
import '../../../../settings/data/models/user.dart';
import '../../../../settings/domain/use_cases/userDataUsecase.dart';
import '../../../data/models/search_model.dart';
import '../../../domain/usecases/buy_movie_usecase.dart';
import '../../../domain/usecases/get_movies_usecase.dart';
import '../../../domain/usecases/search_movie_usecase.dart';
import '../../../domain/usecases/submit_movie_usecase.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  List<String> levels = [MovieLevel.ELEMENTARY,MovieLevel.INTERMEDIATE,MovieLevel.UPPER_INTERMEDIATE,MovieLevel.BEGINNER];
  final GetMoviesUseCase getMoviesUseCase = GetMoviesUseCase();
  final BuyMovieUseCase buyMovieUseCase = BuyMovieUseCase();
  final UserdataUseCase getUserInfoEvent = UserdataUseCase();
  final SearchMovieUseCase searchMovieUseCase = SearchMovieUseCase();
  final SubmitMovieUseCase submitMovieUseCase = SubmitMovieUseCase();

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
        if(result.isRight){
          movie[level] = result.right.results;
          countLevel[level] = result.right.count;
          counts.add(countLevel);
          levels.length == index ? emit(state.copyWith(
            status:FormzSubmissionStatus.success,
            movies: movie,
          )) : emit(state.copyWith(
            movies: movie,
            count: counts,
            page: page
          ));
        }else{
          if(result.left is UserTokenExpire){
              StorageRepository.deleteBool(StoreKeys.isAuth);
              StorageRepository.deleteString(StoreKeys.token);
              GoogleSignIn().signOut();
              Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(builder: (context)=> const AuthScreen()), (route) => false);
          }
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
      }
    });
    on<GetMoreMovieEvent>((event,emit) async{
      Map<String,int> page = {};
      Map<String,int> myPage = {};
      var movie = {};
      var moviesCount = 0;
      var levelPage = 0;
      var movieIndex = 0;
      for(var pagingItem in state.page){
        movieIndex++;
        if(pagingItem.containsKey(event.movieLevel)){
          page = pagingItem;
          levelPage = pagingItem[event.movieLevel]!;
          break;
        }
      }

      // result.right.count > ((state.movies[event.movieLevel]?.length??1) + result.right.results.length) ? levelPage + 1 : levelPage
      final result = await getMoviesUseCase.call(page);
      var statePage = state.page;
      // myPage[event.movieLevel] = result.right.count > ((state.movies[event.movieLevel]?.length??1) + result.right.results.length) ? levelPage + 1 : levelPage;
      // statePage[movieIndex] =  myPage;
      if(result.isRight){
        movie[event.movieLevel] = result.right.results;
        var map = state.movies;
        map[event.movieLevel]!.addAll(movie[event.movieLevel] ?? []);
        emit(state.copyWith(
          movies: map,
          status: FormzSubmissionStatus.success,
          // page: statePage,
        ));
        event.onSuccess(result.right.results);
        for(var movie in state.movies[event.movieLevel]!){
          moviesCount++;
        }
        page[event.movieLevel] = result.right.count > (moviesCount + result.right.results.length) ? levelPage + 1 : levelPage;
      }else{
        if(result.left is ServerException){
          StorageRepository.deleteBool(StoreKeys.isAuth);
          StorageRepository.deleteString(StoreKeys.token);
          GoogleSignIn().signOut();
          Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(builder: (context)=> const AuthScreen()), (route) => false);
        }
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });
    on<BuyMovieEvent>((event,emit)async{

      event.progress();

      final result = await buyMovieUseCase.call(event.movieId);

      if(result.isRight){
        event.success(result.right);
      }else{
        event.failure();
      }

    });
    on<GetUserInfoEvent>((event,emit)async{

      event.progress();

      final result = await getUserInfoEvent.call(-1);

      if(result.isRight){
        event.success(result.right);
      }else{
        event.failure(result.left);
      }

    });
    on<SearchMovieEvent>((event,emit)async{
      final result = await searchMovieUseCase.call(event.keyWord);
      if(result.isRight){
        event.success(result.right);
      }else{
        event.failure();
      }
    });
    on<SubmitMovieEvent>((event,emit)async{
      print('SubmitMovieEvent');
      submitMovieUseCase.call(event.movieName);

    });
  }
}