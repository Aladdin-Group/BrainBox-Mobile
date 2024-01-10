part of 'education_bloc.dart';

@immutable
class EducationState extends Equatable {
  final FormzSubmissionStatus status;
  final List<EduModel> list;
  final int page;
  final int count;

  const EducationState({
    this.status = FormzSubmissionStatus.initial,
    this.list = const [],
    this.page = 0,
    this.count = 0
  });


  EducationState copyWith({FormzSubmissionStatus? status,List<EduModel>? list,int? page,int? count})=>
      EducationState(
        status: status??this.status,
        list: list??this.list,
        page: page??this.page,
        count: count??this.count
      );

  @override
  List<Object?> get props => [status,list,page,count];

}
