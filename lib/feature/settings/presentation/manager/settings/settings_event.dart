part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class GetUserDataEvent extends SettingsEvent{
  Function(User user) onSuccess;
  GetUserDataEvent({required this.onSuccess});
}