import 'package:bloc/bloc.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/settings/data/models/language_model.dart';
import 'package:brain_box/feature/settings/data/models/update_user.dart';
import 'package:brain_box/feature/settings/data/repositories/language_repo.dart';
import 'package:brain_box/feature/settings/domain/use_cases/userDataUsecase.dart';
import 'package:brain_box/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user.dart';
import '../../../domain/use_cases/subscribe_premium_usecase.dart';
import '../../../domain/use_cases/update_user_usecase.dart';
import 'package:easy_localization/easy_localization.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  UserdataUseCase userDataUseCase = UserdataUseCase();
  UpdateUserUseCase updateUserUseCase = UpdateUserUseCase();
  SubscribePremiumUseCase subscribePremiumUseCase = SubscribePremiumUseCase();

  SettingsBloc() : super(SettingsState(languageModel: LanguageRepository.uz)) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<SettingsInitialEvent>(_onSettingsInitial);
    on<GetUserDataEvent>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final result = await userDataUseCase.call('abdulazizni kodlarini aytvorilar');

      if (result.isRight) {
        // event.onSuccess(result.right);
        // (userData) {
        //    isInit.value = true;
        //    user = userData;
        //    Locale currentLocale = context.locale;
        //
        //    Access the language code (e.g., 'en', 'ru', 'fr')
        // String languageCode = currentLocale.languageCode;
        //
        // if (languageCode == 'uz') {
        //   _selectedFruit = 2;
        // } else if (languageCode == 'en') {
        //   _selectedFruit = 1;
        // } else {
        //   _selectedFruit = 0;
        // }
        //
        // setState(() {
        //   isPremium = user!.isPremium ?? false;
        // });
        // })),

        emit(state.copyWith(status: FormzSubmissionStatus.success, user: result.right));
      }
    });

    on<UpdateUseDataEven>((event, emit) async {
      event.progress();

      final result = await updateUserUseCase.call(event.user);

      if (result.isRight) {
        event.success();
      } else {
        event.failure();
      }
    });

    on<SubscribePremiumEvent>((event, emit) async {
      event.progress();

      final result = await subscribePremiumUseCase.call(-1);

      if (result.isRight) {
        event.success();
      } else {
        event.failure();
      }
    });
  }

  void _onChangeLanguage(ChangeLanguageEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(languageModel: event.languageModel));
    navigatorKey.currentContext?.setLocale(event.languageModel.locale);
    StorageRepository.putString(StoreKeys.appLang, event.languageModel.shortName);
  }

  void _onSettingsInitial(SettingsInitialEvent event, Emitter<SettingsState> emit) {
    final appLanguage = StorageRepository.getString(StoreKeys.appLang);
    switch (appLanguage) {
      case 'ru':
        emit(state.copyWith(languageModel: LanguageRepository.ru));
        break;
      case 'en':
        emit(state.copyWith(languageModel: LanguageRepository.en));
        break;
      case 'uz':
        emit(state.copyWith(languageModel: LanguageRepository.uz));
        break;
    }
  }
}
