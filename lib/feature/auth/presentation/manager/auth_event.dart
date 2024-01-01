part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GoogleAuthEvent extends AuthEvent{
  GoogleSignInAccount? googleSignInAccount;
  GoogleAuthEvent({this.googleSignInAccount});
}

class IsDevModeEvent extends AuthEvent{
  Function() progress;
  Function(DevTestModel model) success;
  Function() failure;
  IsDevModeEvent({required this.success,required this.failure,required this.progress});
}