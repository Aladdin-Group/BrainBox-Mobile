import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/auth/domain/use_cases/auth_usecase.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthUseCase authUseCase = AuthUseCase();

  AuthBloc() : super(const AuthState()) {

    on<GoogleAuthEvent>((event, emit) async{
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await authUseCase.call(event.googleSignInAccount);

      if(result.isRight){
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
        StorageRepository.putString(StoreKeys.token, result.right.object.toString());
      }else{
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }

    });

  }
}
