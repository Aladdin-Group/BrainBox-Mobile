import 'dart:async';

import 'package:brain_box/core/assets/constants/app_constants.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_box.dart';
import 'package:brain_box/feature/notification/domain/usecase/get_last_notification_id.dart';
import 'package:brain_box/feature/notification/domain/usecase/get_notification_usecase.dart';

// import 'package:brain_box/feature/notification/domain/usecase/get_notification_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'local_notification_event.dart';

part 'local_notification_state.dart';

class LocalNotificationBloc extends Bloc<LocalNotificationEvent, LocalNotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase = GetNotificationsUseCase();
  final GetLastNotificationIdUseCase getLastNotificationIdUseCase = GetLastNotificationIdUseCase();

  LocalNotificationBloc() : super(const LocalNotificationState()) {
    on<GetNotifications>(_onGetNotifications);
    on<FetchNotifications>(_onFetchNotifications);
    on<GetLastNotificationIDEvent>(_onGetLastNotificationIDEvent);
  }

  void _onGetLastNotificationIDEvent(GetLastNotificationIDEvent event, Emitter<LocalNotificationState> emit) async {
    final lastNotificationId = await getLastNotificationIdUseCase.call(NoParams());

    if (lastNotificationId.isRight) {

      // StorageRepository.putString(AppConstants.LAST_NOTIFICATION_ID, lastNotificationId.right.id.toString());
      emit(state.copyWith(lastNotificationId: lastNotificationId.right));
    }

  }

  Future<void> _onFetchNotifications(FetchNotifications event, Emitter<LocalNotificationState> emit) async {
    final List<NotificationModel> notifications = await NotificationBox.getAllNotifications();
    emit(state.copyWith(notifications: notifications.reversed.toList()));
  }

  void _onGetNotifications(GetNotifications event, Emitter<LocalNotificationState> emit) async {
    print('fetching notifications');
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await getNotificationsUseCase.call(0);
    print(result.isRight);
    if (result.isRight) {
      StorageRepository.putList("notifications", result.right.results.map((e) => e.id.toString()).toList());
      emit(state.copyWith(status: FormzSubmissionStatus.success, notifications: result.right.results));
    } else {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, message: result.left.toString()));
    }
  }
}
