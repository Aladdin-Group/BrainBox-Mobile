part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final FormzSubmissionStatus status;
  final User? user;

  const SettingsState({
    this.status = FormzSubmissionStatus.initial,
    this.user,
  });

  SettingsState copyWith({
    FormzSubmissionStatus? status,
    User? user,
  }) =>
      SettingsState(
        status: status ?? this.status,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [status, user];
}
