part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final FormzSubmissionStatus status;

  const AuthState({
    this.status = FormzSubmissionStatus.initial,
  });

  AuthState copyWith({FormzSubmissionStatus? status}) => AuthState(
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        status,
      ];
}
