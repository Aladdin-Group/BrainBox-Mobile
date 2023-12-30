part of 'test_bloc.dart';

class TestState extends Equatable {
  final List<Content> failWords;
  final List<Content> list;
  final int page;
  final int count;
  final FormzSubmissionStatus status;


  const TestState({this.failWords = const [],this.page = 0,this.count = 0,this.list = const [],this.status = FormzSubmissionStatus.initial});

  TestState copyWith({List<Content>? failWords,int? page,int? count,List<Content>? list,FormzSubmissionStatus? status})=>
      TestState(
          failWords: failWords??this.failWords,
          page: page??this.page,
          count: count??this.count,
          list: list??this.list,
          status:status??this.status
      );


  @override
  List<Object?> get props => [failWords,page,count,list,status];
}
