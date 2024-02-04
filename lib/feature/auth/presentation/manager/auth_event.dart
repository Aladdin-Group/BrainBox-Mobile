part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GoogleAuthEvent extends AuthEvent {
  GoogleSignInAccount? googleSignInAccount;

  GoogleAuthEvent({this.googleSignInAccount});
}

class IsDevModeEvent extends AuthEvent {}

class AppleSignInEvent extends AuthEvent{}