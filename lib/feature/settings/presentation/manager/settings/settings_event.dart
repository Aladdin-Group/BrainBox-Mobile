part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class GetUserDataEvent extends SettingsEvent{
  Function(User user) onSuccess;
  GetUserDataEvent({required this.onSuccess});
}

class UpdateUseDataEven extends SettingsEvent{
  UpdateUser user;
  Function() success;
  Function() failure;
  Function() progress;
  UpdateUseDataEven({required this.user,required this.success,required this.failure,required this.progress});
}

class SubscribePremiumEvent extends SettingsEvent{
  Function() success;
  Function() failure;
  Function() progress;
  SubscribePremiumEvent({required this.success,required this.failure,required this.progress});
}