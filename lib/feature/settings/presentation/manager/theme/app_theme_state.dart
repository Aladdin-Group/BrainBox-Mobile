part of 'app_theme_bloc.dart';

class AppThemeState extends Equatable {

  final bool switchValue;

  const AppThemeState({required this.switchValue});


  @override
  List<Object?> get props => [switchValue];

  AppThemeState copyWith({
    bool? switchValue,
  }) {
    return AppThemeState(
      switchValue: switchValue ?? this.switchValue,
    );
  }
}

class AppThemeInitial extends AppThemeState {
  const AppThemeInitial({required super.switchValue});
}
