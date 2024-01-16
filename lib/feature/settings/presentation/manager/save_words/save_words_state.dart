part of 'save_words_bloc.dart';

class SaveWordsState {
  FormzSubmissionStatus status;
  List<Content> savedWords;
  String errorMessage;

  SaveWordsState({
    this.savedWords = const [],
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage = '',
  });

  SaveWordsState copyWith({
    List<Content>? savedWords,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return SaveWordsState(
      savedWords: savedWords ?? this.savedWords,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}
