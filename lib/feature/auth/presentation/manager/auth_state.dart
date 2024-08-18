part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final FormzSubmissionStatus status;
  final String message;

  const AuthState({
    this.status = FormzSubmissionStatus.initial,
    this.message = 'Something went wrong, the developer has been notified of the problem, please try again later!'
  });

  AuthState copyWith({FormzSubmissionStatus? status,String? message}) => AuthState(
        status: status ?? this.status,
        message: message ?? this.message
      );

  @override
  List<Object?> get props => [
        status,
        message
      ];
}
