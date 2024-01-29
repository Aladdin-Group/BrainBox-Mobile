import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/auth/domain/use_cases/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  }

  _onIsDevMode(IsDevModeEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await isDevTestTestingModeUseCase.call(-1);

    if (result.isRight) {
      StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
      StorageRepository.putString(StoreKeys.token, result.right.object.toString());
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else {
      final googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        add(GoogleAuthEvent(googleSignInAccount: googleSignInAccount));
      }
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  _onGoogleAuth(GoogleAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await authUseCase.call(event.googleSignInAccount);

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
