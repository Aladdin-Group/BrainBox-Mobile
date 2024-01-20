import 'dart:async';

import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'local_notification_event.dart';

part 'local_notification_state.dart';

class LocalNotificationBloc extends Bloc<LocalNotificationEvent, LocalNotificationState> {
  LocalNotificationBloc() : super(const LocalNotificationState()) {
    on<FetchNotifications>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(FetchNotifications event, Emitter<LocalNotificationState> emit) async {
    final List<NotificationModel> notifications = await NotificationBox.getAllNotifications();
    emit(state.copyWith(notifications: notifications.reversed.toList()));
  }
}
