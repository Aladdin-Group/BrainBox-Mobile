part of 'save_words_bloc.dart';

abstract class SaveWordsEvent {}

class GetSavedWords extends SaveWordsEvent {}

class DeleteSavedWord extends SaveWordsEvent {
  String id;

  DeleteSavedWord(this.id);
}