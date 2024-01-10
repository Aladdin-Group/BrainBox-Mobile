part of 'education_bloc.dart';

@immutable
abstract class EducationEvent {}

class GetEduItemsEvent extends EducationEvent{}

class GetMoreEduItemsEvent extends EducationEvent{}
