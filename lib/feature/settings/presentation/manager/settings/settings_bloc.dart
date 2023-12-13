import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/settings/domain/use_cases/userDataUsecase.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  UserdataUseCase userDataUseCase = UserdataUseCase();

  SettingsBloc() : super(const SettingsState()) {
    on<GetUserDataEvent>((event, emit) async{

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await userDataUseCase.call('abdulazizni kodlarini aytvorilar');

      if(result.isRight){

        event.onSuccess(result.right);

        emit(state.copyWith(status: FormzSubmissionStatus.success));

      }

    });
  }
}
