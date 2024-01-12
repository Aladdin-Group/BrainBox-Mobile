part of 'education_bloc.dart';

@immutable
abstract class EducationEvent {}

class GetEduItemsEvent extends EducationEvent{}

class GetMoreEduItemsEvent extends EducationEvent{}

class GetWordsEvent extends EducationEvent{
  final Essential essential;
  final int unit;
  final Function? onProgress;
  final Function(List<EssentialModel>) onSuccess;
  final Function(Failure) onFail;

  GetWordsEvent({required this.essential,required this.unit,required this.onFail,required this.onSuccess,this.onProgress});
}

class GetWordsByUnitsEvent extends EducationEvent{
  final Essential essential;
  final List unit;
  final Function(List<EssentialModel>) onSuccess;
  final Function(Failure) onFail;
  GetWordsByUnitsEvent({required this.essential,required this.unit,required this.onFail,required this.onSuccess});
}