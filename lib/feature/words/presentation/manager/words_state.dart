part of 'words_bloc.dart';

@immutable
class WordsState  extends Equatable{
  final FormzSubmissionStatus status;
  final Failure? fail;
  final MovieModel? result;
  final int wordsPage;
  final List<Content> listWords;
  final int wordsCount;

  const WordsState({
    this.status = FormzSubmissionStatus.initial,
    this.fail,
    this.result,
    this.wordsPage = 0,
    this.listWords = const [],
    this.wordsCount = 0
  });

  WordsState copyWith({FormzSubmissionStatus? status,Failure? fail,MovieModel? result,int? wordsPage,List<Content>? listWords,int? wordsCount}) => WordsState(status: status ?? this.status,fail: fail ?? this.fail,result: result??this.result,wordsPage: wordsPage??this.wordsPage,listWords: listWords??this.listWords,wordsCount: wordsCount??this.wordsCount);

  @override
  List<Object?> get props => [status,fail,result,wordsPage,listWords,wordsCount];

}

