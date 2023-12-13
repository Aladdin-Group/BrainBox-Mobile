part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final FormzSubmissionStatus status;

  const SettingsState({
    this.status = FormzSubmissionStatus.initial
  });

  SettingsState copyWith({FormzSubmissionStatus? status})=>SettingsState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}

