import 'package:bloc/bloc.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/singletons/storage/saved_controller.dart';
import 'package:brain_box/feature/words/data/models/movie_model.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../settings/data/models/user.dart';
import '../../../settings/domain/use_cases/userDataUsecase.dart';
import '../../data/models/words_response.dart';
import '../../domain/use_cases/get_movie_info_usecase.dart';
import '../../domain/use_cases/get_words_by_coun_usecase.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {

  final GetMovieInfoUseCase getMoviesUseCase = GetMovieInfoUseCase();
  final GetWordsByCountUseCase getWordsByCountUseCase = GetWordsByCountUseCase();


  WordsBloc() : super(const WordsState()) {

    on<GetMovieInfoEvent>((event, emit) async{
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await getMoviesUseCase.call(event.id);

      if(result.isRight){
        emit(state.copyWith(result: result.right));
        add(GetWordsEvent(movieId: result.right.id!.toInt()));
      }else{
        emit(state.copyWith(status: FormzSubmissionStatus.failure,fail: result.left));
      }
    });

    on<GetWordsEvent>((event,emit)async{

      var hiveList = await SavedController.getListFromHive();
      List<Content> listWords = [];
      var index = 0;

      final result = await getWordsByCountUseCase.call([0,event.movieId]);

      result.right.results.forEach((element) {
        if(hiveList.isNotEmpty){
          if(element.id==hiveList[index].id){
            element.isSaved = true;
            listWords.add(element);
          }else{
            listWords.add(element);
          }
        }else{
          listWords.addAll(result.right.results);
          return;
        }
        if(hiveList.length<=index) index++;
      });

      if(result.isRight){
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          wordsPage: 1,
          wordsCount: result.right.count,
          listWords: listWords
        ));
      }else{
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
        ));
      }

    });

    on<GetMoreWordsEvent>((event,emit)async{

      var hiveList = SavedController.getListFromHive();
      List<Content> listWords = [];
      var index = 0;

      final result = await getWordsByCountUseCase.call([state.wordsPage,event.movieId]);

      result.right.results.forEach((element) {
        if(hiveList.isNotEmpty){
          if(element.id==hiveList[index].id){
            element.isSaved = true;
            listWords.add(element);
          }else{
            listWords.add(element);
          }
        }else{
          listWords.addAll(result.right.results);
          return;
        }
        if(hiveList.length<=index) index++;
      });

      if(result.isRight){
        event.success(result.right.results.length);
        emit(state.copyWith(
          listWords: [...state.listWords, ...listWords],
          wordsCount: result.right.count,
          wordsPage: result.right.count > (state.listWords.length + result.right.results.length) ? state.wordsPage + 1 : state.wordsPage,
        ));
      }
      
    });

  }
}
