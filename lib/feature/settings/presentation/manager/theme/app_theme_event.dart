part of 'app_theme_bloc.dart';

@immutable
abstract class AppThemeEvent {}

class SwitchOnThemeEven extends AppThemeEvent{}

class SwitchOffThemeEven extends AppThemeEvent{}