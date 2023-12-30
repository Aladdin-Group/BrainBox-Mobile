import 'package:bloc/bloc.dart';
import 'package:brain_box/core/exceptions/failure.dart';
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
        add(GetWordsEvent());
      }else{
        emit(state.copyWith(status: FormzSubmissionStatus.failure,fail: result.left));
      }
    });

    on<GetWordsEvent>((event,emit)async{

      final result = await getWordsByCountUseCase.call(0);

      if(result.isRight){
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          wordsPage: 1,
          wordsCount: result.right.count,
          listWords: result.right.results
        ));
      }else{
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
        ));
      }

    });

    on<GetMoreWordsEvent>((event,emit)async{
      
      final result = await getWordsByCountUseCase.call(state.wordsPage);

      if(result.isRight){
        event.success(result.right.results.length);
        emit(state.copyWith(
          listWords: [...state.listWords, ...result.right.results],
          wordsCount: result.right.count,
          wordsPage: result.right.count > (state.listWords.length + result.right.results.length) ? state.wordsPage + 1 : state.wordsPage,
        ));
      }
      
    });

  }
}
