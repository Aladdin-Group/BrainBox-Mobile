import 'package:bloc/bloc.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/singletons/storage/saved_controller.dart';
import 'package:brain_box/feature/words/data/models/movie_model.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/words_response.dart';
import '../../domain/use_cases/get_movie_info_usecase.dart';
import '../../domain/use_cases/get_words_by_coun_usecase.dart';

part 'words_event.dart';

part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetMovieInfoUseCase getMoviesUseCase = GetMovieInfoUseCase();
  final GetWordsByCountUseCase getWordsByCountUseCase = GetWordsByCountUseCase();

  WordsBloc() : super(const WordsState()) {
    on<SaveOrRemoveWord>(_onSaveOrRemoveEvent);
    on<GetMovieInfoEvent>(_getMovieInfoEvent);
    on<GetWordsEvent>(_getWordsEvent);
    on<GetMoreWordsEvent>(_getMoreWordsEvent);
  }

  void _getMoreWordsEvent(GetMoreWordsEvent event, Emitter<WordsState> emit) async {
    var hiveList = SavedController.getListFromHive();
    List<Content> listWords = [];
    var index = 0;

    final result = await getWordsByCountUseCase.call([state.wordsPage, event.movieId]);

    if (result.isRight) {
      event.success(result.right.results.length);
      emit(
        state.copyWith(
          listWords: [...state.listWords, ...result.right.results],
          wordsCount: result.right.count,
          wordsPage: result.right.count > (state.listWords.length + result.right.results.length)
              ? state.wordsPage + 1
              : state.wordsPage,
        ),
      );
    }
  }

  void _getWordsEvent(GetWordsEvent event, Emitter<WordsState> emit) async {
    var hiveList = SavedController.getListFromHive();
    List<Content> listWords = [];
    var index = 0;

    final result = await getWordsByCountUseCase.call([0, event.movieId]);

    if (result.isRight) {
      for (var e in result.right.results) {
        if (hiveList.contains(e)) {
          print(e.value);
          listWords.add(e.copyWith(isSaved: true));
        } else {
          listWords.add(e.copyWith(isSaved: false));
        }
      }
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        wordsPage: 1,
        wordsCount: result.right.count,
        listWords: listWords,
      ));
    } else {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _getMovieInfoEvent(GetMovieInfoEvent event, Emitter<WordsState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await getMoviesUseCase.call(event.id);

    if (result.isRight) {
      emit(state.copyWith(result: result.right));
      add(GetWordsEvent(movieId: result.right.id!.toInt()));
    } else {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, fail: result.left));
    }
  }

  void _onSaveOrRemoveEvent(SaveOrRemoveWord event, Emitter<WordsState> emit) async {
    final words = SavedController.getListFromHive();
    if (words.contains(event.word)) {
      SavedController.removeObjectFromHive(event.word.id);
      final wordIndex = state.listWords.indexOf(event.word);
      emit(
        state.copyWith(
          listWords: state.listWords..[wordIndex] = event.word.copyWith(isSaved: false),
          status: FormzSubmissionStatus.success,
        ),
      );
    } else {
      SavedController.saveObject(event.word);
      final wordIndex = state.listWords.indexOf(event.word);
      emit(
        state.copyWith(
          listWords: state.listWords..[wordIndex] = event.word.copyWith(isSaved: true),
          status: FormzSubmissionStatus.success,
        ),
      );
    }
    print('emit');

    // final listWords = SavedController.getListFromHive();
    // emit(state.copyWith(status: FormzSubmissionStatus.success, `))
  }
}
