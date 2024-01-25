part of 'remainder_bloc.dart';

class RemainderState {
  bool notification;

  RemainderState({
    this.notification = false,
  });

  RemainderState copyWith({
    bool? notification,
  }) {
    return RemainderState(
      notification: notification ?? this.notification,
    );
  }
}
