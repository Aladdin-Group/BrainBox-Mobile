part of 'remainder_bloc.dart';

abstract class RemainderEvent {}

class RemainderInitial extends RemainderEvent {}

class ChangeNotification extends RemainderEvent {
  final bool notification;

  ChangeNotification(this.notification);
}
