part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final FormzSubmissionStatus status;
  final User? user;
  final LanguageModel languageModel ;

  const SettingsState({
    this.status = FormzSubmissionStatus.initial,
    this.user,
    required this.languageModel,
  });

  SettingsState copyWith({
    FormzSubmissionStatus? status,
    User? user,
    LanguageModel? languageModel,
  }) =>
      SettingsState(
        status: status ?? this.status,
        user: user ?? this.user,
        languageModel: languageModel ?? this.languageModel,
      );

  @override
  List<Object?> get props => [status, user, languageModel];
}
