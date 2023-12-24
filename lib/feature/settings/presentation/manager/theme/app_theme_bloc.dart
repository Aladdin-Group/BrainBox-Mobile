import 'package:bloc/bloc.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'app_theme_event.dart';
part 'app_theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(AppThemeInitial(switchValue: StorageRepository.getBool(StoreKeys.isDark))) {
    on<SwitchOnThemeEven>((event, emit) {
      StorageRepository.putBool(key: StoreKeys.isDark, value: true);
      emit(const AppThemeState(switchValue: true));
    });
    on<SwitchOffThemeEven>((event, emit) {
      StorageRepository.putBool(key: StoreKeys.isDark, value: false);
      emit(const AppThemeState(switchValue: false));
    });
  }
}
