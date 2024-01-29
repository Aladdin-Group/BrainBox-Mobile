import 'package:brain_box/feature/education/presentation/education_screen.dart';
import 'package:brain_box/feature/main/presentation/main_screen.dart';
import 'package:brain_box/feature/reminder/presentation/reminder_screen.dart';
import 'package:brain_box/feature/settings/presentation/settings_screen.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// part 'navigation_state.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  List<NavigationDestination> bottomNavigationBars = <NavigationDestination>[
    NavigationDestination(
      tooltip: LocaleKeys.home.tr(),
      icon: const Icon(Icons.home_filled),
      label: LocaleKeys.home.tr(),
    ),
    NavigationDestination(
      tooltip: LocaleKeys.education.tr(),
      icon: const Icon(Icons.school),
      label: LocaleKeys.education.tr(),
    ),
    NavigationDestination(
      tooltip: LocaleKeys.reminder.tr(),
      icon: const Icon(Icons.notifications),
      label: LocaleKeys.reminder.tr(),
    ),
    NavigationDestination(
      tooltip: LocaleKeys.settings.tr(),
      icon: const Icon(Icons.settings),
      label: LocaleKeys.settings.tr(),
    ),
  ];
  List<Widget> pages = [
    const MainScreen(),
    const EducationScreen(),
    const ReminderScreen(),
    const SettingsScreen(),
  ];

  void changeIndex(int index) => emit(index);
}
