import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/auth/data/models/AuthParams.dart';
import 'package:brain_box/feature/auth/domain/use_cases/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../../domain/use_cases/is_dev_testing_mode_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase = AuthUseCase();
  final IsDevTestTestingModeUseCase isDevTestTestingModeUseCase = IsDevTestTestingModeUseCase();

  AuthBloc() : super(const AuthState()) {
    on<GoogleAuthEvent>(_onGoogleAuth);
    on<IsDevModeEvent>(_onIsDevMode);
    on<AppleSignInEvent>(_appleSignIn);
  }

  _onIsDevMode(IsDevModeEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await isDevTestTestingModeUseCase.call(-1);

    if (result.isRight) {
      StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
      StorageRepository.putString(StoreKeys.token, result.right.object.toString());
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else {
      if(Platform.isAndroid){
        final googleSignInAccount = await GoogleSignIn().signIn();
        if (googleSignInAccount != null) {
          add(GoogleAuthEvent(googleSignInAccount: googleSignInAccount));
        }
      }else{
        add(AppleSignInEvent());
      }
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  _onGoogleAuth(GoogleAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final authParams = AuthParams(email: event.googleSignInAccount?.email??'null email', fullName: event.googleSignInAccount?.displayName??'Null Name', uid: event.googleSignInAccount?.id??'null_uid', photoUrl: event.googleSignInAccount?.photoUrl??'');

    final result = await authUseCase.call(authParams);

    if (result.isRight) {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
      StorageRepository.putString(StoreKeys.token, result.right.object.toString());
    } else {
      // context.read<AuthBloc>().add(GoogleAuthEvent(googleSignInAccount: account));

      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
  _appleSignIn(AppleSignInEvent event,Emitter<AuthState> emit) async{
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    String uid = credential.identityToken.toString().substring(0, 15);
    print(credential);
    if(credential.email!=null){
      StorageRepository.putString(StoreKeys.iosName, credential.givenName??'Null_name');
      StorageRepository.putString(StoreKeys.iosMail, credential.email??'Null_email');

      final authParams = AuthParams(email: credential.email??'null_email', fullName: credential.givenName??'Null_name', uid: uid??'Null_name', photoUrl: '');


      final result = await authUseCase.call(authParams);

      if (result.isRight) {
        StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
        StorageRepository.putString(StoreKeys.token, result.right.object.toString());
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        // context.read<AuthBloc>().add(GoogleAuthEvent(googleSignInAccount: account));

        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }

    }else{
      var name = StorageRepository.getString(StoreKeys.iosName,);
      var mail = StorageRepository.getString(StoreKeys.iosMail,);

      final authParams = AuthParams(email: mail, fullName: name, uid: uid??'Null_name', photoUrl: '');

      final result = await authUseCase.call(authParams);

      if (result.isRight) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
        StorageRepository.putString(StoreKeys.token, result.right.object.toString());
      } else {
        // context.read<AuthBloc>().add(GoogleAuthEvent(googleSignInAccount: account));

        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }

    }

  }
}
