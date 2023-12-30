import 'package:bloc/bloc.dart';
import 'package:brain_box/feature/settings/data/models/update_user.dart';
import 'package:brain_box/feature/settings/domain/use_cases/userDataUsecase.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user.dart';
import '../../../domain/use_cases/subscribe_premium_usecase.dart';
import '../../../domain/use_cases/update_user_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  UserdataUseCase userDataUseCase = UserdataUseCase();
  UpdateUserUseCase updateUserUseCase = UpdateUserUseCase();
  SubscribePremiumUseCase subscribePremiumUseCase = SubscribePremiumUseCase();

  SettingsBloc() : super(const SettingsState()) {
    on<GetUserDataEvent>((event, emit) async{

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await userDataUseCase.call('abdulazizni kodlarini aytvorilar');

      if(result.isRight){

        event.onSuccess(result.right);

        emit(state.copyWith(status: FormzSubmissionStatus.success));

      }

    });

    on<UpdateUseDataEven>((event,emit)async{

      event.progress();

      final result = await updateUserUseCase.call(event.user);

      if(result.isRight){

        event.success();

      }else{

        event.failure();

      }

    });

    on<SubscribePremiumEvent>((event,emit)async{

      event.progress();

      final result = await subscribePremiumUseCase.call(-1);

      if(result.isRight){

        event.success();

      }else{

        event.failure();

      }

    });
  }
}
