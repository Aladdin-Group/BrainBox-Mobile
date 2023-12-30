part of 'test_bloc.dart';

class TestState extends Equatable {
  final List<Content> failWords;
  final List<Content> list;
  final int page;
  final int count;


  const TestState({this.failWords = const [],this.page = 0,this.count = 0,this.list = const []});

  TestState copyWith({List<Content>? failWords,int? page,int? count,List<Content>? list})=>
      TestState(
          failWords: failWords??this.failWords,
          page: page??this.page,
          count: count??this.count,
          list: list??this.list
      );


  @override
  List<Object?> get props => [failWords,page,count,list];
}
