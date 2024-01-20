part of 'local_notification_bloc.dart';

class LocalNotificationState {
   final List<NotificationModel> notifications;

  const LocalNotificationState({
    this.notifications = const [],
  });

  LocalNotificationState copyWith({
    List<NotificationModel>? notifications,
  }) {
    return LocalNotificationState(
      notifications: notifications ?? this.notifications,
    );
  }
}
