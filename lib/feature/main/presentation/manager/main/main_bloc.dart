import 'package:bloc/bloc.dart';
import 'package:brain_box/core/utils/cache.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_level.dart';
import 'package:brain_box/feature/main/data/models/request_movie_model.dart';
import 'package:brain_box/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
import 'package:stream_transform/stream_transform.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  List<String> levels = [
    MovieLevel.ELEMENTARY,
    MovieLevel.INTERMEDIATE,
    MovieLevel.UPPER_INTERMEDIATE,
    MovieLevel.BEGINNER
  ];
  final GetMoviesUseCase getMoviesUseCase = GetMoviesUseCase();
  final BuyMovieUseCase buyMovieUseCase = BuyMovieUseCase();
  final UserdataUseCase getUserInfoEvent = UserdataUseCase();
  final SearchMovieUseCase searchMovieUseCase = SearchMovieUseCase();
  final SubmitMovieUseCase submitMovieUseCase = SubmitMovieUseCase();



  // Variables
  final hive = Hive.box(StoreKeys.userData);
  SearchController searchController = SearchController();

  final CacheManager cacheManager = CacheManager();

  MainBloc() : super(const MainState()) {
    on<InitialMainEvent>(_initialMain);
    on<GetAllMoviesEvent>(_getAllMovies);
    on<GetMoreMovieEvent>(_getMoreMovies);
    on<BuyMovieEvent>(_buymovie);
    on<GetUserInfoEvent>(_getUserInfo);
    on<SearchMovieEvent>(_searchMovie, transformer:(events, mapper) {
    //   wait 300 ml second and get last event
    return events.debounce(const Duration(milliseconds: 300)).switchMap(mapper);
    },);
    on<SubmitMovieEvent>(_submitMovie);
  }


  void _initialMain(InitialMainEvent event, Emitter<MainState> emit) async {
    final user = hive.get(StoreKeys.user);
    print('get user from hive');
    print(user != null);
    if (user != null) {


      emit(state.copyWith(user: user));
    }
  }

  void _submitMovie(SubmitMovieEvent event, Emitter<MainState> emit) async {
    submitMovieUseCase.call(event.movieName);
  }

  void _searchMovie(SearchMovieEvent event, Emitter<MainState> emit) async {

    final result = await searchMovieUseCase.call(event.keyWord);
    if (result.isRight) {
      emit(state.copyWith(listSearch: result.right));
      event.success(result.right);
    } else {
      event.failure();
    }
  }

  void _getUserInfo(GetUserInfoEvent event, Emitter<MainState> emit) async {
    // event.progress();
    emit(state.copyWith(getUserInfoStatus: FormzSubmissionStatus.inProgress));
    final result = await getUserInfoEvent.call(-1);

    if (result.isRight) {
      print('get user info success');

      // hive.put(StoreKeys.user, result.right);
      emit(state.copyWith(getUserInfoStatus: FormzSubmissionStatus.success, user: result.right));
    } else {
      // event.failure(result.left);
      if (result.left is UserTokenExpire) {
        StorageRepository.deleteBool(StoreKeys.isAuth);
        StorageRepository.deleteString(StoreKeys.token);
        await GoogleSignIn().signOut();
      }
      emit(state.copyWith(getUserInfoStatus: FormzSubmissionStatus.failure));
    }
  }

  void _buymovie(BuyMovieEvent event, Emitter<MainState> emit) async {
    event.progress();

    final result = await buyMovieUseCase.call(event.movieId);

    if (result.isRight) {
      event.success(result.right);
    } else {
      event.failure();
    }
  }

  void _getMoreMovies(GetMoreMovieEvent event, Emitter<MainState> emit) async {

    RequestMovieModel? request = state.movies[event.movieLevel];
    if (request == null) {
      return;
    }
    if (request.page >= request.data!.page) {
      return;
    }
    request.page = request.page + 1;
    final result = await getMoviesUseCase.call(request);
    if (result.isRight) {
      request.listData.addAll(result.right.results);
      event.onSuccess();
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        movies: Map<String, RequestMovieModel>.from(state.movies)
          ..update(event.movieLevel, (value) => request, ifAbsent: () => request),
      ));
    } else {
      if (result.left is ServerException) {
        StorageRepository.deleteBool(StoreKeys.isAuth);
        StorageRepository.deleteString(StoreKeys.token);
        GoogleSignIn().signOut();
        Navigator.pushAndRemoveUntil(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
      }
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

// Map<String, int> page = {};
// Map<String, int> myPage = {};
// var movie = {};
// var moviesCount = 0;
// var levelPage = 0;
// var movieIndex = 0;
// for (var pagingItem in state.page) {
//   movieIndex++;
//   if (pagingItem.containsKey(event.movieLevel)) {
//     page = pagingItem;
//     levelPage = pagingItem[event.movieLevel]!;
//     break;
//   }
// }
//
// // result.right.count > ((state.movies[event.movieLevel]?.length??1) + result.right.results.length) ? levelPage + 1 : levelPage
// var statePage = state.page;
// // myPage[event.movieLevel] = result.right.count > ((state.movies[event.movieLevel]?.length??1) + result.right.results.length) ? levelPage + 1 : levelPage;
// // statePage[movieIndex] =  myPage;
// if (result.isRight) {
//   movie[event.movieLevel] = result.right.results;
//   var map = state.movies;
//   // map[event.movieLevel]!.addAll(movie[event.movieLevel] ?? []);
//   List<Content> movies = state.movies[event.movieLevel]!.toList();
//   Map<String,List<Content>> newMap = state.movies;
//   newMap[event.movieLevel] = movies..addAll(result.right.results);
//   print(state.movies[event.movieLevel]?.length);
//   print(newMap[event.movieLevel]?.length);
//   newMap[event.movieLevel]?.forEach((element) {print(element.name);});
//
//   emit(state.copyWith(
//     movies: newMap,
//     status: FormzSubmissionStatus.success,
//     genericPagination: result.right,
//     // page: statePage,
//   ));
//   event.onSuccess(result.right.results);
//   for (var movie in state.movies[event.movieLevel]!) {
//     moviesCount++;
//   }
//   page[event.movieLevel] = result.right.count > (moviesCount + result.right.results.length)
//       ? levelPage + 1
//       : levelPage;
// } else {
//
// }
// }

  void _getAllMovies(GetAllMoviesEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // var movie = <String, List<Content>>{};
    // var counts = <Map<String, int>>[];
    // var page = <Map<String, int>>[];
    // var index = 0;
    for (String level in levels) {
      final RequestMovieModel request = RequestMovieModel(level: level, page: 0);
      //   var req = <String, int>{};
      //   var countLevel = <String, int>{};
      //   req[level] = 0;
      //
      //   var paging = <String, int>{};
      //   paging[level] = 1;
      //   page.add(paging);
      //   index++;

      final result = await getMoviesUseCase.call(request);
      if (result.isRight) {
        // request.copyWith(listData: result.right.results, data: result.right);
        request.listData = result.right.results;
        request.data = result.right;
        //     movie[level] = result.right.results;
        //     countLevel[level] = result.right.count;
        //     counts.add(countLevel);
        //     levels.length == index
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          movies: Map<String, RequestMovieModel>.from(state.movies)
            ..update(level, (value) => request, ifAbsent: () => request),
        ));
        //         : emit(state.copyWith(movies: movie, count: counts, page: page,));
      } else {
        if (result.left is UserTokenExpire) {
          StorageRepository.deleteBool(StoreKeys.isAuth);
          StorageRepository.deleteString(StoreKeys.token);
          GoogleSignIn().signOut();
        }
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
