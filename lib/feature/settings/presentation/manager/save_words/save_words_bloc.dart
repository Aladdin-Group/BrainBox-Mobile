
import 'package:brain_box/core/singletons/storage/saved_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../words/data/models/words_response.dart';

part 'save_words_event.dart';

part 'save_words_state.dart';

class SaveWordsBloc extends Bloc<SaveWordsEvent, SaveWordsState> {
  SaveWordsBloc() : super(SaveWordsState()) {
    on<GetSavedWords>(_onGetSaveWordsEvent);
    on<DeleteSavedWord>(_onDeleteSavedWordEvent);
  }

  void _onGetSaveWordsEvent(GetSavedWords event, Emitter<SaveWordsState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final savedWords = SavedController.getListFromHive();
      emit(state.copyWith(savedWords: savedWords, status: FormzSubmissionStatus.success));
      // print(savedWords);
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }

  _onDeleteSavedWordEvent(DeleteSavedWord event, Emitter<SaveWordsState> emit) async {
    await SavedController.removeObjectFromHive(event.id);
    final savedWords = SavedController.getListFromHive();
    emit(state.copyWith(savedWords: savedWords, status: FormzSubmissionStatus.success));
  }
}
