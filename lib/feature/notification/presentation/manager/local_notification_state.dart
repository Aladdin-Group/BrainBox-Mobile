part of 'local_notification_bloc.dart';

class LocalNotificationState {
  final FormzSubmissionStatus status;
   final List<NotificationModel> notifications;
   final String message;
   final NotificationModel? lastNotificationId;

  const LocalNotificationState({
    this.notifications = const [],
    this.status = FormzSubmissionStatus.initial,
    this.message = '',
    this.lastNotificationId,
  });

  LocalNotificationState copyWith({
    FormzSubmissionStatus? status,
    List<NotificationModel>? notifications,
    String? message,
    NotificationModel? lastNotificationId,
  }) {
    return LocalNotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      message: message ?? this.message,
      lastNotificationId: lastNotificationId ?? this.lastNotificationId,
    );
  }
}
