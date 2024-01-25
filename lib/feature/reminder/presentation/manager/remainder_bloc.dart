import 'dart:async';

import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'remainder_event.dart';

part 'remainder_state.dart';

class RemainderBloc extends Bloc<RemainderEvent, RemainderState> {
  RemainderBloc() : super(RemainderState()) {
    on<RemainderInitial>(_onRemainderInitial);
    on<ChangeNotification>(_onChangeNotification);
  }

  void _onChangeNotification(ChangeNotification event, Emitter<RemainderState> emit) {
    StorageRepository.putBool(key: StoreKeys.service, value: event.notification);
    emit(state.copyWith(notification: event.notification));
  }

  void _onRemainderInitial(RemainderInitial event, Emitter<RemainderState> emit) {
    final bool notification = StorageRepository.getBool(StoreKeys.service);
    emit(state.copyWith(notification: notification));
  }
}
