part of 'local_notification_bloc.dart';

abstract class LocalNotificationEvent {}

class FetchNotifications extends LocalNotificationEvent {}

class GetNotifications extends LocalNotificationEvent {}

class GetLastNotificationIDEvent extends LocalNotificationEvent {}