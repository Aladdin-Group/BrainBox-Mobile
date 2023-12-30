part of 'test_bloc.dart';

abstract class TestEvent {}

class NextTestEvent extends TestEvent{
  Function(List<Content> words) success;
  Function(String failure) failure;
  NextTestEvent({required this.success,required this.failure});
}